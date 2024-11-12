import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';
import 'package:my_hotel_and_restaurants/view/components/booking_button.dart';
import 'package:my_hotel_and_restaurants/view/components/button_favorite_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';

class RestaurantCard extends StatefulWidget {
  final RestaurantModel restaurantModel;
  final FavouriteViewModel favouriteViewModel;
  final VoidCallback onFavoritePressed;
  final VoidCallback onBookingPressed;

  const RestaurantCard({
    super.key,
    required this.onFavoritePressed,
    required this.onBookingPressed,
    required this.restaurantModel,
    required this.favouriteViewModel,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 250,
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
                    widget.restaurantModel.restaurantImage,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                FavoriteButton(
                  hotelId: widget.restaurantModel.restaurantId,
                  type: 0,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating in one line
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
                          widget.restaurantModel.restaurantRank.toString(),
                          style: MyTextStyle.textStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                              widget.restaurantModel.restaurantName, 15),
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
                              widget.restaurantModel.area.areaName,
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
                      onPressed: widget.onBookingPressed, // Use the callback
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
