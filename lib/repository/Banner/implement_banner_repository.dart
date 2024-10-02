import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Banner/banner_repository.dart';

class BannerRepositoryImp implements BannerRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  @override
  Future<ObjectDTO> fetchBannerList() async {
    ObjectDTO objectDTO =
        await _apiServices.getGetApiResponse(AppUrl.bannerList);
    return objectDTO;
  }
}
