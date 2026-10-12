class DischargePatientWebResponse {
  final String status;
  final String msg;
  final String receiptPath;

  const DischargePatientWebResponse({
    required this.status,
    this.msg = '',
    this.receiptPath = '',
  });

  factory DischargePatientWebResponse.fromJson(Map<String, dynamic> json) {
    return DischargePatientWebResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      receiptPath: json['receipt_path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'receipt_path': receiptPath,
    };
  }
}
