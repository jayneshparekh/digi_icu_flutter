class CheckDoctorHomeResponse {
  final String status;
  final String msg;
  final DoctorHomeData? data;

  CheckDoctorHomeResponse({required this.status, required this.msg, this.data});

  factory CheckDoctorHomeResponse.fromJson(Map<String, dynamic> json) {
    return CheckDoctorHomeResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? DoctorHomeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
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
      ecgPackagePayment: json['ecg_package_payment']?.toString() ?? '',
      instituteDoctor: json['institute_doctor']?.toString() ?? '',
      clinicAddress: json['clinic_address']?.toString() ?? '',
      clinicPincode: json['clinic_pincode']?.toString() ?? '',
      clinicLatitude: json['clinic_latitude']?.toString() ?? '',
      clinicLongitude: json['clinic_longitude']?.toString() ?? '',
      accountStatus: json['account_status']?.toString() ?? '',
      instituteId: json['institute_id']?.toString() ?? '',
    );
  }
}

