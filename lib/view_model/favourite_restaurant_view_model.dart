import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/favourite_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/search_model.dart';
import 'package:my_hotel_and_restaurants/repository/Restaurant/restaurant_repository.dart';
import 'package:my_hotel_and_restaurants/utils/favourite_restaurant_db.dart';

class FavouriteRestaurantViewModel extends ChangeNotifier {
  final RestaurantRepository restaurantRepository;
  List<FavouriteRestaurantModel> favouriteList = [];
  List<HotelModel> hotelModels = [];
  FavouriteRestaurantViewModel({required this.restaurantRepository}) {
    favouriteList = FavouriteRestaurantDB.getListFavorite();
    fetchFavouriteList();
  }

  ApiResponse<List<SearchModel>> favouriteViewModel = ApiResponse.loading();

  void setFavouriteResponseModel(ApiResponse<List<SearchModel>> apiResponse) {
    favouriteViewModel = apiResponse;
    notifyListeners();
  }

  void addFavouriteId(int id) {
    FavouriteRestaurantDB.saveFavoriteId(id);
    favouriteList = FavouriteRestaurantDB.getListFavorite();
    fetchFavouriteList().then((_) {
      notifyListeners();
    });
  }

  bool checkFavouriteId(int id) {
    return favouriteList.any((favourite) => favourite.restaurant_id == id);
  }

  void deleteFavouriteId(int id) {
    FavouriteRestaurantDB.deleteFavouriteId(id);
    favouriteList = FavouriteRestaurantDB.getListFavorite();
    fetchFavouriteList().then((_) {
      notifyListeners();
    });
  }

  Future fetchFavouriteList() async {
    setFavouriteResponseModel(ApiResponse.loading());
    var body = {
      "favourites":
          favouriteList.isEmpty ? 1.toString() : jsonEncode(favouriteList),
    };
    print(body.toString());
    restaurantRepository.fetchRestaurantFavouriteId(body).then((value) {
      List<dynamic> dt = value.data;
      List<SearchModel> hotels = SearchModel.getListHotel(dt);
      setFavouriteResponseModel(ApiResponse.completed(hotels));
      notifyListeners();
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
