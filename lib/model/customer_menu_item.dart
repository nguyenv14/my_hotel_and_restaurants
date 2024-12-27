import 'package:my_hotel_and_restaurants/model/menu_restaurant_model.dart';

class CustomerOrderItem {
  final MenuModel menuItem;
  int quantity;

  CustomerOrderItem({
    required this.menuItem,
    this.quantity = 1, // Default to 1 if not specified
  });

  factory CustomerOrderItem.fromMenuModel(MenuModel menuItem,
      {int quantity = 1}) {
    return CustomerOrderItem(
      menuItem: menuItem,
      quantity: quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItem.menuItemId,
      'quantity': quantity,
    };
  }

  static List<CustomerOrderItem> convertMenuToCustomerOrder(
      List<MenuModel> menuList,
      {int defaultQuantity = 1}) {
    return menuList
        .map((menuItem) => CustomerOrderItem.fromMenuModel(menuItem,
            quantity: defaultQuantity))
        .toList();
  }
}
