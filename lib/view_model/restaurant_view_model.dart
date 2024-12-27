import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';
import 'package:my_hotel_and_restaurants/repository/Restaurant/restaurant_repository.dart';

class RestaurantViewModel extends ChangeNotifier {
  RestaurantRepository restaurantRepository;
  RestaurantViewModel({required this.restaurantRepository});

  ApiResponse<List<RestaurantModel>> restaurantListByArea =
      ApiResponse.loading();

  ApiResponse<RestaurantModel> restaurantDetail = ApiResponse.loading();

  setRestaurantListByArea(ApiResponse<List<RestaurantModel>> response) {
    restaurantListByArea = response;
    notifyListeners();
  }

  setRestaurantDetail(ApiResponse<RestaurantModel> response) {
    restaurantDetail = response;
    notifyListeners();
  }

  Future fetchRestaurantListByArea(int index) async {
    setRestaurantListByArea(ApiResponse.loading());
    restaurantRepository.fetchRestaurantByArea(index).then((value) {
      List<dynamic> dt = value.data;
      List<RestaurantModel> hotels = RestaurantModel.getListRestaurant(dt);
      setRestaurantListByArea(ApiResponse.completed(hotels));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      setRestaurantListByArea(ApiResponse.error(error.toString()));
    });
  }

  Future fetchRestaurantDetailByID(int index) async {
    setRestaurantDetail(ApiResponse.loading());
    restaurantRepository.fetchRestaurantById(index).then(
      (value) {
        List<dynamic> dt = value.data;
        List<RestaurantModel> restaurants =
            RestaurantModel.getListRestaurant(dt);
        RestaurantModel restaurantModel = restaurants.first;
        setRestaurantDetail(ApiResponse.completed(restaurantModel));
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print(error);
          print(stackTrace);
        }
        setRestaurantDetail(ApiResponse.error(error.toString()));
      },
    );
  }
}
