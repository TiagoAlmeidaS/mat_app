import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';

void main() {
  test('PrimeCalculationRequest e valido quando inicio e fim formam intervalo inteiro', () {
    const request = PrimeCalculationRequest(start: 1, end: 10);

    expect(request.isValid, isTrue);
    expect(request.intervalLength, 10);
  });

  test('PrimeCalculationRequest e invalido quando inicio e maior que fim', () {
    const request = PrimeCalculationRequest(start: 10, end: 1);

    expect(request.isValid, isFalse);
  });

  test('PrimeCalculationRequest e invalido quando ha numeros negativos', () {
    const request = PrimeCalculationRequest(start: -1, end: 10);

    expect(request.isValid, isFalse);
  });
}
