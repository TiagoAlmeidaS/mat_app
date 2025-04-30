import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_page.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers_direct/view_numbers_direct_page.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class ViewNumbersModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => PrimesNumberService())
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => ViewNumbersPage(startNumber: args.data['startNumber'], endNumber: args.data['endNumber'],)),
    ChildRoute('/view-direct', child: (context, args) => ViewNumbersDirectPage(startNumber: args.data['startNumber'], endNumber: args.data['endNumber'],)),
  ];
}