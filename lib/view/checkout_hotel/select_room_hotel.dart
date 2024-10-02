import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
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
        backgroundColor: ColorData.myColor,
        elevation: 10,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Choose the room",
          style: MyTextStyle.textStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
