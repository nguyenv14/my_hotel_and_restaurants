import 'package:my_hotel_and_restaurants/data/response/app_url.dart';

class SearchModel {
  final int id;
  final String searchName;
  final int searchRank;
  final String searchImage;
  final int? searchPrice;
  final String areaName;
  final String? evaluate;
  final int? type;

  SearchModel(
      {required this.id,
      required this.searchName,
      required this.searchRank,
      required this.searchImage,
      this.searchPrice,
      required this.areaName,
      this.evaluate,
      required this.type});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    print(AppUrl.imageUnique + json['searchImage']);
    return SearchModel(
        id: json['id'],
        searchName: json['searchName'],
        searchRank: json['searchRank'],
        searchImage: AppUrl.imageUnique + json['searchImage'],
        searchPrice: json['searchPrice'],
        areaName: json['searchArea'],
        evaluate: json['evaluate'],
        type: json['type']);
  }

  static List<SearchModel> getListHotel(List<dynamic> source) {
    return source.map((e) => SearchModel.fromJson(e)).toList();
  }
}
