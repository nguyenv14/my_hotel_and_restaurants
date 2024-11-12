import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/order_detail_menu.dart';
import 'package:my_hotel_and_restaurants/model/order_details_model.dart';
import 'package:my_hotel_and_restaurants/model/orderer_model.dart';
import 'package:my_hotel_and_restaurants/model/payment_model.dart';

class OrderModel {
  int orderId;
  String startDay;
  String? endDay;
  int? ordererId;
  OrdererModel? ordererModel; // Nullable
  int? paymentId;
  PaymentModel? paymentModel; // Nullable
  OrderDetailsModel? orderDetailsModel; // Nullable
  int orderStatus;
  String? orderCode;
  String? couponNameCode;
  num? couponSalePrice;
  num? total_price; // Nullable
  int? orderType; // Khai báo đúng tên biến
  List<OrderDetailRestaurantModel>? orderDetailRestaurants; // Nullable
  String? createdAt;
  String? restaurantName;
  String? restaurantPlaceDetails;
  String? restaurantImage;
  String? areaName;

  OrderModel({
    required this.orderId,
    required this.startDay,
    required this.endDay,
    required this.ordererId,
    this.ordererModel, // Nullable
    required this.paymentId,
    this.paymentModel, // Nullable
    this.orderDetailsModel, // Nullable
    required this.orderStatus,
    required this.orderCode,
    required this.couponNameCode,
    required this.couponSalePrice,
    this.total_price,
    required this.createdAt,
    required this.orderType, // Khai báo đúng tên biến
    this.orderDetailRestaurants, // Nullable
    this.restaurantName, // New field
    this.restaurantPlaceDetails, // New field
    this.restaurantImage, // New field
    this.areaName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    OrdererModel? orderer;
    if (json['orderer'] != null) {
      orderer = OrdererModel.fromJson(json['orderer']);
    }
    PaymentModel? payment;
    if (json['payment'] != null) {
      payment = PaymentModel.fromJson(json['payment']);
    }
    OrderDetailsModel? orderDetail;
    if (json['orderDetail'] != null) {
      orderDetail = OrderDetailsModel.fromJson(json['orderDetail']);
    }
    List<OrderDetailRestaurantModel>? orderDetailRestaurant;
    if (json['orderDetailRestaurant'] != null) {
      orderDetailRestaurant = OrderDetailRestaurantModel.getListOrderDetails(
          json['orderDetailRestaurant']);
    }
    String restaurantImage = '';
    if (json['restaurant_image'] != null) {
      restaurantImage = AppUrl.restaurantImage + json['restaurant_image'];
    }
    return OrderModel(
      orderId: json['orderId'],
      startDay: json['startDay'],
      endDay: json['endDay'],
      ordererId: json['ordererId'],
      ordererModel: orderer, // Gán giá trị nếu tồn tại
      paymentId: json['paymentId'],
      paymentModel: payment, // Gán giá trị nếu tồn tại
      orderDetailsModel: orderDetail, // Gán giá trị nếu tồn tại
      orderStatus: json['orderStatus'],
      orderCode: json['orderCode'],
      couponNameCode: json['couponNameCode'],
      couponSalePrice: json['couponSalePrice'],
      total_price: json['total_price'], // Nullable
      createdAt: json['createdAt'],
      orderType: json['orderType'], // Khai báo đúng tên biến
      orderDetailRestaurants: orderDetailRestaurant,
      restaurantName: json['restaurant_name'], // New field
      restaurantPlaceDetails: json['restaurant_placedetails'], // New field
      restaurantImage: restaurantImage, // New field
      areaName: json['area_name'],
    );
  }

  static List<OrderModel> getListOrder(List<dynamic> source) {
    return source.map((e) => OrderModel.fromJson(e)).toList();
  }
}
