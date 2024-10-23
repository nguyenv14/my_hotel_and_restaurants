import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';

class OrderDetailsModel {
  int orderDetailsId;
  String orderCode;
  int hotelId;
  HotelModel hotelModel;
  String hotelName;
  int roomId;
  RoomModel roomModel;
  String roomName;
  int typeRoomId;
  RoomTypeModel roomTypeModel;
  num priceRoom;
  num hotelFee;
  String roomImage;
  String createdAt;

  OrderDetailsModel({
    required this.orderDetailsId,
    required this.orderCode,
    required this.hotelId,
    required this.hotelModel,
    required this.hotelName,
    required this.roomId,
    required this.roomModel,
    required this.roomName,
    required this.typeRoomId,
    required this.roomTypeModel,
    required this.priceRoom,
    required this.hotelFee,
    required this.roomImage,
    required this.createdAt,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> hotelJson = json['hotel'] ?? {};
    final HotelModel hotelModels = HotelModel.fromJson(hotelJson);
    final Map<String, dynamic> roomJson = json['room'] ?? {};
    final RoomModel roomModels = RoomModel.fromJson(roomJson);
    final Map<String, dynamic> rTypeJson = json['roomType'] ?? {};
    final RoomTypeModel roomTypeModels = RoomTypeModel.fromJson(rTypeJson);
    return OrderDetailsModel(
      orderDetailsId: json['order_details_id'],
      orderCode: json['order_code'],
      hotelId: json['hotel_id'],
      hotelModel: hotelModels,
      hotelName: json['hotel_name'],
      roomId: json['room_id'],
      roomModel: roomModels,
      roomName: json['room_name'],
      typeRoomId: json['type_room_id'],
      roomTypeModel: roomTypeModels,
      priceRoom: json['price_room'],
      hotelFee: json['hotel_fee'],
      roomImage: json['room_image'],
      createdAt: json['created_at'],
    );
  }
}
