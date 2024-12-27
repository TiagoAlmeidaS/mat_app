import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';
import 'package:mat_app/app/shared/mat_theme/components/text_field_component.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

import 'widget/button_component.dart';

class PrimeNumbersPage extends StatefulWidget {
  const PrimeNumbersPage({Key? key}) : super(key: key);

  @override
  State<PrimeNumbersPage> createState() => _PrimeNumbersPageState();
}

class _PrimeNumbersPageState extends State<PrimeNumbersPage> {
  TextEditingController controllerNumber1 = TextEditingController();
  TextEditingController controllerNumber2 = TextEditingController();

  ValueNotifier<bool> _isLoading = ValueNotifier(false);

  PrimesNumberService primeservice = Modular.get();

  @override
  void dispose() {
    controllerNumber1.dispose();
    controllerNumber2.dispose();
    _isLoading
        .dispose(); // Certifique-se de descartar o ValueNotifier para evitar vazamento de memória.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Modular.get<ColorTheme>().primaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Números primos\n",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Regras",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "1. Um número primo é um número natural maior que 1, que tem apenas dois divisores positivos: 1 e ele mesmo.",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "2. O usuário pode inserir um intervalo de números inteiros para calcular todos os números primos dentro desse intervalo.",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "3. Para o cálculo dos números primos, indicar o intervalo de números, depois em calcular.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Adicionar intervalo desejado",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFieldComponent(
                          controller: controllerNumber1,
                        ),
                      ),
                      Text(
                        "à",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFieldComponent(
                          controller: controllerNumber2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, child) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: _isLoading.value
                            ? ButtonComponent(
                                label: "",
                                state: ButtonState.loading,
                              )
                            : ButtonComponent(
                                action: () async {
                                  _isLoading.value = true;
                                  print(
                                      "Simulando cálculo de números primos...");
                                  print(_isLoading.value);

                                  try {
                                    // Simulação de uma operação demorada com Future.delayed
                                    var listNumbers = await primeservice.listPrimesNumbersV2(int.parse(controllerNumber1.text), int.parse(controllerNumber2.text));

                                    // Simula a navegação com dados fictícios
                                    await Modular.to.pushNamed(
                                      '/view-numbers/',
                                      arguments: {
                                        'numbersPrime': listNumbers
                                      },
                                    );
                                  } catch (error) {
                                    print(
                                        'Erro ao simular cálculo de números primos: $error');
                                  } finally {
                                    _isLoading.value = false;
                                    print(
                                        "Estado de loading final: ${_isLoading.value}");
                                  }
                                },
                                label: "Calcular",
                                state: _isLoading.value
                                    ? ButtonState.loading
                                    : ButtonState.standard,
                              ),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    child: Text("Exemplo de intervalo: 1 à 100",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Criadores: G&T",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Versão: 1.0.2 (202410282)",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
