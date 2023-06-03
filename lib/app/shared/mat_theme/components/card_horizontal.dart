import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardHorizontal extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final Function() action;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final CardHorizontalState? cardHorizontalState;

  const CardHorizontal({
    Key? key,
    required this.label,
    this.iconData,
    required this.action,
    this.margin,
    this.padding,
    this.cardHorizontalState = CardHorizontalState.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cardHorizontalState == CardHorizontalState.loading
        ? widgetLoading(context)
        : GestureDetector(
      onTap: action,
      child: Container(
        child: Row(
          children: [
            if(iconData != null) ...{
              Icon(
                iconData,
                size: 20,
              ),
            },
            const SizedBox(
              width: 20,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        margin: margin ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }

  Widget widgetLoading(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
        height: 100,
        width: MediaQuery.of(context).size.width,
      ),
      baseColor: Colors.grey[300] ?? Colors.red,
      highlightColor: Colors.grey[100] ?? Colors.red,
    );
  }
}

enum CardHorizontalState {
  standard,
  loading,
}
