import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Area/area_repository.dart';

class AreaRepositoryImp implements AreaRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> fetchAreaList() async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getGetApiResponse(AppUrl.areaList);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
