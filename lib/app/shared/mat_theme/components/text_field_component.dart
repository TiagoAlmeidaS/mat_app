import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent({
    Key? key,
    required this.controller,
    this.labelText,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
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
    );
  }
}
