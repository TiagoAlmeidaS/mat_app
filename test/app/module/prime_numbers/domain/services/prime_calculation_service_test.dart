import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/core/exceptions/input_validation_exception.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_calculation_service.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_range_generator.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_validator.dart';

void main() {
  late PrimeCalculationService service;

  setUp(() {
    service = PrimeCalculationService(
      PrimeRangeGenerator(const PrimeValidator()),
    );
  });

  test('PrimeCalculationService retorna resultado tipado com primos do intervalo', () async {
    const request = PrimeCalculationRequest(start: 1, end: 10);

    final result = await service.calculate(request);

    expect(result.request.start, request.start);
    expect(result.request.end, request.end);
    expect(result.primeNumbers, const [2, 3, 5, 7]);
    expect(result.totalCount, 4);
    expect(result.elapsedTime, isNotNull);
  });

  test('PrimeCalculationService falha com intervalo invalido', () async {
    const request = PrimeCalculationRequest(start: 10, end: 1);

    expect(
      () => service.calculate(request),
      throwsA(isA<InputValidationException>()),
    );
  });
}
