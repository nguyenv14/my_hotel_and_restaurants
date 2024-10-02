class RoomTypeModel {
  final int typeRoomId;
  final int roomId;
  final int typeRoomBed;
  final double typeRoomPrice;
  final int typeRoomCondition;
  final double typeRoomPriceSale;
  final int typeRoomQuantity;
  final int typeRoomStatus;

  RoomTypeModel({
    required this.typeRoomId,
    required this.roomId,
    required this.typeRoomBed,
    required this.typeRoomPrice,
    required this.typeRoomCondition,
    required this.typeRoomPriceSale,
    required this.typeRoomQuantity,
    required this.typeRoomStatus,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      typeRoomId: json['type_room_id'],
      roomId: json['room_id'],
      typeRoomBed: json['type_room_bed'],
      typeRoomPrice: json['type_room_price'].toDouble(),
      typeRoomCondition: json['type_room_condition'],
      typeRoomPriceSale: json['type_room_price_sale'] != null
          ? json['type_room_price_sale'].toDouble()
          : 0.0,
      typeRoomQuantity: json['type_room_quantity'],
      typeRoomStatus: json['type_room_status'],
    );
  }

  static List<RoomTypeModel> getListHotel(List<dynamic> source) {
    List<RoomTypeModel> hotelList =
        source.map((e) => RoomTypeModel.fromJson(e)).toList();
    return hotelList;
  }
}
