import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/main_screen.dart';

class ReceiptPage extends StatefulWidget {
  final OrderModel orderModel;
  final int days;
  const ReceiptPage({super.key, required this.orderModel, required this.days});
  // final Order order;
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // context.read<OrderViewModel>().dispose();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false);
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40)),
                child: Image.asset("assets/images/check.png", width: 40),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Payment Success",
              style: MyTextStyle.textStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 0.5)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.orderModel.orderDetailsModel!
                              .hotelModel.hotelImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: context.mediaQueryWidth * 0.28,
                            height: context.mediaQueryHeight * 0.12,
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
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: context.mediaQueryHeight * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.orderModel.orderDetailsModel!.hotelName,
                                style: MyTextStyle.textStyle(
                                    fontSize: 16,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.orderModel.orderDetailsModel!.roomName,
                                style: MyTextStyle.textStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemOptionOrderHotel(
                                          FontAwesomeIcons.addressBook,
                                          "${widget.orderModel.orderDetailsModel!.roomModel.roomAmountOfPeople} guest"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      itemOptionOrderHotel(
                                          FontAwesomeIcons.bed,
                                          widget
                                                      .orderModel
                                                      .orderDetailsModel!
                                                      .roomTypeModel
                                                      .typeRoomBed ==
                                                  1
                                              ? "Giường đơn"
                                              : widget
                                                          .orderModel
                                                          .orderDetailsModel!
                                                          .roomTypeModel
                                                          .typeRoomBed ==
                                                      2
                                                  ? "Giường đôi"
                                                  : "Đơn hoặc đôi")
                                    ],
                                  ),
                                  SizedBox(
                                    width: context.mediaQueryWidth * 0.05,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemOptionOrderHotel(
                                          FontAwesomeIcons.layerGroup,
                                          "${widget.orderModel.orderDetailsModel!.roomModel.roomAcreage}m2"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      itemOptionOrderHotel(
                                          FontAwesomeIcons.eye,
                                          widget.orderModel.orderDetailsModel!
                                              .roomModel.roomView)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: Colors.grey.shade400,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
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
                              border:
                                  Border.all(color: Colors.grey, width: 0.5)),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.solidMoon,
                                color: Colors.blueAccent,
                              ),
                              Text(
                                "3",
                                style: MyTextStyle.textStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order_code",
                        style: MyTextStyle.textStyle(fontSize: 14),
                      ),
                      Text(
                        widget.orderModel.orderCode!,
                        style: MyTextStyle.textStyle(
                            fontSize: 14,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  // itemPriceOrder(
                  //     "1 phòng x " +
                  //         differenceDay.inDays.toString() +
                  //         " ngày",
                  //     price),
                  const SizedBox(
                    height: 5,
                  ),
                  // itemPriceOrder("1 phòng x 10 ngày", 2000),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1 phòng x ${widget.days.toString()} ngày",
                            style: MyTextStyle.textStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "Đã bao gồm phí dịch vụ",
                            style: MyTextStyle.textStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        "${AppFunctions.formatNumber(widget.orderModel.orderDetailsModel!.priceRoom + widget.orderModel.couponSalePrice!.toDouble())}đ",
                        style: MyTextStyle.textStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  widget.orderModel.couponSalePrice! > 0
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
                                  width: 10,
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red)),
                                    child: Text(
                                      widget.orderModel.couponNameCode!,
                                      style: MyTextStyle.textStyle(
                                          fontSize: 12, color: Colors.red),
                                    )),
                              ],
                            ),
                            Text(
                              "-${AppFunctions.formatNumber(widget.orderModel.couponSalePrice!.toDouble())}đ",
                              style: MyTextStyle.textStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
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
                      widget.orderModel.orderDetailsModel!.priceRoom.toDouble(),
                      // price + feeService - priceCouponSale,
                      fontWeight: FontWeight.bold),

                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: DashedBorder.all(
                            dashLength: 5, width: 1, color: Colors.red)),
                    child: Text(
                      "Vui lòng liên hệ quầy lễ tân để thanh toán!",
                      style: MyTextStyle.textStyle(
                          fontSize: 12, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemPriceOrder(String text, double price,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: MyTextStyle.textStyle(fontSize: 12, fontWeight: fontWeight),
        ),
        Text(
          "${AppFunctions.formatNumber(price)}đ",
          style: MyTextStyle.textStyle(fontSize: 13, fontWeight: fontWeight),
        )
      ],
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
        SizedBox(
          width: context.mediaQueryWidth * 0.2,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: MyTextStyle.textStyle(fontSize: 12, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
