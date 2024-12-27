import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class RestaurantRepository {
  Future<ObjectDTO> fetchRestaurantByArea(int index);

  Future<ObjectDTO> fetchRestaurantById(int index);

  Future<ObjectDTO> fetchRestaurantFavouriteId(Map<Object?, Object> data);

  // Future<ObjectDTO> searchHotel(Map<Object?, Object> data);

  // Future<ObjectDTO> fetchHotelRecomendation();
}
