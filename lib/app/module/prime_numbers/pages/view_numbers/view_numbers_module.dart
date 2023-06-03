import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_page.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class ViewNumbersModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => PrimesNumberService())
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => ViewNumbersPage(numbersPrime: args.data['numbersPrime'],)),
  ];
}