import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

abstract class AuthRepository {
  Future<ObjectDTO> checkLogin(Map<Object?, Object> data);

  Future<ObjectDTO> signUp(Map<Object?, Object> data);

  Future<ObjectDTO> singInWithGG(Map<Object?, Object> data);
}
