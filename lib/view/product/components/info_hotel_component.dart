import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class InfoHotelComponent extends StatefulWidget {
  final HotelModel hotelModel;
  const InfoHotelComponent({super.key, required this.hotelModel});

  @override
  State<InfoHotelComponent> createState() => _InfoHotelComponentState();
}

class _InfoHotelComponentState extends State<InfoHotelComponent> {
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotelModel.hotelName,
            style: MyTextStyle.textStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorData.myColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 12,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        widget.hotelModel.areaModel.areaName,
                        style: MyTextStyle.textStyle(
                                fontSize: 12, color: Colors.grey)
                            .copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Icon(
                                FontAwesomeIcons.solidStar,
                                color: index < widget.hotelModel.hotelRank
                                    ? Colors.amber
                                    : Colors.amber.withOpacity(0.4),
                                size: 12,
                              ),
                            );
                          },
                          itemCount: 5,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.pink, width: 1)),
                        child: widget.hotelModel.hotelType == 1
                            ? Text(
                                "Khách sạn",
                                style: MyTextStyle.textStyle(
                                    fontSize: 14, color: Colors.pink),
                              )
                            : (widget.hotelModel.hotelType == 2
                                ? Text(
                                    "Khách sạn căn hộ",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 14, color: Colors.pink),
                                  )
                                : Text(
                                    "Khu nghỉ dưỡng",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 14, color: Colors.pink),
                                  )),
                      ),
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (favouriteViewModel
                          .checkFavouriteId(widget.hotelModel.hotelId) ==
                      true) {
                    favouriteViewModel
                        .deleteFavouriteId(widget.hotelModel.hotelId);
                    CherryToast.success(
                      title: Text("Đã xóa ra khỏi mục yêu thích!"),
                    ).show(context);
                  } else {
                    favouriteViewModel
                        .addFavouriteId(widget.hotelModel.hotelId);
                    CherryToast.success(
                      title: Text("Đã thêm vào mục yêu thích!"),
                    ).show(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: favouriteViewModel
                              .checkFavouriteId(widget.hotelModel.hotelId) ==
                          false
                      ? Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.pinkAccent,
                          size: 17,
                        )
                      : Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.pinkAccent,
                          size: 17,
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Description",
              style: MyTextStyle.textStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorData.myColor),
            ),
          ),
          Text(
            widget.hotelModel.hotelDesc,
            style: MyTextStyle.textStyle(
                fontSize: 12, color: Colors.black.withOpacity(0.5)),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
