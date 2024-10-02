import 'package:my_hotel_and_restaurants/model/order_details_model.dart';
import 'package:my_hotel_and_restaurants/model/orderer_model.dart';
import 'package:my_hotel_and_restaurants/model/payment_model.dart';

class OrderModel {
  int orderId;
  String startDay;
  String endDay;
  int ordererId;
  OrdererModel ordererModel;
  int paymentId;
  PaymentModel paymentModel;
  OrderDetailsModel orderDetailsModel;
  int orderStatus;
  String orderCode;
  String couponNameCode;
  num couponSalePrice;
  String createdAt;

  OrderModel({
    required this.orderId,
    required this.startDay,
    required this.endDay,
    required this.ordererId,
    required this.ordererModel,
    required this.paymentId,
    required this.paymentModel,
    required this.orderDetailsModel,
    required this.orderStatus,
    required this.orderCode,
    required this.couponNameCode,
    required this.couponSalePrice,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> ordererJson = json['orderer'] ?? {};
    final OrdererModel orderer = OrdererModel.fromJson(ordererJson);
    final Map<String, dynamic> paymentJson = json['payment'] ?? {};
    final PaymentModel payment = PaymentModel.fromJson(paymentJson);
    final Map<String, dynamic> orderDetailJson = json['orderDetail'] ?? {};
    final OrderDetailsModel orderDetail =
        OrderDetailsModel.fromJson(orderDetailJson);
    print("Order");
    return OrderModel(
      orderId: json['orderId'],
      startDay: json['startDay'],
      endDay: json['endDay'],
      ordererId: json['ordererId'],
      ordererModel: orderer,
      paymentId: json['paymentId'],
      paymentModel: payment,
      orderDetailsModel: orderDetail,
      orderStatus: json['orderStatus'],
      orderCode: json['orderCode'],
      couponNameCode: json['couponNameCode'],
      couponSalePrice: json['couponSalePrice'],
      createdAt: json['createdAt'],
    );
  }

  static List<OrderModel> getListOrder(List<dynamic> source) {
    List<OrderModel> hotelList =
        source.map((e) => OrderModel.fromJson(e)).toList();
    return hotelList;
  }
}
