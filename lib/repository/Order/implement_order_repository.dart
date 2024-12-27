import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Order/order_repository.dart';

class OrderRepositoryImp implements OrderRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> getListOrderByStatus(
      int customerId, int orderStatus) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(
          "${AppUrl.orderListByStatus}?customer_id=$customerId&order_status=$orderStatus");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> cancelOrderByCustomer(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.cancelOrderById, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> cancelOrderRestaurantByCustomer(
      Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getPostApiResponse(
          AppUrl.cancelOrderRestaurantById, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> sendCommentToOrder(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.sendCommentOrder, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> checkout(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.checkOut, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> checkoutRestaurant(Map<String?, dynamic> data) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getPostApiCheckoutResponse(
          AppUrl.checkoutRestaurant, data);
      return objectDTO;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> getListOrderRestaurantByStatus(
      int customerId, int orderStatus) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(
          "${AppUrl.orderRestaurantListByStatus}?customer_id=$customerId&order_status=$orderStatus");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
