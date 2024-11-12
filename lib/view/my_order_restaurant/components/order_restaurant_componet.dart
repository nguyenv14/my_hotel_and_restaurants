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

class OrderRestaurantComponent extends StatefulWidget {
  final OrderModel orderModel;
  final OrderViewModel orderViewModel;

  const OrderRestaurantComponent(
      {super.key, required this.orderModel, required this.orderViewModel});

  @override
  State<OrderRestaurantComponent> createState() =>
      _OrderRestaurantComponentState();
}

class _OrderRestaurantComponentState extends State<OrderRestaurantComponent> {
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
                imageUrl: widget.orderModel.restaurantImage!,
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
                        widget.orderModel.restaurantName!, 27),
                    style: MyTextStyle.textStyle(
                        fontSize: 16,
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
                        widget.orderModel.startDay,
                        style: MyTextStyle.textStyle(
                            fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.usersViewfinder,
                    size: 20,
                    color: ColorData.myColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${widget.orderModel.ordererModel!.ordererTypeBed} person",
                    style: MyTextStyle.textStyle(
                        fontSize: 15, color: ColorData.greyTextColor),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.bowlFood,
                    size: 25,
                    color: ColorData.myColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.orderModel.orderDetailRestaurants!.length} foods",
                    style: MyTextStyle.textStyle(
                        fontSize: 15, color: ColorData.greyTextColor),
                  )
                ],
              )
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
                  "${AppFunctions.formatNumber(widget.orderModel.total_price!)}đ",
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
              ? SizedBox(
                  width: context.mediaQueryWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Thông báo'),
                            content: const Text(
                                'Bạn chắc chắn muốn hủy đơn đặt bàn?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.orderViewModel
                                      .cancelOrderRestaurantByCustomerId(
                                          CustomerDB.getCustomer()!
                                              .customer_id!,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Hủy đặt bàn",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
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
                Navigator.pushNamed(context, RoutesName.orderRestaurantDetail,
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
