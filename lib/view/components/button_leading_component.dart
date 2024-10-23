import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';

class ButtonLeadingComponent extends StatefulWidget {
  final IconData iconData;
  final VoidCallback? onPress;
  final Color? color;
  const ButtonLeadingComponent(
      {super.key, required this.iconData, this.onPress, this.color});

  @override
  State<ButtonLeadingComponent> createState() => _ButtonLeadingComponentState();
}

class _ButtonLeadingComponentState extends State<ButtonLeadingComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            border: Border.all(color: ColorData.greyBorderColor),
            borderRadius: BorderRadius.circular(15)),
        child: Icon(
          widget.iconData,
          color: widget.color ?? ColorData.myColor,
          size: 18,
        ),
      ),
    );
  }
}
