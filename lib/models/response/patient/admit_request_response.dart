class AdmitRequestResponse {
  final String status;
  final int count;
  final List<AdmitRequestPatientItem> data;
  final bool? hasNew;

  const AdmitRequestResponse({
    required this.status,
    required this.count,
    required this.data,
    this.hasNew,
  });

  factory AdmitRequestResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<AdmitRequestPatientItem> items = [];
    if (rawList is List) {
      items = rawList
          .map((item) => AdmitRequestPatientItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return AdmitRequestResponse(
      status: json['status']?.toString() ?? '',
      count: json['count'] is int ? json['count'] as int : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      data: items,
      hasNew: json['has_new'] is bool ? json['has_new'] as bool : (json['has_new']?.toString() == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'data': data.map((x) => x.toJson()).toList(),
      'has_new': hasNew,
    };
  }
}

class AdmitRequestPatientItem {
  final String? requestId;
  final String? patientId;
  final String? patientName;
  final String? mhcId;
  final String? mobileNo;
  final String? age;
  final String? gender;
  final String? instituteId;
  final String? instituteName;
  final String? doctorId;
  final String? doctorName;
  final String? doctorMobileNo;
  final String? requestStatus;
  final String? lastAppointmentId;
  final String? currentPlace;
  final String? currentName;
  final String? currentBedNo;

  const AdmitRequestPatientItem({
    this.requestId,
    this.patientId,
    this.patientName,
    this.mhcId,
    this.mobileNo,
    this.age,
    this.gender,
    this.instituteId,
    this.instituteName,
    this.doctorId,
    this.doctorName,
    this.doctorMobileNo,
    this.requestStatus,
    this.lastAppointmentId,
    this.currentPlace,
    this.currentName,
    this.currentBedNo,
  });

  factory AdmitRequestPatientItem.fromJson(Map<String, dynamic> json) {
    return AdmitRequestPatientItem(
      requestId: json['request_id']?.toString(),
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      mhcId: json['mhc_id']?.toString(),
      mobileNo: json['mobile_no']?.toString(),
      age: json['age']?.toString(),
      gender: json['gender']?.toString(),
      instituteId: json['institute_id']?.toString(),
      instituteName: json['institute_name']?.toString(),
      doctorId: json['doctor_id']?.toString(),
      doctorName: json['doctor_name']?.toString(),
      doctorMobileNo: json['doctor_mobile_no']?.toString(),
      requestStatus: json['request_status']?.toString(),
      lastAppointmentId: json['last_appointment_id']?.toString(),
      currentPlace: json['current_place']?.toString(),
      currentName: json['current_name']?.toString(),
      currentBedNo: json['current_bed_no']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'patient_id': patientId,
      'patient_name': patientName,
      'mhc_id': mhcId,
      'mobile_no': mobileNo,
      'age': age,
      'gender': gender,
      'institute_id': instituteId,
      'institute_name': instituteName,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_mobile_no': doctorMobileNo,
      'request_status': requestStatus,
      'last_appointment_id': lastAppointmentId,
      'current_place': currentPlace,
      'current_name': currentName,
      'current_bed_no': currentBedNo,
    };
  }
}
