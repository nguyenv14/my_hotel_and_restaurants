import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Restaurant/restaurant_repository.dart';

class RestaurantRepositoryImp implements RestaurantRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  @override
  Future<ObjectDTO> fetchRestaurantByArea(int index) async {
    try {
      ObjectDTO objectDTO = await _apiServices
          .getGetApiResponse("${AppUrl.restaurantListByArea}?area_id=7");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> fetchRestaurantById(int index) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(
          "${AppUrl.restaurantById}?restaurant_id=" + index.toString());
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
