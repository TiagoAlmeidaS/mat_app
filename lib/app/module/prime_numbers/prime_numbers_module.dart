import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_page.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers_direct/view_numbers_direct_page.dart';
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
        ChildRoute('/', child: (context, args) => const PrimeNumbersPage()),
        ChildRoute('/view', child: (context, args) => ViewNumbersPage(
          startNumber: args.data['startNumber'],
          endNumber: args.data['endNumber'],
        )),
        ChildRoute('/view-direct', child: (context, args) => ViewNumbersDirectPage(
          startNumber: args.data['startNumber'],
          endNumber: args.data['endNumber'],
        )),
      ];
}
