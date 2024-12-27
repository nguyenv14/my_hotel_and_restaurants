class PaymentModel {
  int paymentId;
  int paymentMethod;
  int paymentStatus;

  PaymentModel({
    required this.paymentId,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
    );
  }
}
