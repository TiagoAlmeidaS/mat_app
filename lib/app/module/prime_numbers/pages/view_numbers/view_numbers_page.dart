import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class ViewNumbersPage extends StatelessWidget {
  const ViewNumbersPage({Key? key, required this.result}) : super(key: key);

  final PrimeCalculationResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Modular.get<ColorTheme>().primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Modular.to.pop(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Numeros primos encontrados',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intervalo: ${result.request.start} a ${result.request.end}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Total encontrado: ${result.totalCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (result.elapsedTime != null)
                          Text(
                            'Tempo de calculo: ${result.elapsedTime!.inMilliseconds} ms',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        if (result.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Nenhum numero primo foi encontrado nesse intervalo.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (!result.isEmpty)
              SliverGrid.count(
                crossAxisCount: 4,
                children: result.primeNumbers
                    .map(
                      (value) => Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 1,
                            horizontal: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Modular.get<ColorTheme>().secondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$value',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Modular.to.pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Modular.get<ColorTheme>().secondaryColor,
                    ),
                  ),
                  child: const Text('Novo calculo'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
