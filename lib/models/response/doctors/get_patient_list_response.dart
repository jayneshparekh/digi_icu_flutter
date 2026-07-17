class GetPatientListResponse {
  final String status;
  final String msg;
  final int count;
  final List<PatientData> data;

  GetPatientListResponse({
    required this.status,
    required this.msg,
    required this.count,
    required this.data,
  });

  factory GetPatientListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<PatientData> dataList = list != null
        ? list.map((i) => PatientData.fromJson(i)).toList()
        : [];
    return GetPatientListResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      data: dataList,
    );
  }
}

class PatientData {
  final String id;
  final String mhcId;
  final String mhcEmail;
  final String firstName;
  final String midName;
  final String lastName;
  final String birthDate;
  final String age;
  final String gender;
  final String mobileNo;
  final String aadharNo;
  final String emailId;
  final String profilePic;
  final String homeAddress;
  final String village;
  final String taluka;
  final String district;
  final String state;
  final String country;
  final String pinCode;
  final String preferLanguages;
  final String pastHistory;
  final String registrationFrom;

  PatientData({
    required this.id,
    required this.mhcId,
    required this.mhcEmail,
    required this.firstName,
    required this.midName,
    required this.lastName,
    required this.birthDate,
    required this.age,
    required this.gender,
    required this.mobileNo,
    required this.aadharNo,
    required this.emailId,
    required this.profilePic,
    required this.homeAddress,
    required this.village,
    required this.taluka,
    required this.district,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.preferLanguages,
    required this.pastHistory,
    required this.registrationFrom,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      mhcEmail: json['mhc_email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      birthDate: json['birth_date']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      aadharNo: json['aadhar_no']?.toString() ?? '',
      emailId: json['email_id']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      homeAddress: json['home_address']?.toString() ?? '',
      village: json['village']?.toString() ?? '',
      taluka: json['taluka']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pinCode: json['pin_code']?.toString() ?? '',
      preferLanguages: json['prefer_languages']?.toString() ?? '',
      pastHistory: json['past_history']?.toString() ?? '',
      registrationFrom: json['registration_from']?.toString() ?? '',
    );
  }
}

