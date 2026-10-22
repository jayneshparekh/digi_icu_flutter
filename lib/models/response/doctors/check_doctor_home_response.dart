class CheckDoctorHomeResponse {
  final String status;
  final String msg;
  final DoctorHomeData? data;

  CheckDoctorHomeResponse({required this.status, required this.msg, this.data});

  factory CheckDoctorHomeResponse.fromJson(Map<String, dynamic> json) {
    // Some API responses wrap fields in a 'data' object, while others (like MHC Android Retrofit)
    // return fields directly at the root of the JSON payload.
    final Map<String, dynamic> dataMap = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return CheckDoctorHomeResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: DoctorHomeData.fromJson(dataMap),
    );
  }
}

class DoctorHomeData {
  final String ecgPackagePayment;
  final String instituteDoctor;
  final String clinicAddress;
  final String clinicPincode;
  final String clinicLatitude;
  final String clinicLongitude;
  final String accountStatus;
  final String instituteId;

  DoctorHomeData({
    required this.ecgPackagePayment,
    required this.instituteDoctor,
    required this.clinicAddress,
    required this.clinicPincode,
    required this.clinicLatitude,
    required this.clinicLongitude,
    required this.accountStatus,
    required this.instituteId,
  });

  factory DoctorHomeData.fromJson(Map<String, dynamic> json) {
    return DoctorHomeData(
      ecgPackagePayment: (json['ecg_package_payment'] ?? json['ecgPackagePayment'])?.toString() ?? '',
      instituteDoctor: (json['institute_doctor'] ?? json['instituteDoctor'])?.toString() ?? '',
      clinicAddress: (json['clinic_address'] ?? json['clinicAddress'])?.toString() ?? '',
      clinicPincode: (json['clinic_pincode'] ?? json['clinicPincode'])?.toString() ?? '',
      clinicLatitude: (json['clinic_latitude'] ?? json['clinicLatitude'])?.toString() ?? '',
      clinicLongitude: (json['clinic_longitude'] ?? json['clinicLongitude'])?.toString() ?? '',
      accountStatus: (json['account_status'] ?? json['accountStatus'])?.toString() ?? '',
      instituteId: (json['institute_id'] ?? json['instituteId'] ?? json['institute'])?.toString() ?? '',
    );
  }
}
