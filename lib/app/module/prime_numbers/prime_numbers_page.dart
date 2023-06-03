import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
        body: Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      width: double.maxFinite,
      color: Color.fromRGBO(246, 242, 251, 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Números primos",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color.fromRGBO(81, 80, 161, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
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
                color: Color.fromRGBO(81, 80, 161, 1),
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
              Text("à"),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextFieldComponent(controller: controllerNumber2,),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                var lista = await Modular.get<PrimesNumberService>.call().listPrimesNumbers(int.parse(controllerNumber1.text), int.parse(controllerNumber2.text));
                Modular.to.pushNamed('/view-numbers/', arguments: {'numbersPrime': lista});
              },
              child: Text("Calcular"),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromRGBO(81, 80, 161, 1)),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
