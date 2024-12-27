import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailPage({super.key, required this.orderModel});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.backgroundColor.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: ColorData.backgroundColor,
        shadowColor: ColorData.backgroundColor,
        surfaceTintColor: ColorData.backgroundColor,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ButtonLeadingComponent(
              iconData: Icons.arrow_back_ios_new_rounded,
            ),
            Text(
              "Order Detail",
              style: MyTextStyle.textStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget
                          .orderModel.orderDetailsModel!.hotelModel.hotelImage,
                      imageBuilder: (context, imageProvider) => Container(
                        width: context.mediaQueryWidth * 0.2,
                        height: context.mediaQueryHeight * 0.08,
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.orderModel.orderDetailsModel!.hotelName,
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ColorData.myColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.orderModel.orderDetailsModel!.hotelModel
                                .hotelPlaceDetails,
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            style: MyTextStyle.textStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.2))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Check in",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.orderModel.startDay,
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 0.5)),
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.solidMoon,
                            color: ColorData.myColor,
                          ),
                          Text(
                            AppFunctions.differenceTwoDay(
                                    widget.orderModel.startDay,
                                    widget.orderModel.endDay!)
                                .toString(),
                            style: MyTextStyle.textStyle(
                                fontSize: 16,
                                color: ColorData.myColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Check out",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.orderModel.endDay!,
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.2))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MyTextStyle.truncateString(
                          widget
                              .orderModel.orderDetailsModel!.roomModel.roomName,
                          30),
                      style: MyTextStyle.textStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    CachedNetworkImage(
                      imageUrl:
                          "${AppUrl.roomGallery}${AppFunctions.deleteSpaceWhite(widget.orderModel.orderDetailsModel!.roomModel.roomName)}/${widget.orderModel.orderDetailsModel!.roomImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        width: context.mediaQueryWidth * 0.14,
                        height: context.mediaQueryHeight * 0.06,
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemOptionOrderHotel(
                            FontAwesomeIcons.utensils, "Breakfast included"),
                        const SizedBox(
                          height: 5,
                        ),
                        itemOptionOrderHotel(
                            FontAwesomeIcons.solidUser, "2 guest"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemOptionOrderHotel(FontAwesomeIcons.bed, "Twin bed"),
                        const SizedBox(
                          height: 5,
                        ),
                        itemOptionOrderHotel(
                            FontAwesomeIcons.layerGroup, "24m2"),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.2))),
                ),
                Text(
                  "SPECIAL REQUESTS",
                  style: MyTextStyle.textStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Text(
                  "High floor",
                  style: MyTextStyle.textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      border: DashedBorder.symmetric(
                    horizontal:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                    dashLength: 10,
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: const Icon(FontAwesomeIcons.solidUser)),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel.ordererModel!.ordererName!,
                          style: MyTextStyle.textStyle(
                              fontSize: 14, color: Colors.blueAccent),
                        ),
                        Text(
                          widget.orderModel.ordererModel!.ordererEmail!,
                          style: MyTextStyle.textStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text(
                  "Order code: ${widget.orderModel.orderCode!}",
                  style:
                      MyTextStyle.textStyle(fontSize: 13, color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.2))),
                ),
                itemPriceOrder(
                    "1 phòng x ${AppFunctions.differenceTwoDay(widget.orderModel.startDay, widget.orderModel.endDay!)} ngày",
                    (widget.orderModel.orderDetailsModel!.priceRoom -
                            widget.orderModel.orderDetailsModel!.hotelFee +
                            widget.orderModel.couponSalePrice!)
                        .toDouble()),
                const SizedBox(
                  height: 10,
                ),
                itemPriceOrder("Phí khách sạn",
                    widget.orderModel.orderDetailsModel!.hotelFee.toDouble()),
                const LineComponent(),
                itemPriceOrder(
                    "Tổng giá phòng",
                    (widget.orderModel.orderDetailsModel!.priceRoom +
                            widget.orderModel.couponSalePrice!)
                        .toDouble()),
                const SizedBox(
                  height: 5,
                ),
                widget.orderModel.couponSalePrice!.toDouble() > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Mã giảm giá",
                                style: MyTextStyle.textStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red)),
                                  child: Text(
                                    "HELLOVKU",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 12, color: Colors.red),
                                  )),
                            ],
                          ),
                          Text(
                            "-${AppFunctions.formatNumber(widget.orderModel.couponSalePrice!.toDouble())}",
                            style: MyTextStyle.textStyle(
                                fontSize: 12, color: Colors.green),
                          ),
                        ],
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.2))),
                ),
                itemPriceOrder("Tổng tiền thanh toán",
                    (widget.orderModel.orderDetailsModel!.priceRoom).toDouble(),
                    fontWeight: FontWeight.bold, color: ColorData.myColor),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget itemOptionOrderHotel(
    IconData iconData,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 12,
          color: Colors.amber,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: MyTextStyle.textStyle(fontSize: 12, color: Colors.grey),
        )
      ],
    );
  }

  Widget itemPriceOrder(String text, double price,
      {FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: MyTextStyle.textStyle(fontSize: 12, fontWeight: fontWeight),
        ),
        Text(
          "${AppFunctions.formatNumber(price)}đ",
          style: MyTextStyle.textStyle(
              fontSize: 12, fontWeight: fontWeight, color: color),
        )
      ],
    );
  }
}
