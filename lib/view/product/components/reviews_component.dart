import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/evaluate_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';

class ReviewComponent extends StatefulWidget {
  final HotelModel hotelModel;
  const ReviewComponent({super.key, required this.hotelModel});

  @override
  State<ReviewComponent> createState() => _ReviewComponentState();
}

class _ReviewComponentState extends State<ReviewComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: MyTextStyle.textStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                child: Text(
                  "See all >",
                  style:
                      MyTextStyle.textStyle(fontSize: 14, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        widget.hotelModel.evaluates!.length != 0
            ? Container(
                padding: EdgeInsets.only(left: 10),
                width: context.mediaQueryWidth,
                height: context.mediaQueryHeight * 0.2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.hotelModel.evaluates!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return itemReviews(widget.hotelModel.evaluates![index]);
                  },
                ),
              )
            : Container(
                width: context.mediaQueryWidth,
                height: context.mediaQueryHeight * 0.2,
                child: Column(
                  children: [
                    Lottie.asset("assets/raw/empty.json", width: 100),
                    Text(
                      "Chưa có đánh giá!",
                      style: MyTextStyle.textStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget itemReviews(EvaluateModel evaluateModel) {
    return Container(
      width: context.mediaQueryWidth * 0.74,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(FontAwesomeIcons.solidUser),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        evaluateModel.customerName,
                        style: MyTextStyle.textStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 20,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Icon(
                              FontAwesomeIcons.solidStar,
                              color: index <
                                      AppFunctions.calculateStarEvaluate(
                                          evaluateModel)
                                  ? Colors.amber
                                  : Colors.amber.withOpacity(0.4),
                              size: 12,
                            ),
                          );
                        },
                        itemCount: 5,
                      ),
                    ),
                  ],
                ),
              ]),
              Text(
                AppFunctions.convertDateTimeToDay(evaluateModel.createdAt),
                style: MyTextStyle.textStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            evaluateModel.evaluateContent,
            style: MyTextStyle.textStyle(fontSize: 13),
          )
        ],
      ),
    );
  }
}
