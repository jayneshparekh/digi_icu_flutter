class OrderResponse {
  final String status;
  final String msg;
  final String orderId;
  final String appName;
  final String appLogo;

  OrderResponse({
    required this.status,
    required this.msg,
    required this.orderId,
    required this.appName,
    required this.appLogo,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      appName: json['app_name']?.toString() ?? '',
      appLogo: json['app_logo']?.toString() ?? '',
    );
  }
}
