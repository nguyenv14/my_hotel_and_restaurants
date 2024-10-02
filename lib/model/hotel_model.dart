import 'package:my_hotel_and_restaurants/model/area_model.dart';
import 'package:my_hotel_and_restaurants/model/brand_model.dart';
import 'package:my_hotel_and_restaurants/model/evaluate_model.dart';
import 'package:my_hotel_and_restaurants/model/gallery_hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
import 'package:my_hotel_and_restaurants/model/service_change_model.dart';

class HotelModel {
  final int hotelId;
  final String hotelName;
  final int hotelRank;
  final int hotelType;
  final int brandId;
  final BrandModel brand;
  final List<EvaluateModel>? evaluates;
  final ServiceChargeModel? serviceChanges;
  final List<GalleryHotelModel> galleryHotel;
  // final int areaId;
  final List<RoomModel> rooms;
  final AreaModel areaModel;
  final String hotelPlaceDetails;
  final String hotelLinkPlace;
  final String hotelJfamePlace;
  final String hotelImage;
  final String hotelDesc;
  final String hotelTagKeyword;
  final int hotelView;
  final int hotelStatus;

  HotelModel({
    required this.hotelId,
    required this.hotelName,
    required this.hotelRank,
    required this.hotelType,
    required this.brandId,
    required this.galleryHotel,
    // required this.areaId,
    this.evaluates,
    this.serviceChanges,
    required this.brand,
    required this.rooms,
    required this.areaModel,
    required this.hotelPlaceDetails,
    required this.hotelLinkPlace,
    required this.hotelJfamePlace,
    required this.hotelImage,
    required this.hotelDesc,
    required this.hotelTagKeyword,
    required this.hotelView,
    required this.hotelStatus,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    print("hotel7");
    List<dynamic> areaJsonList = json['rooms'] ?? [];
    List<RoomModel> rooms =
        areaJsonList.map((areaJson) => RoomModel.fromJson(areaJson)).toList();

    List<dynamic> galleryHotel = json['gallery_hotel'] ?? [];
    List<GalleryHotelModel> gallery =
        galleryHotel.map((e) => GalleryHotelModel.fromJson(e)).toList();

    final Map<String, dynamic> areaJson = json['area'] ?? {};
    AreaModel areaModel = AreaModel.fromJson(areaJson);
    print("hotel6");
    final Map<String, dynamic> brandJson = json['brand'] ?? {};
    BrandModel brandModel = BrandModel.fromJson(brandJson);
    print("hotel5");
    List<dynamic>? evaluatesJsonList = json['evaluates'];
    List<EvaluateModel> evaluatesList = [];
    if (evaluatesJsonList != null) {
      evaluatesList = evaluatesJsonList
          .map((evaluateJson) => EvaluateModel.fromJson(evaluateJson))
          .toList();
    }

    // List<dynamic>? serviceJson = json['service_change'];
    final Map<String, dynamic> serviceJson = json['service_change'] ?? {};
    ServiceChargeModel serviceChargeModel =
        ServiceChargeModel.fromJson(serviceJson);
    return HotelModel(
      hotelId: json['hotel_id'],
      hotelName: json['hotel_name'],
      hotelRank: json['hotel_rank'],
      hotelType: json['hotel_type'],
      brandId: json['brand_id'],
      serviceChanges: serviceChargeModel,
      evaluates: evaluatesList,
      brand: brandModel,
      rooms: rooms,
      galleryHotel: gallery,
      areaModel: areaModel,
      hotelPlaceDetails: json['hotel_placedetails'],
      hotelLinkPlace: json['hotel_linkplace'],
      hotelJfamePlace: json['hotel_jfameplace'],
      hotelImage: json['hotel_image'],
      hotelDesc: json['hotel_desc'],
      hotelTagKeyword: json['hotel_tag_keyword'],
      hotelView: json['hotel_view'],
      hotelStatus: json['hotel_status'],
    );
  }

  static List<HotelModel> getListHotel(List<dynamic> source) {
    List<HotelModel> hotelList =
        source.map((e) => HotelModel.fromJson(e)).toList();
    return hotelList;
  }
}
