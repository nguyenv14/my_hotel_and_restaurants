import 'package:my_hotel_and_restaurants/data/response/app_url.dart';

class MenuModel {
  final int menuItemId;
  final int restaurantId;
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemImage;
  final int menuItemPrice;
  final int menuItemStatus;

  MenuModel({
    required this.menuItemId,
    required this.restaurantId,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemImage,
    required this.menuItemPrice,
    required this.menuItemStatus,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuItemId: json['menu_item_id'],
      restaurantId: json['restaurant_id'],
      menuItemName: json['menu_item_name'],
      menuItemDescription: json['menu_item_description'],
      menuItemImage: AppUrl.restaurantMenuImage + json['menu_item_image'],
      menuItemPrice: json['menu_item_price'],
      menuItemStatus: json['menu_item_status'],
    );
  }

  static List<MenuModel> getListMenu(List<dynamic> source) {
    return source.map((e) => MenuModel.fromJson(e)).toList();
  }
}
