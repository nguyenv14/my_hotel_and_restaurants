import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';

class ListImageSlider extends StatefulWidget {
  final String imagePath;
  const ListImageSlider({super.key, required this.imagePath});

  @override
  State<ListImageSlider> createState() => _ListImageSliderState();
}

class _ListImageSliderState extends State<ListImageSlider> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image(
            image: NetworkImage(widget.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
