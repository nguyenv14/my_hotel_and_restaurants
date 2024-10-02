import 'package:flutter/cupertino.dart';
import 'package:my_hotel_and_restaurants/data/response/api_response.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/repository/Customer/customer_repository.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class CustomerViewModel extends ChangeNotifier {
  CustomerModel customerModel = CustomerDB.getCustomer()!;
  final CustomerRepository customerRepository;
  ApiResponse<CustomerModel> customerResponse = ApiResponse.loading();
  CustomerViewModel({required this.customerRepository}) {
    customerModel = CustomerDB.getCustomer()!;
  }

  setCustomerResponse(ApiResponse<CustomerModel> apiResponse) {
    customerResponse = apiResponse;
    notifyListeners();
  }

  setCustomerModel(CustomerModel customer) {
    customerModel = customer;
    notifyListeners();
  }

  Future updateCustomer(CustomerModel customerModel) async {
    // setCustomerResponse(ApiResponse.loading());
    var body = {
      "customer_id": customerModel.customer_id.toString(),
      "customer_name": customerModel.customer_name!,
      "customer_email": customerModel.customer_email!,
      "customer_phone": customerModel.customer_phone.toString(),
    };
    customerRepository.updateUser(body).then((value) {
      if (value.statusCode == 200) {
        CustomerModel customerModel = CustomerModel.fromJson(value.data);
        CustomerDB.saveCustomer(customerModel);
        setCustomerModel(customerModel);
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
}
