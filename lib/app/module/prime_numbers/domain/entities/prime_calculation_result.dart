import 'package:flutter/foundation.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';

class PrimeCalculationResult {
  const PrimeCalculationResult({
    required this.request,
    required this.primeNumbers,
    this.elapsedTime,
    this.usedOptimizedPath = false,
    this.warningMessage,
  });

  final PrimeCalculationRequest request;
  final List<int> primeNumbers;
  final Duration? elapsedTime;
  final bool usedOptimizedPath;
  final String? warningMessage;

  int get totalCount => primeNumbers.length;

  bool get isEmpty => primeNumbers.isEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PrimeCalculationResult &&
        other.request == request &&
        listEquals(other.primeNumbers, primeNumbers) &&
        other.elapsedTime == elapsedTime &&
        other.usedOptimizedPath == usedOptimizedPath &&
        other.warningMessage == warningMessage;
  }

  @override
  int get hashCode => Object.hash(
        request,
        Object.hashAll(primeNumbers),
        elapsedTime,
        usedOptimizedPath,
        warningMessage,
      );
}
