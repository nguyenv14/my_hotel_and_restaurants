import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/repository/Hotel/hotel_repository.dart';

class HotelViewModel extends ChangeNotifier {
  HotelRepository hotelRepository;
  HotelViewModel({required this.hotelRepository});

  ApiResponse<List<HotelModel>> hotelListByTypeResponse = ApiResponse.loading();
  ApiResponse<List<HotelModel>> hotelListByLocation = ApiResponse.loading();
  ApiResponse<HotelModel> hotelModelDetail = ApiResponse.loading();
  ApiResponse<List<HotelModel>> hotelListSearchResponse = ApiResponse.loading();
  ApiResponse<List<HotelModel>> hotelListRecomendationResponse =
      ApiResponse.loading();

  setHotelListRecomendationResponse(ApiResponse<List<HotelModel>> response) {
    hotelListRecomendationResponse = response;
    notifyListeners();
  }

  // ApiResponse<List<HotelModel>> hotelBySearchResponse = ApiResponse.loading();
  setHotelListByType(ApiResponse<List<HotelModel>> response) {
    hotelListByTypeResponse = response;
    notifyListeners();
  }

  setHotelListByLocation(ApiResponse<List<HotelModel>> response) {
    hotelListByLocation = response;
    notifyListeners();
  }

  setHotelById(ApiResponse<HotelModel> response) {
    hotelModelDetail = response;
    notifyListeners();
  }

  setHotelListSearchResponse(ApiResponse<List<HotelModel>> response) {
    hotelListSearchResponse = response;
    notifyListeners();
  }

  Future fetchHotelListRecomendation() async {
    setHotelListRecomendationResponse(ApiResponse.loading());
    hotelRepository.fetchHotelRecomendation().then((value) {
      List<dynamic> dt = value.data;
      List<HotelModel> hotels = HotelModel.getListHotel(dt);
      setHotelListRecomendationResponse(ApiResponse.completed(hotels));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setHotelListRecomendationResponse(ApiResponse.error(error.toString()));
    });
  }

  Future fetchHotelListByType({int type = 0}) async {
    setHotelListByType(ApiResponse.loading());
    hotelRepository.fetchHotelByType(type).then((value) {
      List<dynamic> dt = value.data;
      List<HotelModel> hotels = HotelModel.getListHotel(dt);
      setHotelListByType(ApiResponse.completed(hotels));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setHotelListByType(ApiResponse.error(error.toString()));
    });
  }

  Future fetchHotelListByLocation(int index) async {
    setHotelListByLocation(ApiResponse.loading());
    hotelRepository.fetchHotelByArea(index).then((value) {
      List<dynamic> dt = value.data;
      List<HotelModel> hotels = HotelModel.getListHotel(dt);
      setHotelListByLocation(ApiResponse.completed(hotels));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setHotelListByLocation(ApiResponse.error(error.toString()));
    });
  }

  Future fetchHotelById(int index) async {
    setHotelById(ApiResponse.loading());
    hotelRepository.fetchHotelById(index).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<HotelModel> hotels = HotelModel.getListHotel(dt);
        HotelModel hotelModel = hotels.first;
        setHotelById(ApiResponse.completed(hotelModel));
      } else {
        setHotelById(ApiResponse.error("không load được dữ liệu!"));
      }
    }).onError((error, stackTrace) {
      setHotelById(ApiResponse.error("không load được dữ liệu!"));
    });
  }

  Future searchHotel(
      int locationIndex, int brandId, int typeIndex, String hotelName) async {
    setHotelListSearchResponse(ApiResponse.loading());
    var body = {
      "type_hotel": typeIndex.toString(),
      "location_id": locationIndex.toString(),
      "hotel_name": hotelName,
      "brand_id": brandId.toString(),
    };

    hotelRepository.searchHotel(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<HotelModel> hotels = HotelModel.getListHotel(dt);
        // HotelModel hotelModel = hotels.first;
        setHotelListSearchResponse(ApiResponse.completed(hotels));
      } else {
        setHotelListSearchResponse(
            ApiResponse.error("không load được dữ liệu!"));
      }
    }).onError((error, stackTrace) {
      setHotelListSearchResponse(ApiResponse.error("không load được dữ liệu!"));
    });
  }
}
