import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class CouponRepository {
  Future<ObjectDTO> fetchCouponList();
}
