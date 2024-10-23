import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/myorder/components/order_component.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';
import 'package:provider/provider.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderViewModel>(
      create: (context) => OrderViewModel(orderRepository: getIt())
        ..fetchOrderListByStatus(CustomerDB.getCustomer()!.customer_id!, 0),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 248, 251, 1),
        body: SingleChildScrollView(
          child: Container(child: Consumer<OrderViewModel>(
            builder: (context, value, child) {
              switch (value.orderListByStatus.status) {
                case Status.completed:
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.orderListByStatus.data!.length,
                    itemBuilder: (context, index) {
                      return OrderComponent(
                          orderModel: value.orderListByStatus.data![index],
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
                  if (value.orderListByStatus.message == "completed") {
                    return Container(
                      child: Column(
                        children: [
                          Center(
                            child: Lottie.asset("assets/raw/empty.json"),
                          ),
                          Text("Không có đơn đặt phòng nào!")
                        ],
                      ),
                    );
                  }
                  return Container(
                    child: Center(
                      child: Text(value.orderListByStatus.message.toString()),
                    ),
                  );
                default:
                  return Container();
              }
            },
          )),
        ),
      ),
    );
  }
}
