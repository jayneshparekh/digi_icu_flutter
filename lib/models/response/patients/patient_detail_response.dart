class PatientDetailResponse {
  final String status;
  final String msg;
  final PatientDetailData? data;

  PatientDetailResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory PatientDetailResponse.fromJson(Map<String, dynamic> json) {
    return PatientDetailResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? PatientDetailData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.toJson(),
    };
  }
}

class PatientDetailData {
  final String id;
  final String firstName;
  final String midName;
  final String lastName;
  final String mhcId;
  final String gender;
  final String age;
  final String mobileNo;
  final String leaderName;
  final String leaderMobile;
  final String note;
  final String appointmentStatus;
  final String isRefer;
  final String place;
  final String rating;
  final String? admitStatus;

  PatientDetailData({
    required this.id,
    required this.firstName,
    required this.midName,
    required this.lastName,
    required this.mhcId,
    required this.gender,
    required this.age,
    required this.mobileNo,
    required this.leaderName,
    required this.leaderMobile,
    required this.note,
    required this.appointmentStatus,
    required this.isRefer,
    required this.place,
    required this.rating,
    this.admitStatus,
  });

  factory PatientDetailData.fromJson(Map<String, dynamic> json) {
    return PatientDetailData(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      leaderName: json['leader_name']?.toString() ?? '',
      leaderMobile: json['leader_mobile']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      appointmentStatus: json['appointment_status']?.toString() ?? '',
      isRefer: json['is_refer']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '',
      admitStatus: json['admit_status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'mid_name': midName,
      'last_name': lastName,
      'mhc_id': mhcId,
      'gender': gender,
      'age': age,
      'mobile_no': mobileNo,
      'leader_name': leaderName,
      'leader_mobile': leaderMobile,
      'note': note,
      'appointment_status': appointmentStatus,
      'is_refer': isRefer,
      'place': place,
      'rating': rating,
      'admit_status': admitStatus,
    };
  }
}
