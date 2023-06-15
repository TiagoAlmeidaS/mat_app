import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class TextFieldComponent extends StatelessWidget {
  TextFieldComponent({Key? key, required this.controller}) : super(key: key);

  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          fillColor: Theme.of(context).cardColor,
        ),
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 20,
          color: Modular.get<ColorTheme>().primaryColor,
        ),
      ),
    );
  }
}
