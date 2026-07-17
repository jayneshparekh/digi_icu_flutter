class MedicalFormResponse {
  final String status;
  final String msg;
  final MedicalFormData? data;

  MedicalFormResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory MedicalFormResponse.fromJson(Map<String, dynamic> json) {
    return MedicalFormResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null ? MedicalFormData.fromJson(json['data']) : null,
    );
  }
}

class MedicalFormData {
  final String? height;
  final String? weight;

  MedicalFormData({
    this.height,
    this.weight,
  });

  factory MedicalFormData.fromJson(Map<String, dynamic> json) {
    return MedicalFormData(
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
    );
  }
}

