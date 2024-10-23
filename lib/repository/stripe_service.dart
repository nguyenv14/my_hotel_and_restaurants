import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:my_hotel_and_restaurants/utils/constant.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(100, "usd");
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Nguyen Vinh",
      ));
      await _processPayment();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {"amount": 1000, "currency": currency};
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $stripeSecretKey",
              "Content-Type": 'application/x-www-form-urlencoded'
            },
          ));
      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
