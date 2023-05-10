import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/home/home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => HomePage()),
  ];
}