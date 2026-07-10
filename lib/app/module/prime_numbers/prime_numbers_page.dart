import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/presentation/stores/prime_numbers_store.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';
import 'package:mat_app/app/shared/mat_theme/components/text_field_component.dart';

class PrimeNumbersPage extends StatefulWidget {
  const PrimeNumbersPage({Key? key}) : super(key: key);

  @override
  State<PrimeNumbersPage> createState() => _PrimeNumbersPageState();
}

class _PrimeNumbersPageState extends State<PrimeNumbersPage> {
  late final TextEditingController controllerNumber1;
  late final TextEditingController controllerNumber2;
  late final PrimeNumbersStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get<PrimeNumbersStore>();
    controllerNumber1 = TextEditingController(text: store.startText);
    controllerNumber2 = TextEditingController(text: store.endText);
  }

  @override
  void dispose() {
    controllerNumber1.dispose();
    controllerNumber2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Modular.get<ColorTheme>().primaryColor,
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Numeros primos',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Regras',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '1. O numero 1 nao e primo.',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '2. O numero 2 e o unico numero primo par.',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '3. Um numero primo tem exatamente dois divisores positivos.',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '4. Informe um intervalo inteiro valido para calcular.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plano atual: ${store.currentPlanLabel}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Validacao da Fase 2',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: store.resetAccessToFree,
                              child: const Text('Modo gratuito'),
                            ),
                            OutlinedButton(
                              onPressed: store.activateSimulatedRewardedAccess,
                              child: const Text('Simular rewarded'),
                            ),
                            OutlinedButton(
                              onPressed: store.activateSimulatedProAccess,
                              child: const Text('Simular Pro'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Adicionar intervalo desejado',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFieldComponent(
                          controller: controllerNumber1,
                          labelText: 'Inicio',
                          onChanged: store.updateStart,
                        ),
                      ),
                      const Text(
                        'a',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFieldComponent(
                          controller: controllerNumber2,
                          labelText: 'Fim',
                          onChanged: store.updateEnd,
                        ),
                      ),
                    ],
                  ),
                  if (store.currentIntervalLength != null ||
                      store.gatePreviewMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (store.currentIntervalLength != null)
                            Text(
                              'Tamanho do intervalo: ${store.currentIntervalLength}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          if (store.gatePreviewMessage != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              store.gatePreviewMessage!,
                              style: TextStyle(
                                color: store.gatePreviewDecision?.isAllowed == true
                                    ? Colors.white70
                                    : Modular.get<ColorTheme>().solarColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (store.inputError != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        store.inputError!,
                        style: TextStyle(
                          color: Modular.get<ColorTheme>().solarColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (store.calculationError != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        store.calculationError!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: store.canSubmit
                          ? () async {
                              final success = await store.submit();
                              if (!mounted || !success || store.result == null) {
                                return;
                              }

                              await Modular.to.pushNamed(
                                '/prime-numbers/result',
                                arguments: store.result,
                              );
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Modular.get<ColorTheme>().secondaryColor,
                        ),
                      ),
                      child: store.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Calcular'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
