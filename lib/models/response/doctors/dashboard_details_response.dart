class DashboardDetailsResponse {
  final String status;
  final String msg;
  final DashboardTabDataModel? data;

  DashboardDetailsResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory DashboardDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardDetailsResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null ? DashboardTabDataModel.fromJson(json['data']) : null,
    );
  }
}

class DashboardTabDataModel {
  final String appointmentBy;
  final String lastVisit;
  final String firstVisit;
  final String visitNo;
  final String diagnosis;
  final String significantHistory;
  final String riskFactors;
  final String endOrgan;
  final String todayBp;
  final String baselineBp;
  final String targetBp;
  final String causions;
  final String events;
  final String height;
  final List<String> whoIshRisk;
  final List<String> whoMsg;
  final List<DashboardData> symptoms;
  final List<DashboardData> weight;
  final List<DashboardData> creatinine;
  final List<DashboardData> cholesterol;
  final List<DashboardData> sugar;
  final List<DashboardData> hba1c;
  final List<DashboardData> urineAlbumin;
  final List<AdmissionHistoryItem> admissionHistory;

  DashboardTabDataModel({
    required this.appointmentBy,
    required this.lastVisit,
    required this.firstVisit,
    required this.visitNo,
    required this.diagnosis,
    required this.significantHistory,
    required this.riskFactors,
    required this.endOrgan,
    required this.todayBp,
    required this.baselineBp,
    required this.targetBp,
    required this.causions,
    required this.events,
    required this.height,
    required this.whoIshRisk,
    required this.whoMsg,
    required this.symptoms,
    required this.weight,
    required this.creatinine,
    required this.cholesterol,
    required this.sugar,
    required this.hba1c,
    required this.urineAlbumin,
    required this.admissionHistory,
  });

  factory DashboardTabDataModel.fromJson(Map<String, dynamic> json) {
    var whoRiskList = (json['who_ish_risk'] as List?)?.map((e) => e.toString()).toList() ?? [];
    var whoMsgList = (json['who_msg'] as List?)?.map((e) => e.toString()).toList() ?? [];

    var symptomsList = (json['symptoms'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var weightList = (json['weight'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var creatinineList = (json['creatinine'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var cholesterolList = (json['cholesterol'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var sugarList = (json['sugar'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var hba1cList = (json['hba1c'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];
    var urineAlbuminList = (json['urine_albumin'] as List?)?.map((e) => DashboardData.fromJson(e)).toList() ?? [];

    var admissionHistoryList = (json['admission_history'] as List? ?? json['admissionHistory'] as List?)?.map((e) => AdmissionHistoryItem.fromJson(e)).toList() ?? [];

    return DashboardTabDataModel(
      appointmentBy: json['appointment_by']?.toString() ?? '',
      lastVisit: json['last_visit']?.toString() ?? '',
      firstVisit: json['first_visit']?.toString() ?? '',
      visitNo: json['visit_no']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      significantHistory: json['significant_history']?.toString() ?? '',
      riskFactors: json['risk_factors']?.toString() ?? '',
      endOrgan: json['end_organ']?.toString() ?? '',
      todayBp: json['today_bp']?.toString() ?? '',
      baselineBp: json['baseline_bp']?.toString() ?? '',
      targetBp: json['target_bp']?.toString() ?? '',
      causions: json['causions']?.toString() ?? '',
      events: json['events']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      whoIshRisk: whoRiskList,
      whoMsg: whoMsgList,
      symptoms: symptomsList,
      weight: weightList,
      creatinine: creatinineList,
      cholesterol: cholesterolList,
      sugar: sugarList,
      hba1c: hba1cList,
      urineAlbumin: urineAlbuminList,
      admissionHistory: admissionHistoryList,
    );
  }
}

class DashboardData {
  final String value;
  final String created;

  DashboardData({
    required this.value,
    required this.created,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      value: json['value']?.toString() ?? json['holding_reason']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
    );
  }
}

class AdmissionHistoryItem {
  final String appointmentId;
  final String doctorName;
  final String admitDate;
  final String dischargeDate;
  final String status;

  AdmissionHistoryItem({
    required this.appointmentId,
    required this.doctorName,
    required this.admitDate,
    required this.dischargeDate,
    required this.status,
  });

  factory AdmissionHistoryItem.fromJson(Map<String, dynamic> json) {
    return AdmissionHistoryItem(
      appointmentId: json['appointment_id']?.toString() ?? json['appointmentId']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? json['doctorName']?.toString() ?? '',
      admitDate: json['admit_date']?.toString() ?? json['admitDate']?.toString() ?? '',
      dischargeDate: json['discharge_date']?.toString() ?? json['dischargeDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
