import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_range_generator.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_validator.dart';

void main() {
  final generator = PrimeRangeGenerator(const PrimeValidator());

  test('PrimeRangeGenerator retorna primos em intervalo pequeno', () {
    final result = generator.generate(1, 10);

    expect(result, const [2, 3, 5, 7]);
  });

  test('PrimeRangeGenerator lida com intervalo unitario', () {
    final result = generator.generate(11, 11);

    expect(result, const [11]);
  });

  test('PrimeRangeGenerator retorna vazio quando nao ha primos', () {
    final result = generator.generate(14, 16);

    expect(result, isEmpty);
  });
}
