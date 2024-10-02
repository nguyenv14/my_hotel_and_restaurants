import 'package:flutter/cupertino.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/area_model.dart';
import 'package:my_hotel_and_restaurants/repository/Area/area_repository.dart';

class AreaViewModel extends ChangeNotifier {
  AreaRepository areaRepository;
  AreaViewModel({required this.areaRepository});

  ApiResponse<List<AreaModel>> areaListResponse = ApiResponse.loading();
  setAreaListResponse(ApiResponse<List<AreaModel>> response) {
    areaListResponse = response;
    notifyListeners();
  }

  ApiResponse<List<String>> areaListString = ApiResponse.loading();
  setAreaListStringResponse(ApiResponse<List<String>> response) {
    areaListString = response;
    notifyListeners();
  }

  Future fetchAreaList() async {
    setAreaListResponse(ApiResponse.loading());
    areaRepository.fetchAreaList().then((value) {
      List<dynamic> dt = value.data;
      List<AreaModel> areas = AreaModel.getListAreaModel(dt);
      setAreaListResponse(ApiResponse.completed(areas));
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future fetchAreaStringList() async {
    setAreaListStringResponse(ApiResponse.loading());
    areaRepository.fetchAreaList().then((value) {
      List<dynamic> dt = value.data;
      List<AreaModel> areas = AreaModel.getListAreaModel(dt);
      List<String> string = areas.map(
        (element) {
          return element.areaName;
        },
      ).toList();
      setAreaListStringResponse(ApiResponse.completed(string));
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
}
