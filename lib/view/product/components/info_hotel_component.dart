import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';

class InfoHotelComponent extends StatefulWidget {
  final HotelModel hotelModel;
  const InfoHotelComponent({super.key, required this.hotelModel});

  @override
  State<InfoHotelComponent> createState() => _InfoHotelComponentState();
}

class _InfoHotelComponentState extends State<InfoHotelComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 30,
              width: 100,
              child: ListView.builder(
                itemCount: widget.hotelModel.hotelRank,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => const Icon(
                  Icons.star_border,
                  color: Color.fromRGBO(251, 188, 5, 1),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                FontAwesomeIcons.solidHeart,
                color: ColorData.myColor,
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
                  widget.hotelModel.hotelName,
                  style: MyTextStyle.textStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      color: ColorData.myColor,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.hotelModel.areaModel.areaName,
                      style: MyTextStyle.textStyle(
                          fontSize: 14, color: ColorData.greyTextColor),
                    )
                  ],
                ),
              ],
            ),

            //  RichText(
            //       text: TextSpan(
            //         children: [
            //           TextSpan(
            //             text: '2.500.000đ',
            //             style: MyTextStyle.textStyle(
            //                 color: ColorData.myColor,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           TextSpan(
            //             text: '/night',
            //             style: MyTextStyle.textStyle(
            //               color: ColorData.greyTextColor,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: MyTextStyle.textStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorData.myColor),
            ),
            const SizedBox(height: 5),
            Text(
              widget.hotelModel.hotelDesc,
              style: MyTextStyle.textStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.justify,
            )
          ],
        )
      ],
    );
  }
}
