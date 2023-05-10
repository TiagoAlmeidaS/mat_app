import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/home/home_module.dart';
import 'package:mat_app/app/module/home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: HomeModule(),),
  ];
}