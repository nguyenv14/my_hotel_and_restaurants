class CustomerModel {
  int? customer_id;
  String? customer_name;
  int? customer_phone;
  String? customer_email;
  String? customer_password;

  CustomerModel({
    this.customer_id,
    this.customer_name,
    this.customer_phone,
    this.customer_email,
    this.customer_password,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customer_id: json['customer_id'],
      customer_name: json['customer_name'],
      customer_phone: json['customer_phone'],
      customer_email: json['customer_email'],
      customer_password: json['customer_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customer_id,
      'customer_name': customer_name,
      'customer_phone': customer_phone,
      'customer_email': customer_email,
      'customer_password': customer_password,
    };
  }
}
