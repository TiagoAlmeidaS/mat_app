import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/pages/view_numbers/view_numbers_module.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_module.dart';
import 'package:mat_app/app/module/splash/splash_page.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [Bind<ColorTheme>((i) => ColorTheme())];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => SplashPage()),
        ModuleRoute(
          '/prime-numbers',
          module: PrimeNumbersModule(),
        ),
        ModuleRoute(
          '/view-numbers/',
          module: ViewNumbersModule(),
        )
      ];
}
