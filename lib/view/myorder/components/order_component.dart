import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/myorder/components/comment_component.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';

class OrderComponent extends StatefulWidget {
  final OrderModel orderModel;
  final OrderViewModel orderViewModel;
  const OrderComponent(
      {super.key, required this.orderModel, required this.orderViewModel});

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(1, 1),
        //     blurRadius: 2,
        //     spreadRadius: 2,
        //     color: Colors.grey.withOpacity(0.5),
        //   ),
        // ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl:
                    widget.orderModel.orderDetailsModel!.hotelModel.hotelImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: context.mediaQueryWidth * 0.3,
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyTextStyle.truncateString(
                        widget.orderModel.orderDetailsModel!.hotelName, 20),
                    style: MyTextStyle.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${widget.orderModel.startDay}/${widget.orderModel.endDay!}",
                        style: MyTextStyle.textStyle(
                            fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.doorOpen,
                        size: 14,
                        color: ColorData.myColor,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        MyTextStyle.truncateString(
                            widget.orderModel.orderDetailsModel!.roomName, 27),
                        style: MyTextStyle.textStyle(
                            fontSize: 12, color: ColorData.myColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppFunctions.selectColorInOrderByStatus(
                            widget.orderModel.orderStatus)
                        .withOpacity(0.2)),
                child: Text(
                  widget.orderModel.orderStatus == 0
                      ? "Waiting confirm"
                      : (widget.orderModel.orderStatus == 1 ||
                              widget.orderModel.orderStatus == 2
                          ? "completed"
                          : "canceled"),
                  style: MyTextStyle.textStyle(
                      fontSize: 12,
                      color: AppFunctions.selectColorInOrderByStatus(
                          widget.orderModel.orderStatus)),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                    color: ColorData.myColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "${AppFunctions.calculatePriceOrder(widget.orderModel.orderDetailsModel!)}đ",
                  style: MyTextStyle.textStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          widget.orderModel.couponSalePrice! > 0
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: const BoxDecoration(
                      border: DashedBorder.fromBorderSide(
                          dashLength: 10,
                          side: BorderSide(color: Colors.amber, width: 2))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.ticket,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Mã giảm: ${widget.orderModel.couponNameCode!}",
                            style: MyTextStyle.textStyle(
                                color: Colors.amberAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        "-${AppFunctions.formatNumber(widget.orderModel.couponSalePrice!.toDouble())}đ",
                        style: MyTextStyle.textStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          widget.orderModel.orderStatus == 0
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Thông báo'),
                          content: const Text(
                              'Bạn chắc chắn muốn hủy đơn đặt phòng?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.orderViewModel.cancelOrderByCustomerId(
                                    CustomerDB.getCustomer()!.customer_id!,
                                    widget.orderModel.orderId);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: context.mediaQueryWidth * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Hủy đặt phòng",
                        style: MyTextStyle.textStyle(
                            fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : (widget.orderModel.orderStatus == 1
                  ? SizedBox(
                      width: context.mediaQueryWidth * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CommentComponent(
                                orderViewModel: widget.orderViewModel,
                                orderModel: widget.orderModel,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Đánh giá",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : Container()),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: context.mediaQueryWidth * 0.8,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.orderDetail,
                    arguments: widget.orderModel);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              child: const Text(
                "Xem chi tiết",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
