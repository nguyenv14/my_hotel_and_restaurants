import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/repository/Order/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  OrderRepository orderRepository;
  OrderViewModel({required this.orderRepository});
  bool isCheckOut = false;
  ApiResponse<OrderModel> orderModelResponse = ApiResponse.loading();
  ApiResponse<List<OrderModel>> orderListByStatus = ApiResponse.loading();

  setOrderListByStatus(ApiResponse<List<OrderModel>> response) {
    orderListByStatus = response;
    notifyListeners();
  }

  setOrderModelResponse(ApiResponse<OrderModel> apiResponse) {
    orderModelResponse = apiResponse;
    notifyListeners();
  }

  setCheckOut(bool check) {
    isCheckOut = check;
    notifyListeners();
  }

  Future fetchOrderListByStatus(int customer_id, int order_status) async {
    setOrderListByStatus(ApiResponse.loading());
    orderRepository
        .getListOrderByStatus(customer_id, order_status)
        .then((value) {
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

  Future cancelOrderByCustomerId(int customer_id, int order_id) async {
    setOrderListByStatus(ApiResponse.loading());
    var body = {
      "customer_id": customer_id.toString(),
      "order_id": order_id.toString()
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
      int customer_id,
      int order_id,
      int hotel_id,
      int room_id,
      int typeRoomId,
      String content,
      int price,
      int position,
      int service,
      int sanitary,
      int convenient) async {
    setOrderListByStatus(ApiResponse.loading());
    var body = {
      "customer_id": customer_id.toString(),
      "order_id": order_id.toString(),
      "hotel_id": hotel_id.toString(),
      "room_id": room_id.toString(),
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
      int customer_id,
      int type_room_idm,
      String startDay,
      String endDay,
      String order_code,
      String require_text,
      int order_require,
      int coupon_id,
      int day) async {
    var body = {
      "customer_id": customer_id.toString(),
      "type_room_id": type_room_idm.toString(),
      "startDay": startDay,
      "endDay": endDay,
      "order_code": order_code,
      "require_text": require_text,
      "order_require": order_require.toString(),
      "coupon_id": coupon_id.toString(),
      "day": day.toString(),
    };
    setCheckOut(true);
    orderRepository.checkout(body).then((value) {
      if (value.statusCode == 200) {
        List<dynamic> data = value.data;
        if (data.isNotEmpty) {
          // Lấy phần tử đầu tiên từ danh sách và chuyển đổi nó thành một đối tượng OrderModel
          OrderModel order = OrderModel.fromJson(data.first);
          setOrderModelResponse(ApiResponse.completed(order));
        } else {
          // Xử lý trường hợp không có dữ liệu trả về
          setOrderModelResponse(ApiResponse.error("No data returned"));
        }
      }
      // setCheckOut(false);
      // setOrderModelResponse(ApiResponse.loading());
    }).onError((error, stackTrace) {
      setCheckOut(false);
      print(error.toString());
      setOrderModelResponse(ApiResponse.error(error.toString()));
    });
  }
}
