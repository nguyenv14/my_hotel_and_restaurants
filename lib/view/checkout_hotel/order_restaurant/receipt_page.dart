import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/view/main_screen.dart';

class ReceiptRestaurantPage extends StatefulWidget {
  const ReceiptRestaurantPage({super.key});

  @override
  State<ReceiptRestaurantPage> createState() => _ReceiptRestaurantPageState();
}

class _ReceiptRestaurantPageState extends State<ReceiptRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorData.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/image.png",
              width: context.mediaQueryWidth,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Congratulations!',
              style: MyTextStyle.textStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorData.myColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: context.mediaQueryWidth * 0.5,
                child: Text(
                  'Your restaurant stay is secured. Counting down to your dream food!',
                  textAlign: TextAlign.center,
                  style: MyTextStyle.textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorData.greyTextColor),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                    (route) => false);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
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
                    'Go Home',
                    style: MyTextStyle.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
