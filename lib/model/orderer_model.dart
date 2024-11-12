class OrdererModel {
  int? ordererId; // cho phép null
  int? customerId; // cho phép null
  String? ordererName; // cho phép null
  String? ordererPhone; // cho phép null
  String? ordererEmail; // cho phép null
  int? ordererTypeBed; // cho phép null
  int? ordererSpecialRequirements; // cho phép null
  String? ordererOwnRequire; // cho phép null
  int? ordererBillRequire; // cho phép null
  String? createdAt; // cho phép null

  OrdererModel({
    this.ordererId,
    this.customerId,
    this.ordererName,
    this.ordererPhone,
    this.ordererEmail,
    this.ordererTypeBed,
    this.ordererSpecialRequirements,
    this.ordererOwnRequire,
    this.ordererBillRequire,
    this.createdAt,
  });

  factory OrdererModel.fromJson(Map<String, dynamic> json) {
    return OrdererModel(
      ordererId: json['orderer_id'] as int?, // cho phép null
      customerId: json['customer_id'] as int?, // cho phép null
      ordererName: json['orderer_name'] as String?, // cho phép null
      ordererPhone: json['orderer_phone'] as String?, // cho phép null
      ordererEmail: json['orderer_email'] as String?, // cho phép null
      ordererTypeBed: json['orderer_type_bed'] as int?, // cho phép null
      ordererSpecialRequirements:
          json['orderer_special_requirements'] as int?, // cho phép null
      ordererOwnRequire:
          json['orderer_own_require'] as String?, // cho phép null
      ordererBillRequire: json['orderer_bill_require'] as int?, // cho phép null
      createdAt: json['created_at'] as String?, // cho phép null
    );
  }
}
