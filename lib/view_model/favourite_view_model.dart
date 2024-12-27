import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/list_id_model.dart';
import 'package:my_hotel_and_restaurants/model/search_model.dart';
import 'package:my_hotel_and_restaurants/repository/Hotel/hotel_repository.dart';
import 'package:my_hotel_and_restaurants/utils/favorite_db.dart';

class FavouriteViewModel extends ChangeNotifier {
  final HotelRepository hotelRepository;
  List<FavouriteModel> favouriteList = [];
  List<HotelModel> hotelModels = [];
  FavouriteViewModel({required this.hotelRepository}) {
    favouriteList = FavouriteDB.getListFavorite();
    fetchFavouriteList();
  }

  ApiResponse<List<SearchModel>> favouriteViewModel = ApiResponse.loading();

  void setFavouriteResponseModel(ApiResponse<List<SearchModel>> apiResponse) {
    favouriteViewModel = apiResponse;
    notifyListeners();
  }

  void addFavouriteId(int id) {
    FavouriteDB.saveFavoriteId(id);
    favouriteList = FavouriteDB.getListFavorite();
    fetchFavouriteList().then((_) {
      notifyListeners();
    });
  }

  bool checkFavouriteId(int id) {
    return favouriteList.any((favourite) => favourite.hotel_id == id);
  }

  void deleteFavouriteId(int id) {
    FavouriteDB.deleteFavouriteId(id);
    favouriteList = FavouriteDB.getListFavorite();
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
    hotelRepository.fetchHotelFavouriteId(body).then((value) {
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
