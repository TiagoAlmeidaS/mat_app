import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/mat_theme/color_theme/color_theme.dart';

class ButtonComponent extends StatelessWidget {
  const ButtonComponent(
      {Key? key,
      this.state = ButtonState.standard,
      this.action,
      required this.label})
      : super(key: key);

  final ButtonState state;
  final Function? action;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: state == ButtonState.disabled || state == ButtonState.loading
            ? null
            : () => action!(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MaterialStateColor.resolveWith(
              (states) => Modular.get<ColorTheme>().secondaryColor,
            ),
          ),
          child: Center(
            child: getChildWithState(),
          ),
        ));
  }

  Widget getChildWithState() {
    switch (state) {
      case ButtonState.standard:
        return Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),);
      case ButtonState.disabled:
        return Container(
          child: Text(label),
          color: MaterialStateColor.resolveWith(
            (states) => Modular.get<ColorTheme>().secondaryColor,
          ),
        );
      case ButtonState.loading:
        return CircularProgressIndicator(
          color: Modular.get<ColorTheme>().solarColor,
        );
    }
  }
}

enum ButtonState {
  standard,
  disabled,
  loading,
}
