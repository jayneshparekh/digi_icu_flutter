class AdmitPatientResponseModel {
  final String status;
  final String msg;
  final String? admitId;

  const AdmitPatientResponseModel({
    required this.status,
    required this.msg,
    this.admitId,
  });

  factory AdmitPatientResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmitPatientResponseModel(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      admitId: json['admit_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'msg': msg,
    'admit_id': admitId,
  };
}
