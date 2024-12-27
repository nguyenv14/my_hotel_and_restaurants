import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/view/my_order_restaurant/canceled_restaurant_page.dart';
import 'package:my_hotel_and_restaurants/view/my_order_restaurant/confirm_restaurant_page.dart';
import 'package:my_hotel_and_restaurants/view/my_order_restaurant/finished_restaurant_page.dart';

class MyOrderRestaurantPage extends StatefulWidget {
  const MyOrderRestaurantPage({super.key});

  @override
  State<MyOrderRestaurantPage> createState() => _MyOrderRestaurantPageState();
}

class _MyOrderRestaurantPageState extends State<MyOrderRestaurantPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: ColorData.backgroundColor,
        backgroundColor: ColorData.backgroundColor,
        title: Container(
          color: ColorData.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Restaurant",
                style: MyTextStyle.textStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorData.myColor),
              ),
            ],
          ),
        ),
      ),
      body: Column(children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: Colors.white),
          child: TabBar(
            dividerColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            unselectedLabelColor: ColorData.myColor,
            labelColor: Colors.white,
            labelStyle: MyTextStyle.textStyle(
                fontSize: 14, fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
                color: ColorData.myColor,
                borderRadius: BorderRadius.circular(25)),
            tabs: const [
              Tab(
                text: "Xác nhận",
              ),
              Tab(
                text: "Hoàn thành",
              ),
              Tab(
                text: "Đã hủy",
              ),
            ],
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: const [
            ConfirmRestaurantPage(),
            FinishedRestaurantPage(),
            CanceledRestaurantPage(),
          ],
        ))
      ]),
    );
  }
}
