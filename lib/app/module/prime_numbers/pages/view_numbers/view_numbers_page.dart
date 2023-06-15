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
      body: CustomScrollView(
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
                      child: const Icon(Icons.arrow_back_ios),
                      onTap: () => Modular.to.pop(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Align(
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
              ],
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 4,
            children: widget.numbersPrime
                .map((e) => Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(81, 80, 161, 1),
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
        // child: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   decoration: const BoxDecoration(
        //     color: Color.fromRGBO(246, 242, 251, 0.5),
        //   ),
        //   width: double.maxFinite,
        //   child: Column(
        //     children: [

        //       Container(
        //         height: MediaQuery.of(context).size.height,
        //         child: GridView.count(
        //           crossAxisCount: 4,
        //           children:
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
