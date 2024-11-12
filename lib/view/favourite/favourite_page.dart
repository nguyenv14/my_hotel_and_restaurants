import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/view/components/button_select_component.dart';
import 'package:my_hotel_and_restaurants/view/components/search_card_component.dart';
import 'package:my_hotel_and_restaurants/view/favourite/favourite_hotel_page.dart';
import 'package:my_hotel_and_restaurants/view/favourite/favourite_restaurant_page.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  int indexType = 1;
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
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
                "Favourite",
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
                text: "Hotel",
              ),
              Tab(
                text: "Restaurant",
              )
            ],
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: const [
            FavouriteHotelPage(),
            FavouriteRestaurantPage(),
          ],
        ))
      ]),
    );
  }
}
