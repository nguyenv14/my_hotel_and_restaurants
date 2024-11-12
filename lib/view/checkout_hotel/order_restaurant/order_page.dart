import 'dart:ffi';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/customer_menu_item.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/model/menu_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/login/components/InputFieldComponet.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';

class OrderRestaurantPage extends StatefulWidget {
  final RestaurantModel restaurantModel;
  final List<MenuModel> menuList;
  final DateTime date;
  final int person;
  const OrderRestaurantPage(
      {super.key,
      required this.restaurantModel,
      required this.menuList,
      required this.date,
      required this.person});

  @override
  State<OrderRestaurantPage> createState() => _OrderRestaurantPageState();
}

class _OrderRestaurantPageState extends State<OrderRestaurantPage> {
  final TextEditingController emailText =
      TextEditingController(text: CustomerDB.getCustomer()!.customer_email);
  final TextEditingController usernameText = TextEditingController(
      text: CustomerDB.getCustomer()!.customer_name); // Controller cho tên
  final TextEditingController phoneText = TextEditingController(
      text: "0${CustomerDB.getCustomer()!.customer_phone}");
  final TextEditingController noteText =
      TextEditingController(); // Controller cho ghi chú
  late List<CustomerOrderItem> customerOrderList;
  late Map<CustomerOrderItem, bool> selectMenu;
  @override
  void initState() {
    customerOrderList =
        CustomerOrderItem.convertMenuToCustomerOrder(widget.menuList);
    selectMenu = {
      for (var item in customerOrderList) item: false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Confirm",
              style: MyTextStyle.textStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        width: MediaQuery.of(context).size.width * 0.3,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(widget.restaurantModel.restaurantName,
                                style: MyTextStyle.textStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.locationDot,
                                  color: ColorData.myColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: context.mediaQueryWidth * 0.4,
                                  child: Text(
                                    widget
                                        .restaurantModel.restaurantPlaceDetails,
                                    style: MyTextStyle.textStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ColorData.greyTextColor),
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
                            Icons.person,
                            color: ColorData.greyTextColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text('${widget.person} person',
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
                          Text(AppFunctions.getStringDate(widget.date),
                              style: MyTextStyle.textStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorData.myColor)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const LineComponent(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Infomation',
                    style: MyTextStyle.textStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFieldComponent(
                    color: Colors.black,
                    hintText: "Enter your email",
                    iconData: Icons.mail,
                    titleText: "Email",
                    textEditingController: emailText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFieldComponent(
                    color: Colors.black,
                    hintText: "Enter your name",
                    iconData: Icons.mail,
                    titleText: "Username",
                    textEditingController: usernameText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFieldComponent(
                    color: Colors.black,
                    hintText: "Enter your phone",
                    iconData: Icons.mail,
                    titleText: "Your phone",
                    textEditingController: phoneText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFieldComponent(
                    maxLines: 3,
                    color: Colors.black,
                    hintText: "Enter your note",
                    iconData: Icons.mail,
                    titleText: "Note",
                    textEditingController: noteText,
                  )
                ],
              ),
            ),
            const LineComponent(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Can you order the menu?",
                    style: MyTextStyle.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorData.myColor),
                  ),
                  Column(
                    children: customerOrderList.map((item) {
                      return _buildRoomCard(item);
                    }).toList(),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _onContinue();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: ColorData.myColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Continue',
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
  }

  Widget _buildRoomCard(CustomerOrderItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectMenu[item] = !selectMenu[item]!;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectMenu[item]! ? Colors.pink : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.menuItem.menuItemImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyTextStyle.truncateString(
                              item.menuItem.menuItemName, 10),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.money,
                                color: Colors.pink, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              "${AppFunctions.formatNumber(item.menuItem.menuItemPrice)}đ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (item.quantity > 1) item.quantity--;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: ColorData.myColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "-",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: ColorData.myColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "+",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            Checkbox(
              value: selectMenu[item],
              onChanged: (bool? newValue) {
                setState(() {
                  selectMenu[item] = newValue!;
                });
              },
              activeColor: Colors.black,
              checkColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (emailText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return false;
    }
    if (usernameText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(emailText.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }

    if (phoneText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return false;
    }
    // Kiểm tra định dạng số điện thoại (ví dụ: có 10 chữ số)
    if (!RegExp(r"^\d{10}$").hasMatch(phoneText.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid phone number (10 digits)')),
      );
      return false;
    }

    return true;
  }

  void _onContinue() {
    if (_validateInputs()) {
      List<CustomerOrderItem> selectedOrders =
          customerOrderList.where((item) => selectMenu[item] == true).toList();
      if (selectedOrders.isEmpty) {
        CherryToast.error(title: const Text("Vui lòng đặt trên 1 món!"))
            .show(context);
      } else {
        CustomerModel customerModel = CustomerModel(
            customer_email: emailText.text,
            customer_name: usernameText.text,
            customer_phone: int.parse(phoneText.text),
            customer_note: noteText.text);
        Map<String, dynamic> list = {
          "restaurant": widget.restaurantModel,
          "menus": selectedOrders,
          "date": widget.date,
          "person": widget.person,
          'customer': customerModel
        };
        Navigator.pushNamed(context, RoutesName.paymentRestaurant,
            arguments: list);
      }
    }
  }
}
