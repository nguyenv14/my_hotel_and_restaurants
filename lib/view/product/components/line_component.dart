import 'package:flutter/material.dart';

class LineComponent extends StatelessWidget {
  const LineComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.2))),
    );
  }
}
