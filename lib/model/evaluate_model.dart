class EvaluateModel {
  final int evaluateId;
  final int? customerId;
  final String customerName;
  final int hotelId;
  final int roomId;
  final int typeRoomId;
  final String evaluateTitle;
  final String evaluateContent;
  final int evaluateLocationPoint;
  final int evaluateServicePoint;
  final int evaluatePricePoint;
  final int evaluateSanitaryPoint;
  final int evaluateConvenientPoint;
  final String createdAt;

  EvaluateModel({
    required this.evaluateId,
    required this.customerId,
    required this.customerName,
    required this.hotelId,
    required this.roomId,
    required this.typeRoomId,
    required this.evaluateTitle,
    required this.evaluateContent,
    required this.evaluateLocationPoint,
    required this.evaluateServicePoint,
    required this.evaluatePricePoint,
    required this.evaluateSanitaryPoint,
    required this.evaluateConvenientPoint,
    required this.createdAt,
  });

  factory EvaluateModel.fromJson(Map<String, dynamic> json) {
    return EvaluateModel(
      evaluateId: json['evaluate_id'],
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'],
      hotelId: json['hotel_id'],
      roomId: json['room_id'],
      typeRoomId: json['type_room_id'],
      evaluateTitle: json['evaluate_title'],
      evaluateContent: json['evaluate_content'],
      evaluateLocationPoint: json['evaluate_loaction_point'],
      evaluateServicePoint: json['evaluate_service_point'],
      evaluatePricePoint: json['evaluate_price_point'],
      evaluateSanitaryPoint: json['evaluate_sanitary_point'],
      evaluateConvenientPoint: json['evaluate_convenient_point'],
      createdAt: json['created_at'],
    );
  }
}
