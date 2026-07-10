import 'package:mat_app/app/module/prime_numbers/domain/services/prime_validator.dart';

class PrimeRangeGenerator {
  const PrimeRangeGenerator(this._validator);

  final PrimeValidator _validator;

  List<int> generate(int start, int end) {
    final primeNumbers = <int>[];

    for (var value = start; value <= end; value++) {
      if (_validator.isPrime(value)) {
        primeNumbers.add(value);
      }
    }

    return primeNumbers;
  }
}
