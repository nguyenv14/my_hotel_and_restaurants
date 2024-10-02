import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/view/login/login_screen.dart';
import 'package:my_hotel_and_restaurants/view/myorder/cancel_page.dart';
import 'package:my_hotel_and_restaurants/view/myorder/confirm_page.dart';
import 'package:my_hotel_and_restaurants/view/myorder/finhished_page.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
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
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Trip",
                style: MyTextStyle.textStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorData.myColor),
              ),
              Container(
                decoration: BoxDecoration(
                    // border: Border.all(
                    //   width: 2,
                    //   color: Colors.blueGrey,
                    // ),
                    color: ColorData.myColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.blueGrey,
                  size: 15,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25)),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              unselectedLabelColor: ColorData.myColor,
              labelColor: Colors.white,
              labelStyle: MyTextStyle.textStyle(
                  fontSize: 14, fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                  color: ColorData.myColor,
                  borderRadius: BorderRadius.circular(25)),
              tabs: [
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
            children: [
              ConfirmOrderPage(),
              FinishedOrderPage(),
              CancelOrderPage(),
            ],
          ))
        ]),
      ),
    );
  }
}
