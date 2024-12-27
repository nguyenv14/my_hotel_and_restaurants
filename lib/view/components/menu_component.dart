import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';

class MenuComponent extends StatefulWidget {
  final String imageUrl;
  final String nameMeal;
  final double price;

  const MenuComponent({
    super.key,
    required this.imageUrl,
    required this.nameMeal,
    required this.price,
  });

  @override
  State<MenuComponent> createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align items to the top
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 0, top: 10, bottom: 10, left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyTextStyle.truncateString(widget.nameMeal, 10),
                      style: MyTextStyle.textStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(height: 0),
                        children: [
                          TextSpan(
                            text: "${widget.price} đ",
                            style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ColorData.myColor,
                            ),
                          ),
                          TextSpan(
                            text: "/dish",
                            style: MyTextStyle.textStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
