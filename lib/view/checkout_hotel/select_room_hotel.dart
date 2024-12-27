import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/room_hotel_component.dart';

class SelectRoomInHotelPage extends StatefulWidget {
  final HotelModel hotelModel;
  const SelectRoomInHotelPage({super.key, required this.hotelModel});

  @override
  State<SelectRoomInHotelPage> createState() => _SelectRoomInHotelPageState();
}

class _SelectRoomInHotelPageState extends State<SelectRoomInHotelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Choose Room",
              style: MyTextStyle.textStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ButtonLeadingComponent(
              iconData: Icons.menu,
              onPress: () {},
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: ColorData.backgroundColor,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.hotelModel.rooms.length,
            itemBuilder: (context, index) {
              return RoomHotelComponent(
                roomModel: widget.hotelModel.rooms[index],
                hotelModel: widget.hotelModel,
              );
            },
          ),
        ),
      ),
    );
  }
}
