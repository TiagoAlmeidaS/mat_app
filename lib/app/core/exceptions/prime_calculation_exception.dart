class PrimeCalculationException implements Exception {
  PrimeCalculationException(this.message);

  final String message;

  @override
  String toString() => message;
}
