import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/view/components/booking_button.dart';
import 'package:my_hotel_and_restaurants/view/components/button_favorite_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';

class HotelCard extends StatefulWidget {
  final HotelModel hotelModel;
  final FavouriteViewModel favouriteViewModel;
  final VoidCallback onPressed; // Thêm tham số onPressed

  const HotelCard({
    Key? key,
    required this.onPressed,
    required this.hotelModel,
    required this.favouriteViewModel,
  }) : super(key: key);

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: 270,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    widget.hotelModel.hotelImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                FavoriteButton(
                  hotelId: widget.hotelModel.hotelId,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.solidStar,
                          size: 15,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.hotelModel.hotelRank.toString(),
                          style: MyTextStyle.textStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(height: 0),
                        children: [
                          TextSpan(
                            text:
                                "${widget.hotelModel.rooms.first.roomTypes.first.typeRoomPrice}đ",
                            style: MyTextStyle.textStyle(
                              fontSize: 15,
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
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyTextStyle.truncateString(
                              widget.hotelModel.hotelName, 20),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: ColorData.myColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.hotelModel.areaModel.areaName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    BookingButton(
                      onPressed: widget.onPressed,
                      text: "Booking",
                      color: ColorData.myColor,
                      icon: FontAwesomeIcons.plus,
                      textColor: Colors.white,
                      isIcon: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
