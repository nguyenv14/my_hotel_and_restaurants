import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/view/components/booking_button.dart';
import 'package:my_hotel_and_restaurants/view/components/button_main_component.dart';

class CardOrderComponent extends StatelessWidget {
  final String hotelName;
  final String imageUrl;
  final String orderDate;
  final String viewType;
  final int person;
  final int rooms;
  final double price;
  final String status;
  final VoidCallback onPressed;

  const CardOrderComponent({
    Key? key,
    required this.hotelName,
    required this.imageUrl,
    required this.orderDate,
    required this.viewType,
    required this.person,
    required this.rooms,
    required this.price,
    required this.status,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 135,
                      height: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Hotel information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          MyTextStyle.truncateString(hotelName, 14),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Date Range
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              orderDate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // View Type
                        Row(
                          children: [
                            const Icon(Icons.visibility,
                                size: 20, color: ColorData.myColor),
                            const SizedBox(width: 5),
                            Text(
                              viewType,
                              style: const TextStyle(
                                fontSize: 20,
                                color: ColorData.myColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Person and Room information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.userGroup,
                          color: ColorData.myColor, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "$person person",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.bed,
                        size: 16,
                        color: ColorData.myColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$rooms room",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Price and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status (e.g., Completed)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: const Text(
                      "Completed",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Price
                  BookingButton(
                    text: "12.000.000đ",
                    color: ColorData.myColor,
                    textColor: Colors.white,
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 12),
              // Booking button
              ButtonMainComponent(
                buttonText: "Completed",
                buttonColor: Colors.white,
                textColor: ColorData.myColor,
                onPressed: () {
                  //
                  print("xu ly");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
