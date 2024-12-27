import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';

class OrderRestaurantDetail extends StatefulWidget {
  final OrderModel orderModel;
  const OrderRestaurantDetail({super.key, required this.orderModel});

  @override
  State<OrderRestaurantDetail> createState() => _OrderRestaurantDetailState();
}

class _OrderRestaurantDetailState extends State<OrderRestaurantDetail> {
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
                      imageUrl: widget.orderModel.restaurantImage!,
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
                          widget.orderModel.restaurantName!,
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ColorData.myColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.orderModel.restaurantPlaceDetails!,
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
                          "Date",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          AppFunctions.getDayOfDateTime(
                              widget.orderModel.startDay),
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
                          Icon(
                              AppFunctions.isSunny(widget.orderModel.startDay)
                                  ? FontAwesomeIcons.solidSun
                                  : FontAwesomeIcons.solidMoon,
                              color: ColorData.myColor),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Time",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          AppFunctions.getTimeOfDateTime(
                              widget.orderModel.startDay),
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
                Text(
                  "Your note",
                  style: MyTextStyle.textStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorData.myColor),
                ),
                SizedBox(
                  width: context.mediaQueryWidth * 0.8,
                  child: Text(
                    widget.orderModel.ordererModel!.ordererOwnRequire!,
                    softWrap: true,
                    maxLines: 3,
                    style: MyTextStyle.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorData.greyTextColor),
                  ),
                ),
                const SizedBox(
                  height: 5,
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
                Column(
                  children: widget.orderModel.orderDetailRestaurants!.map(
                    (item) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.restaurantMenuName!,
                                  style: MyTextStyle.textStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${item.restaurantMenuQuantity} món',
                                  style: MyTextStyle.textStyle(
                                      fontSize: 13,
                                      color: ColorData.greyTextColor),
                                )
                              ],
                            ),
                            Text(
                              "${AppFunctions.formatNumber(item.restaurantMenuPrice!)}đ",
                              style: MyTextStyle.textStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
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
                    (widget.orderModel.total_price!).toDouble(),
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
