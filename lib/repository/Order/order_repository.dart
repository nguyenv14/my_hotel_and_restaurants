import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class OrderRepository {
  Future<ObjectDTO> getListOrderByStatus(int customer_id, int order_status);

  Future<ObjectDTO> cancelOrderByCustomer(Map<Object?, Object> data);

  Future<ObjectDTO> sendCommentToOrder(Map<Object?, Object> data);

  Future<ObjectDTO> checkout(Map<Object?, Object> data);
}
