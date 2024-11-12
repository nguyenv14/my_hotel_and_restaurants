import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class SearchRepository {
  Future<ObjectDTO> search(Map<Object?, Object> data);

  Future<ObjectDTO> filterSearch(Map<Object?, Object> data);
  // Future<ObjectDTO> searchHotel(Map<Object?, Object> data);

  // Future<ObjectDTO> fetchHotelRecomendation();
}
