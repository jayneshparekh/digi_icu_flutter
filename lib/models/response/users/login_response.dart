class LoginResponse {
  final String status;
  final String authToken;
  final String msg;
  final LoginDataRes? data;
  final List<LoginDataRes> patientList;

  LoginResponse({
    required this.status,
    required this.authToken,
    required this.msg,
    this.data,
    this.patientList = const [],
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    var rawPatientList = json['patient_list'];
    List<LoginDataRes> patients = [];
    if (rawPatientList is List) {
      patients = rawPatientList
          .map((item) => LoginDataRes.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return LoginResponse(
      status: json['status']?.toString() ?? '',
      authToken: json['auth_token']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null ? LoginDataRes.fromJson(json['data']) : null,
      patientList: patients,
    );
  }
}

class LoginDataRes {
  final String id;
  final String userType;
  final String firstName;
  final String midName;
  final String surname;
  final String mhcId;
  final String gender;
  final String age;
  final String mobileNo;
  final String mhcEmail;
  final String screeningId;
  final String section2;
  final String section3;
  final String profilePic;
  final String instituteName;
  final String labName;
  final String medicalStoreName;

  LoginDataRes({
    required this.id,
    required this.userType,
    required this.firstName,
    this.midName = '',
    required this.surname,
    required this.mhcId,
    required this.gender,
    required this.age,
    required this.mobileNo,
    required this.mhcEmail,
    required this.screeningId,
    required this.section2,
    required this.section3,
    this.profilePic = '',
    this.instituteName = '',
    this.labName = '',
    this.medicalStoreName = '',
  });

  factory LoginDataRes.fromJson(Map<String, dynamic> json) {
    return LoginDataRes(
      id: json['id']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      surname: json['surname']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      mhcEmail: json['mhc_email']?.toString() ?? '',
      screeningId: json['screening_id']?.toString() ?? '',
      section2: json['section_2']?.toString() ?? '',
      section3: json['section_3']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      instituteName: json['institute_name']?.toString() ?? '',
      labName: json['lab_name']?.toString() ?? '',
      medicalStoreName: json['medical_store_name']?.toString() ?? '',
    );
  }
}
