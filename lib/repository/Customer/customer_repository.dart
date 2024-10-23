import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class CustomerRepository {
  Future<ObjectDTO> updateUser(Map<Object?, Object> data);
}
