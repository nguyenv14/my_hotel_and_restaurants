import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_hotel_and_restaurants/data/app_exceptions.dart';
import 'package:my_hotel_and_restaurants/data/network/base_api_services.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';

class NetworkApiService implements BaseApiServices {
  @override
  Future<ObjectDTO> getGetApiResponse(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final objectDTO = ObjectDTO.fromJson(responseData);
        return objectDTO;
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<ObjectDTO> getPostApiResponse(
      String url, Map<Object?, Object> data) async {
    if (kDebugMode) {
      print(url);
      print(data.toString());
    }
    try {
      Response response = await post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final objectDTO = ObjectDTO.fromJson(responseData);
        return objectDTO;
      } else {
        // Nếu không thành công, ném ra một ngoại lệ và xử lý ngoại lệ này ở nơi gọi hàm
        throw FetchDataException(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      // Bắt và xử lý các ngoại lệ khác nếu có
      throw FetchDataException("Error: $e");
    }
  }

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicating with server');
    }
  }
}
