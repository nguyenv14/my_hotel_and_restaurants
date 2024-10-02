import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class HotelRepository {
  Future<ObjectDTO> fetchHotelByType(int index);

  Future<ObjectDTO> fetchHotelByArea(int index);

  Future<ObjectDTO> fetchHotelById(int index);

  Future<ObjectDTO> fetchHotelFavouriteId(Map<Object?, Object> data);

  Future<ObjectDTO> searchHotel(Map<Object?, Object> data);

  Future<ObjectDTO> fetchHotelRecomendation();
}
