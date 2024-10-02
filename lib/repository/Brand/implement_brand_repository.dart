import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Brand/brand_repository.dart';

class BrandRepositoryImp implements BrandRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> updateUser(Map<Object?, Object> data) async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getPostApiResponse(AppUrl.updateCustomer, data);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ObjectDTO> getBrand() async {
    try {
      ObjectDTO objectDTO = await _apiServices.getGetApiResponse(AppUrl.brand);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
