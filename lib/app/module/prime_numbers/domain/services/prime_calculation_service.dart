import 'package:mat_app/app/core/exceptions/input_validation_exception.dart';
import 'package:mat_app/app/core/exceptions/prime_calculation_exception.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_number_calculator.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_range_generator.dart';

class PrimeCalculationService implements PrimeNumberCalculator {
  PrimeCalculationService(this._generator);

  final PrimeRangeGenerator _generator;

  @override
  Future<PrimeCalculationResult> calculate(
    PrimeCalculationRequest request,
  ) async {
    if (!request.isValid) {
      throw InputValidationException('O intervalo informado e invalido.');
    }

    try {
      final stopwatch = Stopwatch()..start();
      final primeNumbers = _generator.generate(request.start, request.end);
      stopwatch.stop();

      return PrimeCalculationResult(
        request: request,
        primeNumbers: List<int>.unmodifiable(primeNumbers),
        elapsedTime: stopwatch.elapsed,
        usedOptimizedPath: request.intervalLength <= 1000,
      );
    } catch (_) {
      throw PrimeCalculationException(
        'Nao foi possivel calcular os numeros primos neste intervalo.',
      );
    }
  }
}
