import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_page.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

import '../../shared/services/primes_numbers_service/prime_numbers_v2_service.dart';

class PrimeNumbersModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => PrimesNumberService()),
    Bind((i) => PrimeNumberV2Service()),
  ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => PrimeNumbersPage(),
        ),
      ];
}
