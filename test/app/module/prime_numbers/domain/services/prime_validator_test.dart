import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_validator.dart';

void main() {
  const validator = PrimeValidator();

  test('PrimeValidator reconhece primos basicos', () {
    expect(validator.isPrime(2), isTrue);
    expect(validator.isPrime(3), isTrue);
    expect(validator.isPrime(5), isTrue);
    expect(validator.isPrime(7), isTrue);
  });

  test('PrimeValidator rejeita negativos, zero e um', () {
    expect(validator.isPrime(-3), isFalse);
    expect(validator.isPrime(0), isFalse);
    expect(validator.isPrime(1), isFalse);
  });

  test('PrimeValidator rejeita pares maiores que dois e compostos classicos', () {
    expect(validator.isPrime(4), isFalse);
    expect(validator.isPrime(9), isFalse);
    expect(validator.isPrime(21), isFalse);
  });
}
