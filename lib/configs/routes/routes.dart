import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';
import 'package:my_hotel_and_restaurants/view/checkout_hotel/checkout_page.dart';
import 'package:my_hotel_and_restaurants/view/checkout_hotel/receipt_page.dart';
import 'package:my_hotel_and_restaurants/view/checkout_hotel/select_room_hotel.dart';
import 'package:my_hotel_and_restaurants/view/home/simple_map.dart';
import 'package:my_hotel_and_restaurants/view/login/login_screen.dart';
import 'package:my_hotel_and_restaurants/view/login/register/register_screen.dart';
import 'package:my_hotel_and_restaurants/view/main_screen.dart';
import 'package:my_hotel_and_restaurants/view/myorder/order_detail.dart';
import 'package:my_hotel_and_restaurants/view/product/detail_product.dart';
import 'package:my_hotel_and_restaurants/view/profile/profile_page.dart';
import 'package:my_hotel_and_restaurants/view/profile/update_user_page.dart';
import 'package:my_hotel_and_restaurants/view/search/search_screen.dart';
import 'package:my_hotel_and_restaurants/view/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesName.detailHotel:
        final int hotelId = (settings.arguments as int);
        return hotelId != 0
            ? generateDetailHotelRoute(hotelId)
            : MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("Hotel model is null"),
                  ),
                ),
              );
      case RoutesName.selectRoom:
        HotelModel roomLists = (settings.arguments as HotelModel);
        return MaterialPageRoute(
            builder: (context) => SelectRoomInHotelPage(hotelModel: roomLists));
      case RoutesName.orderDetail:
        OrderModel orderModel = (settings.arguments as OrderModel);
        return MaterialPageRoute(
            builder: (context) => new OrderDetailPage(orderModel: orderModel));
      case RoutesName.receiptPage:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        if (args != null) {
          OrderModel orderModel = args['orderModel'] as OrderModel;
          int days = args['days'] as int;
          return MaterialPageRoute(
            builder: (context) => ReceiptPage(
              orderModel: orderModel,
              days: days,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text("Hotel model is null"),
              ),
            ),
          );
        }
      case RoutesName.checkOutPage:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        if (args != null) {
          HotelModel hotelModel = args['hotel'] as HotelModel;
          RoomModel roomModel = args['room'] as RoomModel;
          RoomTypeModel roomTypeModel = args['roomType'] as RoomTypeModel;
          return MaterialPageRoute(
            builder: (context) => CheckoutPage(
              hotelModel: hotelModel,
              roomModel: roomModel,
              roomTypeModel: roomTypeModel,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text("Hotel model is null"),
              ),
            ),
          );
        }

      case RoutesName.profilePage:
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case RoutesName.updateUserPage:
        return MaterialPageRoute(
          builder: (context) => UpdateUserPage(),
        );
      case RoutesName.registerPage:
        return MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        );
      case RoutesName.searchPage:
        return MaterialPageRoute(
          builder: (context) => SearchScreen(),
        );
      case RoutesName.test:
        return MaterialPageRoute(
          builder: (context) => SimpleMap(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }

  static Route<dynamic> generateDetailHotelRoute(int hotelId) {
    return MaterialPageRoute(
      builder: (context) => DetailProductScreen(hotel_id: hotelId),
    );
  }
}
