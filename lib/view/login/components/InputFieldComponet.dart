import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';

class InputFieldComponent extends StatefulWidget {
  final IconData iconData;
  final String hintText;
  final String titleText;
  final TextEditingController textEditingController;
  final Color color;
  final bool isPassword;
  final int? maxLines;

  const InputFieldComponent({
    super.key,
    required this.iconData,
    required this.hintText,
    required this.textEditingController,
    required this.color,
    this.isPassword = false,
    required this.titleText,
    this.maxLines = 1,
  });

  @override
  State<InputFieldComponent> createState() => _InputFieldComponentState();
}

class _InputFieldComponentState extends State<InputFieldComponent> {
  final FocusNode _focusNode = FocusNode();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText,
            style: MyTextStyle.textStyle(
                fontSize: 14,
                color: ColorData.greyTextColor,
                fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.maxLines == 1
                  ? Row(
                      children: [
                        Icon(widget.iconData, size: 20, color: widget.color),
                        const SizedBox(width: 15),
                      ],
                    )
                  : Container(),
              Expanded(
                child: TextField(
                  controller: widget.textEditingController,
                  focusNode: _focusNode,
                  maxLines: widget.maxLines,
                  obscureText: widget.isPassword && _isObscured,
                  style: MyTextStyle.textStyle(
                      fontSize: 16, color: ColorData.myColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle:
                        MyTextStyle.textStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: widget.color,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
