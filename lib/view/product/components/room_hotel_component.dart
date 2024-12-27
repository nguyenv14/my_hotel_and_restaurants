import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';

class RoomHotelComponent extends StatefulWidget {
  final RoomModel roomModel;
  final HotelModel hotelModel;
  const RoomHotelComponent(
      {super.key, required this.roomModel, required this.hotelModel});

  @override
  State<RoomHotelComponent> createState() => _RoomHotelComponentState();
}

class _RoomHotelComponentState extends State<RoomHotelComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mediaQueryWidth,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              width: 0.5, color: const Color.fromARGB(255, 244, 183, 0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl:
                    "${AppUrl.roomGallery}${AppFunctions.deleteSpaceWhite(widget.roomModel.roomName)}/${widget.roomModel.galleryRoom.first.galleryRoomImage}",
                imageBuilder: (context, imageProvider) => Container(
                  width: context.mediaQueryWidth * 0.3,
                  height: context.mediaQueryHeight * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                width: context.mediaQueryWidth * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.roomModel.roomName,
                      style: MyTextStyle.textStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorData.myColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.userGroup,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${widget.roomModel.roomAmountOfPeople} người",
                              style: MyTextStyle.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.layerGroup,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${widget.roomModel.roomAcreage} m2",
                              style: MyTextStyle.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.roomModel.roomView,
                      style: MyTextStyle.textStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
          const LineComponent(),
          ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                RoomTypeModel roomTypeModel = widget.roomModel.roomTypes[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Loại phòng ${index + 1}",
                          style: MyTextStyle.textStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorData.myColor),
                        ),
                        widget.roomModel.roomTypes[index].typeRoomCondition == 1
                            ? RichText(
                                text: TextSpan(
                                  text:
                                      "${AppFunctions.formatNumber(widget.roomModel.roomTypes[index].typeRoomPrice)}đ",
                                  children: [
                                    TextSpan(
                                      text:
                                          "${AppFunctions.calculatePrice(widget.roomModel.roomTypes[index])}đ",
                                      style: MyTextStyle.textStyle(
                                              fontSize: 15,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold)
                                          .copyWith(
                                              decoration: TextDecoration.none),
                                    )
                                  ],
                                  style: MyTextStyle.textStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ).copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              )
                            : Text(
                                "${AppFunctions.calculatePrice(widget.roomModel.roomTypes[index])}đ",
                                style: MyTextStyle.textStyle(
                                    fontSize: 15,
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.bed,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              roomTypeModel.typeRoomBed == 1
                                  ? "Giường đơn"
                                  : (roomTypeModel.typeRoomBed == 2
                                      ? "Giường đôi"
                                      : "Giường đơn hoặc đôi"),
                              style: MyTextStyle.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Map<String, dynamic> list = {
                              "hotel": widget.hotelModel,
                              "room": widget.roomModel,
                              "roomType": roomTypeModel
                            };
                            Navigator.pushNamed(
                                context, RoutesName.checkOutPage,
                                arguments: list);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    width: 1, color: ColorData.myColor)),
                            child: Text(
                              "Đặt phòng",
                              style: MyTextStyle.textStyle(
                                  fontSize: 14,
                                  color: ColorData.myColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
                );
              },
              separatorBuilder: (context, index) {
                return const LineComponent();
              },
              itemCount: widget.roomModel.roomTypes.length)
        ],
      ),
    );
  }
}
