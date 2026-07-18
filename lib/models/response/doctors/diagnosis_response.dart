class DiagnosisResponse {
  final String status;
  final String msg;
  final DiagnosisData? data;

  DiagnosisResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory DiagnosisResponse.fromJson(Map<String, dynamic> json) {
    return DiagnosisResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null ? DiagnosisData.fromJson(json['data']) : null,
    );
  }
}

class DiagnosisData {
  final String id;
  final String patientId;
  final String doctorId;
  final String diagnosis;
  final String shortDiagnosis;
  final String htnTreatment;
  final String dmTreatment;
  final String dlpTreatment;

  DiagnosisData({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.shortDiagnosis,
    required this.htnTreatment,
    required this.dmTreatment,
    required this.dlpTreatment,
  });

  factory DiagnosisData.fromJson(Map<String, dynamic> json) {
    return DiagnosisData(
      id: json['id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? json['patientId']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? json['doctorId']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      shortDiagnosis: json['short_diagnosis']?.toString() ?? json['shortDiagnosis']?.toString() ?? '',
      htnTreatment: json['htn_treatment']?.toString() ?? json['htnTreatment']?.toString() ?? '',
      dmTreatment: json['dm_treatment']?.toString() ?? json['dmTreatment']?.toString() ?? '',
      dlpTreatment: json['dlp_treatment']?.toString() ?? json['dlpTreatment']?.toString() ?? '',
    );
  }
}
