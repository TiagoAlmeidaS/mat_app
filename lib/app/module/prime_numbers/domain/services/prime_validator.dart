import 'dart:math';

class PrimeValidator {
  const PrimeValidator();

  bool isPrime(int value) {
    if (value < 2) {
      return false;
    }

    if (value == 2) {
      return true;
    }

    if (value % 2 == 0) {
      return false;
    }

    final limit = sqrt(value).floor();
    for (var divisor = 3; divisor <= limit; divisor += 2) {
      if (value % divisor == 0) {
        return false;
      }
    }

    return true;
  }
}
