import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Search/search_repository.dart';

class SearchRepositoryImp implements SearchRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> filterSearch(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.filter, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> search(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.search, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
