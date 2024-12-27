import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/brand_model.dart';
import 'package:my_hotel_and_restaurants/repository/Brand/brand_repository.dart';

class BrandViewModel extends ChangeNotifier {
  BrandRepository brandRepository;
  BrandViewModel({required this.brandRepository});
  // bool couponHide = false;
  // ApiResponse<CouponModel> coupon = ApiResponse.loading();
  ApiResponse<List<BrandModel>> brandListResponse = ApiResponse.loading();
  setBrandListResponse(ApiResponse<List<BrandModel>> response) {
    brandListResponse = response;
    notifyListeners();
  }

  Future fetchBrandList() async {
    setBrandListResponse(ApiResponse.loading());
    brandRepository.getBrand().then((value) {
      List<dynamic> dt = value.data;
      List<BrandModel> areas = BrandModel.getListBrandModel(dt);
      setBrandListResponse(ApiResponse.completed(areas));
    }).onError((error, stackTrace) {
      // print("hihi");
      if (kDebugMode) {
        print(error.toString());
      }
      setBrandListResponse(ApiResponse.error(error.toString()));
    });
  }
}
