import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/area_model.dart';
import 'package:my_hotel_and_restaurants/model/gallery_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/model/menu_restaurant_model.dart';

class RestaurantModel {
  final int restaurantId;
  final String restaurantName;
  final int restaurantRank;
  final String restaurantPlaceDetails;
  final String restaurantLinkPlace;
  final String restaurantImage;
  final AreaModel area;
  final String restaurantDescription;
  final int restaurantStatus;
  final List<MenuModel> menuList;
  final List<GalleryRestaurantModel> galleryRestaurantList;

  RestaurantModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantRank,
    required this.restaurantPlaceDetails,
    required this.restaurantLinkPlace,
    required this.restaurantImage,
    required this.area,
    required this.restaurantDescription,
    required this.restaurantStatus,
    required this.menuList,
    required this.galleryRestaurantList,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> menuJsonList = json['menus'] ?? [];
    List<MenuModel> menuList =
        menuJsonList.map((menuJson) => MenuModel.fromJson(menuJson)).toList();

    // List<dynamic> areaJsonList = json['rooms'] ?? [];
    // List<RoomModel> rooms =
    //     areaJsonList.map((areaJson) => RoomModel.fromJson(areaJson)).toList();

    List<dynamic> galleryJsonList = json['gallery_restaurant'] ?? [];
    List<GalleryRestaurantModel> galleryList = galleryJsonList
        .map((galleryJson) => GalleryRestaurantModel.fromJson(galleryJson))
        .toList();

    final Map<String, dynamic> areaJson = json['area'] ?? {};
    AreaModel areaModel = AreaModel.fromJson(areaJson);

    return RestaurantModel(
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant_name'],
      restaurantRank: json['restaurant_rank'],
      restaurantPlaceDetails: json['restaurant_placedetails'],
      restaurantLinkPlace: json['restaurant_linkplace'],
      restaurantImage: AppUrl.restaurantImage + json['restaurant_image'],
      area: areaModel,
      restaurantDescription: json['restaurant_desc'],
      restaurantStatus: json['restaurant_status'],
      menuList: menuList,
      galleryRestaurantList: galleryList,
    );
  }

  static List<RestaurantModel> getListRestaurant(List<dynamic> source) {
    return source.map((e) => RestaurantModel.fromJson(e)).toList();
  }
}
