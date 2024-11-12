class FavouriteRestaurantModel {
  int customer_id;
  int restaurant_id;

  FavouriteRestaurantModel(
      {required this.customer_id, required this.restaurant_id});

  factory FavouriteRestaurantModel.fromJson(Map<String, dynamic> json) {
    return FavouriteRestaurantModel(
      customer_id: json['customer_id'],
      restaurant_id: json['restaurant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customer_id,
      'restaurant_id': restaurant_id,
    };
  }

  static List<dynamic> getListUserFeeJson(
      List<FavouriteRestaurantModel> userFees) {
    List<dynamic> dynamicList = userFees.map((e) => e.toJson()).toList();
    return dynamicList;
  }

  static List<FavouriteRestaurantModel> getListFavourite(
      List<dynamic> dynamicList) {
    List<FavouriteRestaurantModel> userList =
        dynamicList.map((e) => FavouriteRestaurantModel.fromJson(e)).toList();
    return userList;
  }
}
