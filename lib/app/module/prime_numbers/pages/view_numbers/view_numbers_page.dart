import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color.fromRGBO(246, 242, 251, 0.5),
          ),
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () => Modular.to.pop(),
                  ),
                  SizedBox(width: 10,),
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
                ],
              ),
              SizedBox(height: 30,),
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.count(
                  crossAxisCount: 4,
                  children: widget.numbersPrime
                      .map((e) => Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(81, 80, 161, 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "$e",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
