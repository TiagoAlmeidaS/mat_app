import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';

abstract class PrimeNumberCalculator {
  Future<PrimeCalculationResult> calculate(PrimeCalculationRequest request);
}
