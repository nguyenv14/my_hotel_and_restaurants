import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/customer_menu_item.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/repository/Order/order_repository.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class OrderViewModel extends ChangeNotifier {
  OrderRepository orderRepository;
  OrderViewModel({required this.orderRepository});
  bool isCheckOut = false;
  bool isCheckOutRestaurant = false;
  ApiResponse<OrderModel> orderModelResponse = ApiResponse.loading();
  ApiResponse<List<OrderModel>> orderListByStatus = ApiResponse.loading();
  ApiResponse<List<OrderModel>> orderRestaurantListByStatus =
      ApiResponse.loading();
  ApiResponse<OrderModel> orderRestaurantResponse = ApiResponse.loading();

  setOrderListByStatus(ApiResponse<List<OrderModel>> response) {
    orderListByStatus = response;
    notifyListeners();
  }

  setOrderRestaurantListByStatus(ApiResponse<List<OrderModel>> response) {
    orderRestaurantListByStatus = response;
    notifyListeners();
  }

  setOrderModelResponse(ApiResponse<OrderModel> apiResponse) {
    orderModelResponse = apiResponse;
    notifyListeners();
  }

  setOrderRestaurantModelResponse(ApiResponse<OrderModel> apiResponse) {
    orderRestaurantResponse = apiResponse;
    notifyListeners();
  }

  setCheckOut(bool check) {
    isCheckOut = check;
    notifyListeners();
  }

  setCheckoutRestaurant(bool check) {
    isCheckOutRestaurant = check;
    notifyListeners();
  }

  Future fetchOrderListByStatus(int customerId, int orderStatus) async {
    setOrderListByStatus(ApiResponse.loading());
    orderRepository.getListOrderByStatus(customerId, orderStatus).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<OrderModel> orders = OrderModel.getListOrder(dt);
        setOrderListByStatus(ApiResponse.completed(orders));
      } else {
        setOrderListByStatus(ApiResponse.error("completed"));
      }
    }).onError((error, stackTrace) {
      setOrderListByStatus(ApiResponse.error(error.toString()));
    });
  }

  Future fetchOrderRestaurantListByStatus(
      int customerId, int orderStatus) async {
    setOrderRestaurantListByStatus(ApiResponse.loading());
    orderRepository
        .getListOrderRestaurantByStatus(customerId, orderStatus)
        .then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<OrderModel> orders = OrderModel.getListOrder(dt);
        setOrderRestaurantListByStatus(ApiResponse.completed(orders));
      } else {
        setOrderRestaurantListByStatus(ApiResponse.error("completed"));
      }
    }).onError((error, stackTrace) {
      setOrderRestaurantListByStatus(ApiResponse.error(error.toString()));
    });
  }

  Future cancelOrderByCustomerId(int customerId, int orderId) async {
    setOrderListByStatus(ApiResponse.loading());
    var body = {
      "customer_id": customerId.toString(),
      "order_id": orderId.toString()
    };
    orderRepository.cancelOrderByCustomer(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<OrderModel> orders = OrderModel.getListOrder(dt);
        setOrderListByStatus(ApiResponse.completed(orders));
      } else {
        setOrderListByStatus(ApiResponse.error("completed"));
      }
    }).onError((error, stackTrace) {
      setOrderListByStatus(ApiResponse.error(error.toString()));
    });
  }

  Future sendCommentToOrder(
      int customerId,
      int orderId,
      int hotelId,
      int roomId,
      int typeRoomId,
      String content,
      int price,
      int position,
      int service,
      int sanitary,
      int convenient) async {
    setOrderListByStatus(ApiResponse.loading());
    var body = {
      "customer_id": customerId.toString(),
      "order_id": orderId.toString(),
      "hotel_id": hotelId.toString(),
      "room_id": roomId.toString(),
      "type_room_id": typeRoomId.toString(),
      "evaluate_content": content.toString(),
      "evaluate_loaction_point": position.toString(),
      "evaluate_service_point": service.toString(),
      "evaluate_price_point": price.toString(),
      "evaluate_sanitary_point": sanitary.toString(),
      "evaluate_convenient_point": convenient.toString(),
    };
    orderRepository.sendCommentToOrder(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<OrderModel> orders = OrderModel.getListOrder(dt);
        setOrderListByStatus(ApiResponse.completed(orders));
      } else {
        setOrderListByStatus(ApiResponse.error("completed"));
      }
    }).onError((error, stackTrace) {
      setOrderListByStatus(ApiResponse.error(error.toString()));
    });
  }

  Future checkOut(
      int customerId,
      int typeRoomIdm,
      String startDay,
      String endDay,
      String orderCode,
      String requireText,
      int orderRequire,
      int couponId,
      int day) async {
    var body = {
      "customer_id": customerId.toString(),
      "type_room_id": typeRoomIdm.toString(),
      "startDay": startDay,
      "endDay": endDay,
      "order_code": orderCode,
      "require_text": requireText,
      "order_require": orderRequire.toString(),
      "coupon_id": couponId.toString(),
      "day": day.toString(),
    };
    print(body.toString());
    setCheckOut(true);
    orderRepository.checkout(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> data = value.data;
        if (data.isNotEmpty) {
          OrderModel order = OrderModel.fromJson(data.first);
          setOrderModelResponse(ApiResponse.completed(order));
        } else {
          setOrderModelResponse(ApiResponse.error("No data returned"));
        }
      }
    }).onError((error, stackTrace) {
      setCheckOut(false);
      print(error.toString());
      setOrderModelResponse(ApiResponse.error(error.toString()));
    });
  }

  Future checkOutRestaurant(CustomerModel customer, String date,
      List<CustomerOrderItem> menuList, int restaurantId, int person) async {
    var body = {
      'customer': {
        'customer_id': CustomerDB.getCustomer()!.customer_id!,
        'customer_name': customer.customer_name,
        'customer_phone': customer.customer_phone,
        'customer_email': customer.customer_email,
        'customer_note': customer.customer_note,
      },
      'date': date,
      'menuList': menuList
          .map((item) => {
                'menu_item_id': item.menuItem.menuItemId,
                'quantity': item.quantity,
              })
          .toList(),
      'restaurant_id': restaurantId,
      'person': person,
      'payment': 4,
    };
    setCheckoutRestaurant(true);
    orderRepository.checkoutRestaurant(body).then((value) {
      if (value.statusCode == 200) {
        OrderModel order = OrderModel.fromJson(value.data);
        if (!order.orderId.isNaN) {
          // print(orde);
          setOrderRestaurantModelResponse(ApiResponse.completed(order));
        } else {
          setOrderRestaurantModelResponse(
              ApiResponse.error("No data returned"));
        }
      }
    }).onError((error, stackTrace) {
      setCheckoutRestaurant(false);
      if (kDebugMode) {
        print(error.toString());
      }
      setOrderRestaurantModelResponse(ApiResponse.error(error.toString()));
    });
  }

  Future cancelOrderRestaurantByCustomerId(int customerId, int orderId) async {
    setOrderRestaurantListByStatus(ApiResponse.loading());
    var body = {
      "customer_id": customerId.toString(),
      "order_id": orderId.toString()
    };
    orderRepository.cancelOrderRestaurantByCustomer(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> dt = value.data;
        List<OrderModel> orders = OrderModel.getListOrder(dt);
        setOrderRestaurantListByStatus(ApiResponse.completed(orders));
      } else {
        setOrderRestaurantListByStatus(ApiResponse.error("completed"));
      }
    }).onError((error, stackTrace) {
      setOrderRestaurantListByStatus(ApiResponse.error(error.toString()));
    });
  }
}
