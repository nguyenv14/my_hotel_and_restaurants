import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/customer_menu_item.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';
import 'package:provider/provider.dart';

class CheckInRestaurantPage extends StatefulWidget {
  final RestaurantModel restaurantModel;
  final DateTime date;
  final List<CustomerOrderItem> menuList;
  final CustomerModel customerModel;
  final int personQuantity;
  const CheckInRestaurantPage(
      {super.key,
      required this.restaurantModel,
      required this.date,
      required this.menuList,
      required this.customerModel,
      required this.personQuantity});

  @override
  State<CheckInRestaurantPage> createState() => _CheckInRestaurantPageState();
}

class _CheckInRestaurantPageState extends State<CheckInRestaurantPage> {
  OrderViewModel orderViewModel = OrderViewModel(orderRepository: getIt());
  int totalPrice = 0;
  var _result;
  @override
  Widget build(BuildContext context) {
    totalPrice = 0;
    return Consumer<OrderViewModel>(
      builder: (context, value, child) {
        orderViewModel = value;
        if (value.orderRestaurantResponse.status == Status.completed) {
          OrderModel order = orderViewModel.orderRestaurantResponse.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(
              context,
              RoutesName.receiptRestaurantPage,
            );
          });
          value.orderRestaurantResponse.status = Status.loading;
          value.isCheckOutRestaurant = false;
        }
        return value.isCheckOutRestaurant == true
            ? Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/raw/waiting.json"),
                      Center(
                        child: Text(
                          "Vui lòng chờ đơn đặt đang được xử lý!",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: ColorData.backgroundColor,
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
                        "Payment",
                        style: MyTextStyle.textStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              spreadRadius: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 90,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.restaurantModel.restaurantImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  height: 90,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                          widget.restaurantModel.restaurantName,
                                          style: MyTextStyle.textStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.locationDot,
                                            color: ColorData.myColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width:
                                                context.mediaQueryWidth * 0.4,
                                            child: Text(
                                              widget.restaurantModel
                                                  .restaurantPlaceDetails,
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ColorData.greyTextColor),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.person,
                                      color: ColorData.greyTextColor,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text('${widget.personQuantity} person',
                                        style: MyTextStyle.textStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorData.myColor)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                      color: ColorData.greyTextColor,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                        AppFunctions.getStringDate(widget.date),
                                        style: MyTextStyle.textStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorData.myColor)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const LineComponent(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.solidCircleUser,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.customerModel.customer_name!,
                                        style: MyTextStyle.textStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.solidEnvelope,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.customerModel.customer_email!,
                                        style: MyTextStyle.textStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.phone,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "0${widget.customerModel.customer_phone}",
                                        style: MyTextStyle.textStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.solidClipboard,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          maxLines: 3,
                                          widget.customerModel.customer_note!
                                                  .isEmpty
                                              ? "Không có"
                                              : widget
                                                  .customerModel.customer_note!,
                                          style: MyTextStyle.textStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const LineComponent(),
                            Text(
                              "Your order:",
                              style: MyTextStyle.textStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorData.myColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: widget.menuList.map(
                                (item) {
                                  int price = item.quantity *
                                      item.menuItem.menuItemPrice;
                                  totalPrice = totalPrice +
                                      item.quantity *
                                          item.menuItem.menuItemPrice;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.menuItem.menuItemName,
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${item.quantity} món',
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 13,
                                                  color:
                                                      ColorData.greyTextColor),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "${AppFunctions.formatNumber(price)}đ",
                                          style: MyTextStyle.textStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ColorData.myColor),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            const LineComponent(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Payment',
                                  style: MyTextStyle.textStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "+${AppFunctions.formatNumber(totalPrice)}đ",
                                  style: MyTextStyle.textStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorData.myColor),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment method",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RadioListTile(
                                      activeColor: Colors.green,
                                      title: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.moneyBillWave,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Thanh toán trực tiếp",
                                            style: MyTextStyle.textStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                      value: 4,
                                      groupValue: _result,
                                      onChanged: (value) {
                                        setState(() {
                                          _result = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor: Colors.green,
                                      title: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.creditCard,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Thanh toán qua Stripe",
                                            style: MyTextStyle.textStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                      value: 1,
                                      groupValue: _result,
                                      onChanged: (value) {
                                        setState(() {
                                          _result = value;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_result == 4) {
                            orderViewModel.checkOutRestaurant(
                                widget.customerModel,
                                widget.date.toString(),
                                widget.menuList,
                                widget.restaurantModel.restaurantId,
                                widget.personQuantity);
                          } else {
                            // print(245);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: ColorData.myColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Booking Now',
                                style: MyTextStyle.textStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
