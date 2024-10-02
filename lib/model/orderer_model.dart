class OrdererModel {
  int ordererId;
  int customerId;
  String ordererName;
  String ordererPhone;
  String ordererEmail;
  int ordererTypeBed;
  int ordererSpecialRequirements;
  String ordererOwnRequire;
  int ordererBillRequire;
  String createdAt;

  OrdererModel({
    required this.ordererId,
    required this.customerId,
    required this.ordererName,
    required this.ordererPhone,
    required this.ordererEmail,
    required this.ordererTypeBed,
    required this.ordererSpecialRequirements,
    required this.ordererOwnRequire,
    required this.ordererBillRequire,
    required this.createdAt,
  });

  factory OrdererModel.fromJson(Map<String, dynamic> json) {
    print("Orderer");
    return OrdererModel(
      ordererId: json['orderer_id'],
      customerId: json['customer_id'],
      ordererName: json['orderer_name'],
      ordererPhone: json['orderer_phone'],
      ordererEmail: json['orderer_email'],
      ordererTypeBed: json['orderer_type_bed'],
      ordererSpecialRequirements: json['orderer_special_requirements'],
      ordererOwnRequire: json['orderer_own_require'],
      ordererBillRequire: json['orderer_bill_require'],
      createdAt: json['created_at'],
    );
  }
}
