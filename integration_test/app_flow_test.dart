import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/app_module.dart';
import 'package:mat_app/app/app_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo principal calcula e exibe numeros primos', (tester) async {
    await tester.pumpWidget(
      ModularApp(
        module: AppModule(),
        child: AppWidget(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Numeros primos'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.enterText(find.byType(TextField).at(1), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Numeros primos encontrados'), findsOneWidget);
    expect(find.text('Intervalo: 1 a 10'), findsOneWidget);
    expect(find.text('Total encontrado: 4'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text('3'), findsWidgets);
    expect(find.text('5'), findsWidgets);
    expect(find.text('7'), findsWidgets);
  });

  testWidgets('fluxo bloqueia intervalo expandido no modo gratuito e libera com rewarded simulado', (tester) async {
    await tester.pumpWidget(
      ModularApp(
        module: AppModule(),
        child: AppWidget(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.enterText(find.byType(TextField).at(1), '15000');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.textContaining('limite gratuito'), findsOneWidget);

    await tester.tap(find.text('Simular rewarded'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Numeros primos encontrados'), findsOneWidget);
  });
}
