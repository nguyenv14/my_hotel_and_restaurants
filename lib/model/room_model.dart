import 'package:my_hotel_and_restaurants/model/gallery_room_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';

class RoomModel {
  final int roomId;
  final int hotelId;
  final List<GalleryRoomModel> galleryRoom;
  final List<RoomTypeModel> roomTypes;
  final String roomName;
  final int roomAmountOfPeople;
  final int roomAcreage;
  final String roomView;
  final int roomStatus;

  RoomModel({
    required this.roomId,
    required this.hotelId,
    required this.galleryRoom,
    required this.roomTypes,
    required this.roomName,
    required this.roomAmountOfPeople,
    required this.roomAcreage,
    required this.roomView,
    required this.roomStatus,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> areaJsonList = json['roomTypes'] ?? [];
    List<RoomTypeModel> roomTypeList = areaJsonList
        .map((areaJson) => RoomTypeModel.fromJson(areaJson))
        .toList();
    List<dynamic> galleryRoom = json['gallery_room'] ?? [];
    List<GalleryRoomModel> gallery =
        galleryRoom.map((e) => GalleryRoomModel.fromJson(e)).toList();
    print("room");
    return RoomModel(
      roomId: json['room_id'],
      hotelId: json['hotel_id'],
      galleryRoom: gallery,
      roomTypes: roomTypeList,
      roomName: json['room_name'],
      roomAmountOfPeople: json['room_amount_of_people'],
      roomAcreage: json['room_acreage'],
      roomView: json['room_view'],
      roomStatus: json['room_status'],
    );
  }

  static List<RoomModel> getListHotel(List<dynamic> source) {
    List<RoomModel> hotelList =
        source.map((e) => RoomModel.fromJson(e)).toList();
    return hotelList;
  }
}
