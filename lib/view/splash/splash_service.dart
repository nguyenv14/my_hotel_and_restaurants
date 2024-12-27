import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class SplashService {
  void checkAuth(BuildContext context) {
    if (CustomerDB.checkAuth()) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.home, (route) => false),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.login, (route) => false),
      );
    }
  }
}
