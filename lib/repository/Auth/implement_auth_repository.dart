import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/network/network_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/repository/Auth/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<ObjectDTO> checkLogin(Map<Object?, Object> data) async {
    ObjectDTO response =
        await _apiServices.getPostApiResponse(AppUrl.CheckLogin, data);
    return response;
  }

  @override
  Future<ObjectDTO> signUp(Map<Object?, Object> data) async {
    ObjectDTO response =
        await _apiServices.getPostApiResponse(AppUrl.signUp, data);
    return response;
  }

  @override
  Future<ObjectDTO> singInWithGG(Map<Object?, Object> data) async {
    ObjectDTO response =
        await _apiServices.getPostApiResponse(AppUrl.SignInGG, data);
    return response;
  }
}
