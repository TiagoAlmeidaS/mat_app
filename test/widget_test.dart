import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/core/config/access_policy_config.dart';
import 'package:mat_app/app/core/services/usage_gate_service.dart';
import 'package:mat_app/app/core/stores/user_access_store.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_number_calculator.dart';
import 'package:mat_app/app/module/prime_numbers/presentation/stores/prime_numbers_store.dart';

class _DelayedCalculator implements PrimeNumberCalculator {
  @override
  Future<PrimeCalculationResult> calculate(
    PrimeCalculationRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return PrimeCalculationResult(
      request: request,
      primeNumbers: const [2, 3, 5, 7],
    );
  }
}

void main() {
  const config = AccessPolicyConfig(
    freeMaxRangeSoft: 10,
    freeMaxRangeRewarded: 20,
    proMaxRange: 100,
  );

  test('PrimeNumbersStore valida campos vazios antes do calculo', () async {
    final store = PrimeNumbersStore(
      _DelayedCalculator(),
      const UsageGateService(config: config),
      UserAccessStore(config: config),
    );

    final success = await store.submit();

    expect(success, isFalse);
    expect(store.inputError, 'Informe os dois numeros do intervalo.');
  });

  test('PrimeNumbersStore alterna loading e guarda resultado', () async {
    final store = PrimeNumbersStore(
      _DelayedCalculator(),
      const UsageGateService(config: config),
      UserAccessStore(config: config),
    );

    store.updateStart('1');
    store.updateEnd('10');

    final future = store.submit();

    expect(store.isLoading, isTrue);

    final success = await future;

    expect(success, isTrue);
    expect(store.isLoading, isFalse);
    expect(store.result?.primeNumbers, const [2, 3, 5, 7]);
  });

  test('PrimeNumbersStore bloqueia intervalo que exige rewarded no modo gratuito', () async {
    final store = PrimeNumbersStore(
      _DelayedCalculator(),
      const UsageGateService(config: config),
      UserAccessStore(config: config),
    );

    store.updateStart('1');
    store.updateEnd('15');

    final success = await store.submit();

    expect(success, isFalse);
    expect(store.inputError, contains('limite gratuito'));
  });

  test('PrimeNumbersStore permite intervalo expandido apos liberar acesso rewarded', () async {
    final userAccessStore = UserAccessStore(config: config);
    final store = PrimeNumbersStore(
      _DelayedCalculator(),
      const UsageGateService(config: config),
      userAccessStore,
    );

    store.updateStart('1');
    store.updateEnd('15');
    userAccessStore.activateRewardedAccess();

    final success = await store.submit();

    expect(success, isTrue);
    expect(store.result?.primeNumbers, const [2, 3, 5, 7]);
  });
}
