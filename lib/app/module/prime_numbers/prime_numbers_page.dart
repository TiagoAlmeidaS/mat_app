import 'package:flutter/material.dart';

class PrimeNumbersPage extends StatefulWidget {
  const PrimeNumbersPage({Key? key}) : super(key: key);

  @override
  State<PrimeNumbersPage> createState() => _PrimeNumbersPageState();
}

class _PrimeNumbersPageState extends State<PrimeNumbersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Números Primos"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Adicione aqui os limites:", textAlign: TextAlign.center,),)
        ],
      )
    );
  }
}
