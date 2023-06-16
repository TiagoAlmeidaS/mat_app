import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class ViewNumbersPage extends StatefulWidget {
  ViewNumbersPage({required this.numbersPrime});

  List<int> numbersPrime;

  @override
  State<ViewNumbersPage> createState() => _ViewNumbersPageState();
}

class _ViewNumbersPageState extends State<ViewNumbersPage> {
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                        onTap: () => Modular.to.pop(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Números primos encontrados",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 4,
              children: widget.numbersPrime
                  .map((e) => Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 1, horizontal: 5),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Modular.get<ColorTheme>().secondaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$e",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
