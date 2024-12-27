import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/booking_button.dart';

class HotelComponent extends StatefulWidget {
  final HotelModel hotelModel;
  final VoidCallback onPressed; // Add onPressed parameter

  const HotelComponent({
    super.key,
    required this.onPressed,
    required this.hotelModel,
  });

  @override
  State<HotelComponent> createState() => _HotelComponentState();
}

class _HotelComponentState extends State<HotelComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 0, top: 10, bottom: 10, left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.hotelModel.hotelImage,
                  height: 100,
                  width: 100,
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
                      MyTextStyle.truncateString(
                          widget.hotelModel.hotelName, 80),
                      style: MyTextStyle.textStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.hotelModel.areaModel.areaName,
                      style: MyTextStyle.textStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(height: 0),
                        children: [
                          TextSpan(
                            text:
                                "${AppFunctions.formatNumber(widget.hotelModel.rooms.first.roomTypes.first.typeRoomPrice)}đ",
                            style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ColorData.myColor,
                            ),
                          ),
                          TextSpan(
                            text: " /night",
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
            Padding(
              padding: const EdgeInsets.only(top: 65, right: 10),
              child: BookingButton(
                onPressed: widget.onPressed,
                text: "Booking",
                color: ColorData.myColor,
                icon: FontAwesomeIcons.plus,
                textColor: Colors.white,
                isIcon: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
