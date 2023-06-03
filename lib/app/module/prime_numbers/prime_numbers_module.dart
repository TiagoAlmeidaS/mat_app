import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_page.dart';

class PrimeNumbersModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => PrimeNumbersPage()),
  ];
}