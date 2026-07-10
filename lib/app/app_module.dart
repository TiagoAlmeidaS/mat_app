import 'package:mat_app/app/core/config/access_policy_config.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/core/services/usage_gate_service.dart';
import 'package:mat_app/app/core/stores/user_access_store.dart';
import 'package:mat_app/app/module/prime_numbers/prime_numbers_module.dart';
import 'package:mat_app/app/module/splash/splash_page.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<ColorTheme>((i) => ColorTheme()),
        Bind.singleton((i) => const AccessPolicyConfig()),
        Bind.singleton((i) => UserAccessStore(config: i())),
        Bind.singleton((i) => UsageGateService(config: i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => SplashPage()),
        ModuleRoute(
          '/prime-numbers',
          module: PrimeNumbersModule(),
        ),
      ];
}
