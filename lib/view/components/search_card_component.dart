import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/search_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/booking_button.dart';
import 'package:my_hotel_and_restaurants/view/components/button_favorite_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class SearchCardComponent extends StatefulWidget {
  final SearchModel searchModel;
  final VoidCallback onPressed;

  const SearchCardComponent({
    super.key,
    required this.onPressed,
    required this.searchModel,
  });

  @override
  State<SearchCardComponent> createState() => _SearchCardComponentState();
}

class _SearchCardComponentState extends State<SearchCardComponent> {
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
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
                    widget.searchModel.searchImage,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                FavoriteButton(
                  hotelId: widget.searchModel.id,
                  type: widget.searchModel.type!,
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
                          widget.searchModel.searchRank.toString(),
                          style: MyTextStyle.textStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    widget.searchModel.searchPrice != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(height: 0),
                              children: [
                                TextSpan(
                                  text:
                                      "${AppFunctions.formatNumber(widget.searchModel.searchPrice!)}đ",
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
                        : Container()
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
                              widget.searchModel.searchName, 30),
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
                              widget.searchModel.areaName,
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
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
