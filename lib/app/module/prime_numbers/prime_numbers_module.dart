import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/core/services/usage_gate_service.dart';
import 'package:mat_app/app/core/stores/user_access_store.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_calculation_service.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_range_generator.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_validator.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_page.dart';
import 'package:mat_app/app/module/prime_numbers/presentation/stores/prime_numbers_store.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_page.dart';

class PrimeNumbersModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => const PrimeValidator()),
        Bind.singleton((i) => PrimeRangeGenerator(i())),
        Bind.singleton((i) => PrimeCalculationService(i())),
        Bind.factory(
          (i) => PrimeNumbersStore(
            i<PrimeCalculationService>(),
            i<UsageGateService>(),
            i<UserAccessStore>(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const PrimeNumbersPage(),
        ),
        ChildRoute(
          '/result',
          child: (context, args) => ViewNumbersPage(
            result: args.data as PrimeCalculationResult,
          ),
        ),
      ];
}
