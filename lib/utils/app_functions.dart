import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hotel_and_restaurants/model/coupon_model.dart';
import 'package:my_hotel_and_restaurants/model/evaluate_model.dart';
import 'package:my_hotel_and_restaurants/model/order_details_model.dart';
import 'package:my_hotel_and_restaurants/model/service_change_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';

class AppFunctions {
  static String formatNumber(num number) {
    final formatter = NumberFormat("#,###", "en_US");
    String formatnumber = formatter.format(number);
    String formattedNumber = formatnumber.toString().replaceAll(',', '.');
    return formattedNumber;
  }

  static String calculatePrice(RoomTypeModel roomTypeModel) {
    double priceRoom = roomTypeModel.typeRoomPrice -
        (roomTypeModel.typeRoomPrice / 100) * roomTypeModel.typeRoomPriceSale;
    return formatNumber(priceRoom);
  }

  static double calculatePriceRoom(RoomTypeModel roomTypeModel) {
    double priceRoom = roomTypeModel.typeRoomPrice -
        (roomTypeModel.typeRoomPrice / 100) * roomTypeModel.typeRoomPriceSale;
    return (priceRoom);
  }

  static String calculatePriceOrder(OrderDetailsModel orderDetailsModel) {
    double priceRoom = orderDetailsModel.priceRoom.toDouble();
    return formatNumber(priceRoom);
  }

  static double calculatePriceForSale(double price, CouponModel couponModel) {
    return (price / 100) * couponModel.couponPriceSale;
  }

  static double calculatePriceForService(
      double price, ServiceChargeModel serviceChargeModel) {
    if (serviceChargeModel.serviceChargeCondition == 1) {
      return price - (price / 100) * serviceChargeModel.serviceChargeFee;
    } else {
      return serviceChargeModel.serviceChargeFee.toDouble();
    }
  }

  static String formatDate(DateTime dateTime) {
    // Lấy ra ngày, tháng và năm từ đối tượng DateTime
    String day = dateTime.day
        .toString()
        .padLeft(2, '0'); // Đảm bảo ngày luôn có hai chữ số
    String month = dateTime.month
        .toString()
        .padLeft(2, '0'); // Đảm bảo tháng luôn có hai chữ số
    String year = dateTime.year.toString();

    // Nối các thành phần lại với nhau để tạo chuỗi định dạng "dd-MM-yyyy"
    return '$day-$month-$year';
  }

  static String generateOrderCode() {
    Random random = Random();
    int ran = 1000 + random.nextInt(9000);
    return "MYHOTEL$ran";
  }

  static String deleteSpaceWhite(String text) {
    text = text.trim();
    text = text.replaceAll(' ', '');
    return text;
  }

  static String convertDateTimeToDay(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);

    // Tạo chuỗi mới theo định dạng "yyyy-MM-dd"
    String dateString =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

    return dateString;
  }

  static double calculateStarEvaluate(EvaluateModel evaluateModel) {
    int point = evaluateModel.evaluateConvenientPoint +
        evaluateModel.evaluateLocationPoint +
        evaluateModel.evaluatePricePoint +
        evaluateModel.evaluateSanitaryPoint +
        evaluateModel.evaluateServicePoint;
    double average = point / 5;
    return average;
  }

  static Color selectColorInOrderByStatus(int status) {
    if (status == 0) {
      return Colors.deepOrangeAccent;
    } else if (status == 1 || status == 2) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  static List<double> searchLatAndLongMap(String map) {
    // Tách latitude và longitude
    List<String> latLng = map.split(',');

    // Chuyển đổi sang dạng số
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);

    // Tạo mảng chứa latitude và longitude
    List<double> latLngArray = [latitude, longitude];

    return latLngArray;
  }

  static int differenceTwoDay(String day1, String day2) {
    // Định dạng ngày
    DateFormat format = DateFormat('dd-MM-yyyy');

    // Chuyển đổi chuỗi thành DateTime
    DateTime dateTime1 = format.parse(day1);
    DateTime dateTime2 = format.parse(day2);

    // Tính khoảng cách giữa hai ngày
    Duration difference = dateTime2.difference(dateTime1);

    // Trả về số ngày chênh lệch
    return difference.inDays;
  }

  static DateTime roundToNearest15(DateTime dateTime) {
    int minute = (dateTime.minute / 15).round() * 15;
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      minute,
    );
  }

  static DateTime minTime() {
    DateTime dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      8, // 8:00 AM
      0,
    );
    return dateTime;
  }

  static DateTime maxTime() {
    DateTime dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      20, // 6:00 PM
      0,
    );
    return dateTime;
  }

  static DateTime getDayOrderRestaurant(DateTime day1, DateTime day2) {
    DateTime combinedDateTime = DateTime(
        day1.year, day1.month, day1.day, day2.hour, day2.minute, day2.second);
    return combinedDateTime;
  }

  static String getStringDate(DateTime date) {
    String dateString =
        "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:00";
    return dateString;
  }

  static String getDayOfDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    String dateString = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    return dateString;
  }

  static String getTimeOfDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    String timeString =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return timeString;
  }

  static bool isSunny(String date) {
    DateTime dateTime = DateTime.parse(date);
    if (dateTime.hour > 5 && dateTime.hour < 18) {
      return true;
    }
    return false;
  }

  static int convertVNDToUSD(num vndAmount) {
    return (vndAmount / 25000).toInt();
  }
}
