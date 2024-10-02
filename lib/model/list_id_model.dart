class FavouriteModel {
  int customer_id;
  int hotel_id;

  FavouriteModel({required this.customer_id, required this.hotel_id});

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      customer_id: json['customer_id'],
      hotel_id: json['hotel_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customer_id,
      'hotel_id': hotel_id,
    };
  }

  static List<dynamic> getListUserFeeJson(List<FavouriteModel> userFees) {
    List<dynamic> dynamicList = userFees.map((e) => e.toJson()).toList();
    return dynamicList;
  }

  static List<FavouriteModel> getListUser(List<dynamic> dynamicList) {
    List<FavouriteModel> userList =
        dynamicList.map((e) => FavouriteModel.fromJson(e)).toList();
    return userList;
  }
}
