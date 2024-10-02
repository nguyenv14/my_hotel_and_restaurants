class ServiceChargeModel {
  final int serviceChargeId;
  final int hotelId;
  final int serviceChargeCondition;
  final int serviceChargeFee;

  ServiceChargeModel({
    required this.serviceChargeId,
    required this.hotelId,
    required this.serviceChargeCondition,
    required this.serviceChargeFee,
  });

  ServiceChargeModel.empty()
      : hotelId = 0,
        serviceChargeId = 0,
        serviceChargeCondition = 0,
        serviceChargeFee = 0;

  factory ServiceChargeModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return ServiceChargeModel.empty();
    }
    return ServiceChargeModel(
      serviceChargeId: json['servicecharge_id'],
      hotelId: json['hotel_id'],
      serviceChargeCondition: json['servicecharge_condition'],
      serviceChargeFee: json['servicecharge_fee'],
    );
  }
}
