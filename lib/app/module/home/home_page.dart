import 'package:flutter/material.dart';
import 'package:mat_app/app/shared/mat_theme/components/card_horizontal.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CardHorizontal(
            label: "Números Primos 2",
            action: () {},
            cardHorizontalState: CardHorizontalState.loading,
          ),
          Container(child: Row(
              children: const [
                Icon(
                  Icons.seven_k,
                  size: 20,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Números Primos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF606170).withOpacity(0.16),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}
