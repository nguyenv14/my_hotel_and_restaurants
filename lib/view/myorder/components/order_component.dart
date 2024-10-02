import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/login/components/InputFieldComponet.dart';
import 'package:my_hotel_and_restaurants/view/myorder/components/comment_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(232, 234, 241, 1), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ORDER ID: " + widget.orderModel.orderCode,
                style: MyTextStyle.textStyle(fontSize: 13, color: Colors.grey),
              ),
              Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: Colors.grey,
                size: 13,
              )
            ],
          ),
          LineComponent(),
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: AppUrl.hotelImage +
                    widget.orderModel.orderDetailsModel.hotelModel.hotelImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: context.mediaQueryWidth * 0.2,
                  height: context.mediaQueryHeight * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderModel.orderDetailsModel.hotelName,
                    style: MyTextStyle.textStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorData.myColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: Color.fromRGBO(255, 147, 70, 1),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.orderModel.startDay +
                            "/" +
                            widget.orderModel.endDay,
                        style: MyTextStyle.textStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.doorOpen,
                        size: 14,
                        color: Color.fromRGBO(255, 147, 70, 1),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.orderModel.orderDetailsModel.roomName,
                        style: MyTextStyle.textStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppFunctions.selectColorInOrderByStatus(
                            widget.orderModel.orderStatus)
                        .withOpacity(0.2)),
                child: Text(
                  widget.orderModel.orderStatus == 0
                      ? "Waiting confirm"
                      : (widget.orderModel.orderStatus == 1 ||
                              widget.orderModel.orderStatus == 2
                          ? "completed"
                          : "cancel"),
                  style: MyTextStyle.textStyle(
                      fontSize: 12,
                      color: AppFunctions.selectColorInOrderByStatus(
                          widget.orderModel.orderStatus)),
                ),
              ),
              Text(
                AppFunctions.calculatePriceOrder(
                        widget.orderModel.orderDetailsModel) +
                    "đ",
                style: MyTextStyle.textStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          widget.orderModel.couponSalePrice > 0
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      border: DashedBorder.fromBorderSide(
                          dashLength: 10,
                          side: BorderSide(color: Colors.amber, width: 2))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.ticket,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Mã giảm: " + widget.orderModel.couponNameCode,
                            style: MyTextStyle.textStyle(
                                color: Colors.amberAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        "-" +
                            AppFunctions.formatNumber(
                                widget.orderModel.couponSalePrice.toDouble()) +
                            "đ",
                        style: MyTextStyle.textStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            height: 5,
          ),
          widget.orderModel.orderStatus == 0
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content:
                              Text('Bạn chắc chắn muốn hủy đơn đặt phòng?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng hộp thoại
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.orderViewModel.cancelOrderByCustomerId(
                                    CustomerDB.getCustomer()!.customer_id!,
                                    widget.orderModel.orderId);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: context.mediaQueryWidth * 0.85,
                    padding: EdgeInsets.symmetric(vertical: 6),
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
                  ? GestureDetector(
                      onTap: () {
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
                      child: Container(
                        width: context.mediaQueryWidth * 0.85,
                        padding: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Đánh giá",
                            style: MyTextStyle.textStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container()),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.orderDetail,
                  arguments: widget.orderModel);
            },
            child: Container(
              width: context.mediaQueryWidth * 0.85,
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  // color: Colors.blueAccent,
                  border: Border.all(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Xem chi tiết",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, color: Colors.blueAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
