import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';
import 'package:mat_app/app/shared/mat_theme/components/text_field_component.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class PrimeNumbersPage extends StatefulWidget {
  const PrimeNumbersPage({Key? key}) : super(key: key);

  @override
  State<PrimeNumbersPage> createState() => _PrimeNumbersPageState();
}

class _PrimeNumbersPageState extends State<PrimeNumbersPage> {

  TextEditingController controllerNumber1 = TextEditingController();
  TextEditingController controllerNumber2 = TextEditingController();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Números primos",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Regras", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              Text("1. O número 1 não é primo.", style: TextStyle(color: Colors.white),),
              Text("2. O número 2 é o único número primo que é par.", style: TextStyle(color: Colors.white),),
              Text("3. Um número primo é um número natural maior que 1, que tem apenas dois divisores positivos: 1 e ele mesmo.", style: TextStyle(color: Colors.white),),
              Text("4. O número 3 é o único número primo que é múltiplo de 1.", style: TextStyle(color: Colors.white),),
              Text("5. O usuário pode inserir um intervalo de números inteiros para calcular todos os números primos dentro desse intervalo.", style: TextStyle(color: Colors.white),),
              Text("6. Para intervalos até 49, o aplicativo usa uma lista otimizada de números primos, garantindo um resultado mais rápido.", style: TextStyle(color: Colors.white),),
              Text("7. Se o intervalo for maior igual a 50, o aplicativo realiza cálculos avançados para identificar os números primos de forma precisa.", style: TextStyle(color: Colors.white),),
            ],
          ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
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
                child: TextFieldComponent(controller: controllerNumber1,),
              ),
              Text("à", style: TextStyle(color: Colors.white),),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldComponent(controller: controllerNumber2,),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                var lista = Modular.get<PrimesNumberService>.call().listPrimesNumbers(int.parse(controllerNumber1.text), int.parse(controllerNumber2.text));
                Modular.to.pushNamed('/view-numbers/', arguments: {'numbersPrime': lista});
              },
              child: Text("Calcular"),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Modular.get<ColorTheme>().secondaryColor),
              ),
            ),
          ),
        ],
      ),

        )));
        
    }
}
