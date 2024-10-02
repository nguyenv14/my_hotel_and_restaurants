import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/banner_model.dart';
import 'package:my_hotel_and_restaurants/repository/Banner/banner_repository.dart';

class BannerViewModel extends ChangeNotifier {
  BannerRepository bannerRepository;

  BannerViewModel({required this.bannerRepository});

  ApiResponse<List<BannerModel>> bannerListResponse = ApiResponse.loading();

  setBannerList(ApiResponse<List<BannerModel>> response) {
    bannerListResponse = response;
    notifyListeners();
  }

  Future fetchBannerResponse() async {
    setBannerList(ApiResponse.loading());
    bannerRepository.fetchBannerList().then((value) {
      List<dynamic> dt = value.data;
      List<BannerModel> hotels = BannerModel.getListBannerModel(dt);
      setBannerList(ApiResponse.completed(hotels));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setBannerList(ApiResponse.error(error.toString()));
    });
  }
}
