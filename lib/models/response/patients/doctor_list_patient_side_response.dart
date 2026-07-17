class DoctorListPatientSideResponse {
  final String status;
  final String medicalForm;
  final String msg;
  final List<DoctorDataModel> data;

  DoctorListPatientSideResponse({
    required this.status,
    required this.medicalForm,
    required this.msg,
    required this.data,
  });

  factory DoctorListPatientSideResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<DoctorDataModel> doctors = dataList != null
        ? dataList.map((i) => DoctorDataModel.fromJson(i)).toList()
        : [];

    return DoctorListPatientSideResponse(
      status: json['status']?.toString() ?? '',
      medicalForm: json['medical_form']?.toString() ?? '0',
      msg: json['msg']?.toString() ?? '',
      data: doctors,
    );
  }
}

class DoctorDataModel {
  final String id;
  final String firstName;
  final String midName;
  final String lastName;
  final String degrees;
  final String regNo;
  final String profilePic;
  final String availability;
  final String consultingCharges;
  final String holdReason;
  final String bookingStatus;
  final String clinicalFormStatus;
  final String status;
  final String appointmentId;
  final String defaultFormType;
  final String mhcEmail;
  final String place;

  DoctorDataModel({
    required this.id,
    required this.firstName,
    required this.midName,
    required this.lastName,
    required this.degrees,
    required this.regNo,
    required this.profilePic,
    required this.availability,
    required this.consultingCharges,
    required this.holdReason,
    required this.bookingStatus,
    required this.clinicalFormStatus,
    required this.status,
    required this.appointmentId,
    required this.defaultFormType,
    required this.mhcEmail,
    required this.place,
  });

  factory DoctorDataModel.fromJson(Map<String, dynamic> json) {
    return DoctorDataModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      degrees: json['degrees']?.toString() ?? '',
      regNo: json['reg_no']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      availability: json['availability']?.toString() ?? '',
      consultingCharges: json['consulting_charges']?.toString() ?? '',
      holdReason: json['hold_reason']?.toString() ?? '',
      bookingStatus: json['booking_status']?.toString() ?? '',
      clinicalFormStatus: json['clinical_form_status']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString() ?? '',
      defaultFormType: json['default_form_type']?.toString() ?? '',
      mhcEmail: json['mhc_email']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
    );
  }
}

