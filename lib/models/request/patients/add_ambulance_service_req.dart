class AddAmbulanceServiceReq {
  final String patientId;
  final String forWhom;
  final String name;
  final String mobileNo;
  final String addressType;
  final String location;
  final String latitude;
  final String longitude;
  final String pinCode;
  final String problem;
  final String visitType;

  AddAmbulanceServiceReq({
    required this.patientId,
    required this.forWhom,
    required this.name,
    required this.mobileNo,
    required this.addressType,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.pinCode,
    required this.problem,
    required this.visitType,
  });

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'for_whom': forWhom,
      'name': name,
      'mobile_no': mobileNo,
      'address_type': addressType,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'pin_code': pinCode,
      'problem': problem,
      'visit_type': visitType,
    };
  }

  factory AddAmbulanceServiceReq.fromJson(Map<String, dynamic> json) {
    return AddAmbulanceServiceReq(
      patientId: json['patient_id']?.toString() ?? '',
      forWhom: json['for_whom']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      addressType: json['address_type']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      pinCode: json['pin_code']?.toString() ?? '',
      problem: json['problem']?.toString() ?? '',
      visitType: json['visit_type']?.toString() ?? '',
    );
  }
}
