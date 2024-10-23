import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/repository/Area/area_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Area/implement_area_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Auth/auth_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Auth/implement_auth_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Banner/banner_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Banner/implement_banner_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Brand/brand_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Brand/implement_brand_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Coupon/coupon_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Coupon/implement_conpon_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Customer/customer_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Customer/implement_customer_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Hotel/hotel_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Hotel/implement_hotel_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Order/implement_order_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Order/order_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Restaurant/implement_restaurant_repository.dart';
import 'package:my_hotel_and_restaurants/repository/Restaurant/restaurant_repository.dart';
import 'package:my_hotel_and_restaurants/utils/constant.dart';
import 'package:my_hotel_and_restaurants/view/splash/splash_screen.dart';
import 'package:my_hotel_and_restaurants/view_model/area_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/banner_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/brand_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/coupon_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/customer_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/login/login_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKey;
  await GetStorage.init();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDvEpgqFIYl9NamrtsDy5RDw_ciXPA3jn0',
    appId: '1:868969051955:android:5589457e715c6f00333046',
    messagingSenderId: 'sendid',
    projectId: 'myhotel-46cad',
    storageBucket: 'myhotel-46cad.appspot.com',
  ));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp());
  getIt.registerLazySingleton<HotelRepository>(() => HotelRepositoryImp());
  getIt.registerLazySingleton<AreaRepository>(() => AreaRepositoryImp());
  getIt.registerLazySingleton<BannerRepository>(() => BannerRepositoryImp());
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImp());
  getIt.registerLazySingleton<CouponRepository>(() => CouponRepositoryImp());
  getIt
      .registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImp());
  getIt.registerLazySingleton<BrandRepository>(() => BrandRepositoryImp());
  getIt.registerLazySingleton<RestaurantRepository>(
      () => RestaurantRepositoryImp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(authRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => HotelViewModel(hotelRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => AreaViewModel(areaRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerViewModel(bannerRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderViewModel(orderRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponViewModel(couponRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => FavouriteViewModel(hotelRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerViewModel(customerRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandViewModel(brandRepository: getIt()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantViewModel(restaurantRepository: getIt()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
