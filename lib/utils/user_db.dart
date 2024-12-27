import 'package:get_storage/get_storage.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';

class CustomerDB {
  static void saveCustomer(CustomerModel customer) {
    final box = GetStorage();
    dynamic source = customer.toJson();
    box.write("USER", source);
  }

  static CustomerModel? getCustomer() {
    final box = GetStorage();
    CustomerModel? customer = CustomerModel.fromJson(box.read("USER"));
    return customer;
  }

  static CustomerModel? getNameCustomer() {
    final box = GetStorage();
    dynamic customerData = box.read("USER");
    CustomerModel? customer;
    if (customerData != null) {
      customer = CustomerModel.fromJson(customerData);
    }
    return customer;
  }

  static bool checkAuth() {
    final box = GetStorage();
    dynamic customerData = box.read("USER");
    if (customerData != null) {
      // customer = CustomerModel.fromJson(customerData);
      return true;
    }
    return false;
  }

  static void deleteCustomer() {
    final box = GetStorage();
    box.write("USER", null);
  }
}
