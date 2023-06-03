import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/home/home_page.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_module.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => HomePage()),
    ModuleRoute(
      '/prime_numbers/',
      module: PrimeNumbersModule(),
    ),
  ];
}