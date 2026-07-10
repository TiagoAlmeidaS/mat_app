import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/core/config/access_policy_config.dart';
import 'package:mat_app/app/core/models/usage_gate_decision.dart';
import 'package:mat_app/app/core/models/user_access_state.dart';
import 'package:mat_app/app/core/services/usage_gate_service.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';

void main() {
  const config = AccessPolicyConfig(
    freeMaxRangeSoft: 10,
    freeMaxRangeRewarded: 20,
    proMaxRange: 100,
  );
  const service = UsageGateService(config: config);

  test('UsageGateService permite calculo dentro do limite gratuito', () {
    const request = PrimeCalculationRequest(start: 1, end: 10);

    final decision = service.evaluate(request, const UserAccessState.free());

    expect(decision.action, UsageGateAction.allow);
    expect(decision.isAllowed, isTrue);
  });

  test('UsageGateService exige rewarded acima do limite gratuito', () {
    const request = PrimeCalculationRequest(start: 1, end: 15);

    final decision = service.evaluate(request, const UserAccessState.free());

    expect(decision.action, UsageGateAction.requireRewardedAccess);
    expect(decision.allowedRangeMax, 20);
  });

  test('UsageGateService exige premium acima do limite recompensado', () {
    const request = PrimeCalculationRequest(start: 1, end: 25);

    final decision = service.evaluate(request, const UserAccessState.free());

    expect(decision.action, UsageGateAction.requirePremium);
    expect(decision.allowedRangeMax, 100);
  });

  test('UsageGateService permite rewarded enquanto acesso temporario estiver ativo', () {
    const request = PrimeCalculationRequest(start: 1, end: 20);
    final accessState = UserAccessState(
      plan: UserPlan.rewarded,
      rewardedAccessExpiresAt: DateTime(2099),
    );

    final decision = service.evaluate(request, accessState);

    expect(decision.action, UsageGateAction.allow);
  });

  test('UsageGateService permite qualquer intervalo valido para Pro dentro do teto do app', () {
    const request = PrimeCalculationRequest(start: 1, end: 100);
    const accessState = UserAccessState(plan: UserPlan.pro);

    final decision = service.evaluate(request, accessState);

    expect(decision.action, UsageGateAction.allow);
  });
}
