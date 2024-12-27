import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/constant.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(num price) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(price.toInt(), "usd");
      print(131231);
      if (paymentIntentClientSecret == null) return false;
      print(2);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Nguyen Vinh",
      ))
          .then(
        (value) async {
          print(3);
          await _processPayment().then(
            (value) {
              print(4);
              return true;
            },
          );
        },
      );
      print(5);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      print(6);
      return false;
    }
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // await Stripe.instance.();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      int convertPrice = AppFunctions.convertVNDToUSD(amount) * 100;
      print(1);
      final Dio dio = Dio();
      print(12);
      Map<String, dynamic> data = {"amount": 80 * 100, "currency": currency};
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $stripeSecretKey",
              "Content-Type": 'application/x-www-form-urlencoded'
            },
          ));
      print(123);
      if (response.data != null) {
        print(response.data['client_secret']);
        return response.data['client_secret'];
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
