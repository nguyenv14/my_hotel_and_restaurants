import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextStyle {
  static TextStyle textStyle({
    Color color = Colors.black,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Ẩn text khi quá dài thành ...
  static String truncateString(String str, int maxLength) {
    return (str.length <= maxLength)
        ? str
        : '${str.substring(0, maxLength)}...';
  }
}
