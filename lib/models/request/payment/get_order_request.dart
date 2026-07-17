class GetOrderRequest {
  final String userId;
  final int packageId;
  final String amount;
  final String paymentBy;
  final String paymentById;
  final String paymentFor;

  const GetOrderRequest({
    required this.userId,
    required this.packageId,
    required this.amount,
    required this.paymentBy,
    required this.paymentById,
    required this.paymentFor,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'package_id': packageId,
        'amount': amount,
        'payment_by': paymentBy,
        'payment_by_id': paymentById,
        'payment_for': paymentFor,
      };
}

