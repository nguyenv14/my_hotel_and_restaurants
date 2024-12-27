import 'package:my_hotel_and_restaurants/data/response/app_url.dart';

class GalleryRestaurantModel {
  final int galleryRestaurantId;
  final int restaurantId;
  final String galleryRestaurantName;
  final String galleryRestaurantImage;
  final String galleryRestaurantContent;

  GalleryRestaurantModel({
    required this.galleryRestaurantId,
    required this.restaurantId,
    required this.galleryRestaurantName,
    required this.galleryRestaurantImage,
    required this.galleryRestaurantContent,
  });

  factory GalleryRestaurantModel.fromJson(Map<String, dynamic> json) {
    return GalleryRestaurantModel(
      galleryRestaurantId: json['gallery_restaurant_id'],
      restaurantId: json['restaurant_id'],
      galleryRestaurantName: json['gallery_restaurant_name'],
      galleryRestaurantImage:
          AppUrl.restaurantImage + json['gallery_restaurant_image'],
      galleryRestaurantContent: json['gallery_restaurant_content'],
    );
  }

  static List<GalleryRestaurantModel> getListGalleryRestaurant(
      List<dynamic> source) {
    return source.map((e) => GalleryRestaurantModel.fromJson(e)).toList();
  }
}
