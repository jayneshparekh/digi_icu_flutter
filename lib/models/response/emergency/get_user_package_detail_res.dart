class GetUserPackageDetailRes {
  final String status;
  final String msg;
  final String remain;

  GetUserPackageDetailRes({
    required this.status,
    required this.msg,
    required this.remain,
  });

  factory GetUserPackageDetailRes.fromJson(Map<String, dynamic> json) {
    return GetUserPackageDetailRes(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      remain: json['remain']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'remain': remain,
    };
  }
}
