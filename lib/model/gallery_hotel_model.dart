import 'package:my_hotel_and_restaurants/data/response/app_url.dart';

class GalleryHotelModel {
  final int galleryHotelId;
  final int hotelId;
  final String galleryHotelName;
  final int galleryHotelType;
  final String galleryHotelImage;
  final String galleryHotelContent;

  GalleryHotelModel({
    required this.galleryHotelId,
    required this.hotelId,
    required this.galleryHotelName,
    required this.galleryHotelType,
    required this.galleryHotelImage,
    required this.galleryHotelContent,
  });

  factory GalleryHotelModel.fromJson(Map<String, dynamic> json) {
    return GalleryHotelModel(
      galleryHotelId: json['gallery_hotel_id'],
      hotelId: json['hotel_id'],
      galleryHotelName: json['gallery_hotel_name'],
      galleryHotelType: json['gallery_hotel_type'],
      galleryHotelImage: json['gallery_hotel_image'],
      galleryHotelContent: json['gallery_hotel_content'],
    );
  }

  static List<GalleryHotelModel> getListHotel(List<dynamic> source) {
    List<GalleryHotelModel> hotelList =
        source.map((e) => GalleryHotelModel.fromJson(e)).toList();
    return hotelList;
  }
}
