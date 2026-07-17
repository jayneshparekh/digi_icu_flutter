class GetOrderResponse {
  final String status;
  final String msg;
  final String orderId;
  final String appName;
  final String appLogo;

  const GetOrderResponse({
    required this.status,
    required this.msg,
    required this.orderId,
    required this.appName,
    required this.appLogo,
  });

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) {
    return GetOrderResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      appName: json['app_name']?.toString() ?? '',
      appLogo: json['app_logo']?.toString() ?? '',
    );
  }
}

