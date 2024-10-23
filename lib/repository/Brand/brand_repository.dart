import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class BrandRepository {
  Future<ObjectDTO> getBrand();
}
