class CommonPdfResponse {
  final String status;
  final String msg;
  final String url;

  CommonPdfResponse({
    required this.status,
    required this.msg,
    required this.url,
  });

  factory CommonPdfResponse.fromJson(Map<String, dynamic> json) {
    return CommonPdfResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'msg': msg, 'url': url};
  }
}
