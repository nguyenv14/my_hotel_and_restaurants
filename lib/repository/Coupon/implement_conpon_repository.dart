import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Coupon/coupon_repository.dart';

class CouponRepositoryImp implements CouponRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> fetchCouponList() async {
    try {
      ObjectDTO objectDTO =
          await _apiServices.getGetApiResponse(AppUrl.couponList);
      return objectDTO;
    } catch (e) {
      throw Exception(e);
    }
  }
}
