import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';

abstract class BrandRepository {
  Future<ObjectDTO> getBrand();
}
