import 'package:flutter/foundation.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/search_model.dart';
import 'package:my_hotel_and_restaurants/repository/Search/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  SearchRepository searchRepository;
  SearchViewModel({required this.searchRepository});

  ApiResponse<List<SearchModel>> searchModels = ApiResponse.loading();

  setSearchModel(ApiResponse<List<SearchModel>> response) {
    searchModels = response;
    notifyListeners();
  }

  Future search(String input, int type) async {
    setSearchModel(ApiResponse.loading());
    var body = {"searchText": input, "typeSearch": type.toString()};
    searchRepository.search(body).then(
      (value) {
        List<dynamic> dt = value.data;
        List<SearchModel> searchModels = SearchModel.getListHotel(dt);
        setSearchModel(ApiResponse.completed(searchModels));
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print(error);
          print(stackTrace);
        }
        setSearchModel(ApiResponse.error(error.toString()));
      },
    );
  }

  Future filter(String input, int ranking, int areaId, int priceMin,
      int priceMax, int sortType, int typeHotel, int type) async {
    setSearchModel(ApiResponse.loading());
    var body = {
      "searchText": input,
      "typeSearch": type.toString(),
      "sortType": sortType.toString(),
      "areaId": areaId.toString(),
      "ranking": ranking.toString(),
      "priceMin": priceMin.toString(),
      "priceMax": priceMax.toString(),
      "typeHotel": typeHotel.toString()
    };
    searchRepository.filterSearch(body).then(
      (value) {
        List<dynamic> dt = value.data;
        List<SearchModel> searchModels = SearchModel.getListHotel(dt);
        setSearchModel(ApiResponse.completed(searchModels));
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print(error);
          print(stackTrace);
        }
        setSearchModel(ApiResponse.error(error.toString()));
      },
    );
  }
}
