class CheckPaymentStatusResponse {
  final String status;
  final String msg;
  final String planStatus;

  CheckPaymentStatusResponse({
    required this.status,
    required this.msg,
    required this.planStatus,
  });

  factory CheckPaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return CheckPaymentStatusResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      planStatus: json['plan_status']?.toString() ?? '1', // default plan not active
    );
  }
}

