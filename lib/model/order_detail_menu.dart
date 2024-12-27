class OrderDetailRestaurantModel {
  int? orderDetailsId; // Nullable
  String? restaurantMenuName;
  num? restaurantMenuPrice; // Nullable
  int? restaurantMenuQuantity; // Nullable
// "order_details_id": 115,
//                     "restaurant_menu_name": "Screenshot_16-10-2024_0336_danang25.jpeg",
//                     "restaurant_menu_price": 60000,
//                     "restaurant_menu_quantity": 1
  OrderDetailRestaurantModel({
    this.orderDetailsId,
    this.restaurantMenuName,
    this.restaurantMenuPrice,
    this.restaurantMenuQuantity,
  });

  factory OrderDetailRestaurantModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailRestaurantModel(
      orderDetailsId: json['order_details_id'],
      restaurantMenuName: json['restaurant_menu_name'],
      restaurantMenuPrice: json['restaurant_menu_price'],
      restaurantMenuQuantity: json['restaurant_menu_quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_details_id': orderDetailsId,
      'restaurant_menu_name': restaurantMenuName,
      'restaurant_menu_price': restaurantMenuPrice,
      'restaurant_menu_quantity': restaurantMenuQuantity,
    };
  }

  static List<OrderDetailRestaurantModel> getListOrderDetails(
      List<dynamic> source) {
    return source.map((e) => OrderDetailRestaurantModel.fromJson(e)).toList();
  }
}
