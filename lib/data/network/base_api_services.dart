import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class BaseApiServices {
  Future<ObjectDTO> getGetApiResponse(String url);

  Future<ObjectDTO> getPostApiResponse(String url, Map<Object?, Object> data);
}
