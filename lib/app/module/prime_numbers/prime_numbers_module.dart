import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_module.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_page.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class PrimeNumbersModule extends Module {
  @override
  List<Bind> get binds => [Bind((i) => PrimesNumberService())];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => PrimeNumbersPage(),
        ),
      ];
}
