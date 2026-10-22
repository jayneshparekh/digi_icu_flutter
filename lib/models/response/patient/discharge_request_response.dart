class DischargeRequestResponse {
  final String? status;
  final int? count;
  final List<DischargeRequestPatientItem>? data;
  final bool? hasNew;

  DischargeRequestResponse({
    this.status,
    this.count,
    this.data,
    this.hasNew,
  });

  factory DischargeRequestResponse.fromJson(Map<String, dynamic> json) {
    return DischargeRequestResponse(
      status: json['status']?.toString(),
      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? ''),
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((i) => DischargeRequestPatientItem.fromJson(i as Map<String, dynamic>))
              .toList()
          : [],
      hasNew: json['has_new'] == true ||
          json['has_new'] == 1 ||
          json['has_new'] == 'true' ||
          json['has_new'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
      'has_new': hasNew,
    };
  }
}

class DischargeRequestPatientItem {
  final String? admitId;
  final String? patientId;
  final String? appointmentId;
  final String? instituteId;
  final String? patientName;
  final String? mhcId;
  final String? ipdId;
  final String? mobileNo;
  final String? age;
  final String? gender;
  final String? status;
  final String? instituteName;
  final String? profilePic;
  final String? currentPlaceDetails;

  DischargeRequestPatientItem({
    this.admitId,
    this.patientId,
    this.appointmentId,
    this.instituteId,
    this.patientName,
    this.mhcId,
    this.ipdId,
    this.mobileNo,
    this.age,
    this.gender,
    this.status,
    this.instituteName,
    this.profilePic,
    this.currentPlaceDetails,
  });

  factory DischargeRequestPatientItem.fromJson(Map<String, dynamic> json) {
    return DischargeRequestPatientItem(
      admitId: json['admit_id']?.toString(),
      patientId: json['patient_id']?.toString(),
      appointmentId: json['appointment_id']?.toString(),
      instituteId: json['institute_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      mhcId: json['mhc_id']?.toString(),
      ipdId: json['ipd_id']?.toString(),
      mobileNo: json['mobile_no']?.toString(),
      age: json['age']?.toString(),
      gender: json['gender']?.toString(),
      status: json['status']?.toString(),
      instituteName: json['institute_name']?.toString(),
      profilePic: json['profile_pic']?.toString(),
      currentPlaceDetails: json['current_place_details']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admit_id': admitId,
      'patient_id': patientId,
      'appointment_id': appointmentId,
      'institute_id': instituteId,
      'patient_name': patientName,
      'mhc_id': mhcId,
      'ipd_id': ipdId,
      'mobile_no': mobileNo,
      'age': age,
      'gender': gender,
      'status': status,
      'institute_name': instituteName,
      'profile_pic': profilePic,
      'current_place_details': currentPlaceDetails,
    };
  }
}
