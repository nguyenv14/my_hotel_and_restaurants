import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/favourite/favourite_page.dart';
import 'package:my_hotel_and_restaurants/view/home/home_page.dart';
import 'package:my_hotel_and_restaurants/view/myorder/my_order_page.dart';
import 'package:my_hotel_and_restaurants/view/profile/profile_page.dart';
import 'package:my_hotel_and_restaurants/view_model/customer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  // final List<Widget> _pages = [const HomePage(), const MyOrderPage()];

  int _currentIndex = 0;
  List loadedPages = [
    0,
  ];

  @override
  Widget build(BuildContext context) {
    final customerViewModel =
        Provider.of<CustomerViewModel>(context, listen: true);
    var screens = [
      const HomePage(),
      loadedPages.contains(1) ? const MyOrderPage() : Container(),
      loadedPages.contains(2) ? const FavouritePage() : Container(),
      loadedPages.contains(3) ? const ProfilePage() : Container(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            var pages = loadedPages;
            if (!pages.contains(index)) {
              pages.add(index);
            }
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 3) {
                customerViewModel.setCustomerModel(CustomerDB.getCustomer()!);
              }
              loadedPages = pages;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.hotel),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.cartFlatbed),
              title: const Text("My trip"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.solidHeart),
              title: const Text("Favorite"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.solidUser),
              title: const Text("Profile"),
              selectedColor: Colors.pink,
            ),
          ]),
    );
  }
}
