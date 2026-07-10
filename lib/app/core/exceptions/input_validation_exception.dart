class InputValidationException implements Exception {
  InputValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
