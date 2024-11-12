import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/my_order_restaurant/components/order_restaurant_componet.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';
import 'package:provider/provider.dart';

class CanceledRestaurantPage extends StatefulWidget {
  const CanceledRestaurantPage({super.key});

  @override
  State<CanceledRestaurantPage> createState() => _CanceledRestaurantPageState();
}

class _CanceledRestaurantPageState extends State<CanceledRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderViewModel>(
      create: (context) => OrderViewModel(orderRepository: getIt())
        ..fetchOrderRestaurantListByStatus(
            CustomerDB.getCustomer()!.customer_id!, -1),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 248, 251, 1),
        body: SingleChildScrollView(
          child: Consumer<OrderViewModel>(
            builder: (context, value, child) {
              switch (value.orderRestaurantListByStatus.status) {
                case Status.completed:
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.orderRestaurantListByStatus.data!.length,
                    itemBuilder: (context, index) {
                      return OrderRestaurantComponent(
                          orderModel:
                              value.orderRestaurantListByStatus.data![index],
                          orderViewModel: value);
                    },
                  );
                case Status.loading:
                  return Container(
                    child: Center(
                      child: Lottie.asset("assets/raw/waiting_1.json"),
                    ),
                  );
                case Status.error:
                  if (value.orderRestaurantListByStatus.message ==
                      "completed") {
                    return Container(
                      child: Column(
                        children: [
                          Center(
                            child: Lottie.asset("assets/raw/empty.json"),
                          ),
                          const Text("Không có đơn đặt phòng nào!")
                        ],
                      ),
                    );
                  }
                  return Container(
                    child: Center(
                      child: Text(
                          value.orderRestaurantListByStatus.message.toString()),
                    ),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
