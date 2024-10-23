import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final bool isIcon;

  const BookingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // default color
    this.textColor = Colors.white, // default text color
    this.icon,
    this.isIcon = false, // default no icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Điều chỉnh padding
        minimumSize: const Size(8, 8), // Giảm kích thước tối thiểu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      icon: isIcon && icon != null
          ? Icon(
              icon,
              color: textColor,
              size: 10,
            )
          : const SizedBox.shrink(),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }
}
