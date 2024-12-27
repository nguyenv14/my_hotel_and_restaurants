import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Hotel/hotel_repository.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class HotelRepositoryImp implements HotelRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> fetchHotelByType(int index) async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(
          "${AppUrl.hoteListByType}?hotel_type=${index + 1}");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> fetchHotelByArea(int index) async {
    try {
      ObjectDTO objectDTO = await _apiServices
          .getGetApiResponse("${AppUrl.hotelListByArea}?area_id=$index");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> fetchHotelById(int index) async {
    try {
      ObjectDTO objectDTO = await _apiServices
          .getGetApiResponse("${AppUrl.hotelById}?hotel_id=$index");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> fetchHotelFavouriteId(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.hotelFavourite, data);
      return objectDTO;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> searchHotel(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.searchHotel, data);
      return objectDTO;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> fetchHotelRecomendation() async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(
          "${AppUrl.hotelRecommendation}?customer_id=${CustomerDB.getCustomer()!.customer_id}");
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
