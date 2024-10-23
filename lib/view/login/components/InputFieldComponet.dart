import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';

class InputFieldComponent extends StatefulWidget {
  final IconData iconData;
  final String hintText;
  final String titleText;
  final TextEditingController textEditingController;
  final Color color;
  // final Widget widgetPass;
  final bool isPassword;

  const InputFieldComponent(
      {super.key,
      required this.iconData,
      required this.hintText,
      required this.textEditingController,
      required this.color,
      this.isPassword = false,
      required this.titleText});
//
  // TextEditingController get controller => textEditingController;

  @override
  State<InputFieldComponent> createState() => _InputFieldComponentState();
}

class _InputFieldComponentState extends State<InputFieldComponent> {
  final FocusNode _focusNode = FocusNode();
  bool password = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: ColorData.backGroundColorTextField,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.iconData,
            size: 20,
            color: ColorData.myColor,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titleText,
                style: MyTextStyle.textStyle(fontSize: 14, color: Colors.grey),
              ),
              Container(
                width: context.mediaQueryWidth * 0.6,
                height: 30,
                child: widget.isPassword == false
                    ? TextField(
                        controller: widget.textEditingController,
                        style: MyTextStyle.textStyle(
                            fontSize: 16, color: ColorData.myColor),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: MyTextStyle.textStyle(
                                fontSize: 12, color: ColorData.myColor)),
                      )
                    : TextField(
                        controller: widget.textEditingController,
                        obscureText: password,
                        style: MyTextStyle.textStyle(
                            fontSize: 16, color: ColorData.myColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: MyTextStyle.textStyle(
                              fontSize: 12, color: ColorData.myColor),
                        ),
                      ),
              )
            ],
          ),
          widget.isPassword == true
              ? GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        password = !password;
                      },
                    );
                  },
                  child: Icon(
                      password ? Icons.visibility : Icons.visibility_off,
                      color: ColorData.myColor),
                )
              : Container(),
        ],
      ),
    );
  }
}
