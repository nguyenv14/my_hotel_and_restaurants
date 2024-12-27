import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class OrderRepository {
  Future<ObjectDTO> getListOrderByStatus(int customerId, int orderStatus);

  Future<ObjectDTO> getListOrderRestaurantByStatus(
      int customerId, int orderStatus);

  Future<ObjectDTO> cancelOrderByCustomer(Map<Object?, Object> data);

  Future<ObjectDTO> cancelOrderRestaurantByCustomer(Map<Object?, Object> data);

  Future<ObjectDTO> sendCommentToOrder(Map<Object?, Object> data);

  Future<ObjectDTO> checkout(Map<Object?, Object> data);

  Future<ObjectDTO> checkoutRestaurant(Map<String?, dynamic> data);
}
