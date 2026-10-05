class GetRemainCreditRes {
  final String status;
  final String msg;
  final String myCredit;

  GetRemainCreditRes({
    required this.status,
    required this.msg,
    required this.myCredit,
  });

  factory GetRemainCreditRes.fromJson(Map<String, dynamic> json) {
    return GetRemainCreditRes(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      myCredit: json['my_credit']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'my_credit': myCredit,
    };
  }
}
