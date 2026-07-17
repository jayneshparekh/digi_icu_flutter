import 'installment_details_res.dart';

class CheckHomeResponse {
  final String status;
  final String patientName;
  final String isAdmitted;
  final String instituteId;
  final String followDate;
  final String firstTimeAppointment;
  final String leaderId;
  final String age;
  final String height;
  final String weight;
  final String gender;
  final String covidIconShow;
  final PastHistoryModel? pastHistory;
  final String mhcId;
  final String paymentStatus;
  final String appointmentId;
  final String registeredAddress;
  final String latitude;
  final String longitude;
  final String registeredPinCode;
  final String medicalForm;
  final String ongoingAppointment;
  final OngoingAppointmentDetails? ongoingAppointmentDetails;
  final String ptMobileNo;
  final String screeningId;
  final String parentId;
  final String admitId;
  final String admitStatus;
  final String packageStop;
  final String serviceLocation;
  final String serviceLocationLat;
  final String serviceLocationLong;
  final String serviceLocationLastUpdated;
  final InstallmentDetailsRes? installmentDetails;

  CheckHomeResponse({
    required this.status,
    required this.patientName,
    required this.isAdmitted,
    required this.instituteId,
    required this.followDate,
    required this.firstTimeAppointment,
    required this.leaderId,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.covidIconShow,
    this.pastHistory,
    required this.mhcId,
    required this.paymentStatus,
    required this.appointmentId,
    required this.registeredAddress,
    required this.latitude,
    required this.longitude,
    required this.registeredPinCode,
    required this.medicalForm,
    required this.ongoingAppointment,
    this.ongoingAppointmentDetails,
    required this.ptMobileNo,
    required this.screeningId,
    required this.parentId,
    required this.admitId,
    required this.admitStatus,
    required this.packageStop,
    required this.serviceLocation,
    required this.serviceLocationLat,
    required this.serviceLocationLong,
    required this.serviceLocationLastUpdated,
    this.installmentDetails,
  });

  factory CheckHomeResponse.fromJson(Map<String, dynamic> json) {
    return CheckHomeResponse(
      status: json['status']?.toString() ?? '',
      patientName: json['patient_name']?.toString() ?? '',
      isAdmitted: json['is_admitted']?.toString() ?? '0',
      instituteId: json['institute_id']?.toString() ?? '',
      followDate: json['follow_date']?.toString() ?? '',
      firstTimeAppointment: json['first_time_appointment']?.toString() ?? '',
      leaderId: json['leader_id']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      covidIconShow: json['covid_icon_show']?.toString() ?? '0',
      pastHistory: json['past_history'] != null
          ? PastHistoryModel.fromJson(json['past_history'])
          : null,
      mhcId: json['mhc_id']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString() ?? '',
      registeredAddress: json['registered_address']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      registeredPinCode: json['registered_pin_code']?.toString() ?? '',
      medicalForm: json['medical_form']?.toString() ?? '',
      ongoingAppointment: json['ongoing_appointment']?.toString() ?? '',
      ongoingAppointmentDetails: json['ongoing_appointment_details'] != null
          ? OngoingAppointmentDetails.fromJson(json['ongoing_appointment_details'])
          : null,
      ptMobileNo: json['pt_mobile_no']?.toString() ?? '',
      screeningId: json['screening_id']?.toString() ?? '',
      parentId: json['parent_id']?.toString() ?? '',
      admitId: json['admit_id']?.toString() ?? '',
      admitStatus: json['admit_status']?.toString() ?? '',
      packageStop: json['package_stop']?.toString() ?? '0',
      serviceLocation: json['service_location']?.toString() ?? '',
      serviceLocationLat: json['service_location_lat']?.toString() ?? '',
      serviceLocationLong: json['service_location_long']?.toString() ?? '',
      serviceLocationLastUpdated: json['service_location_last_updated']?.toString() ?? '',
      installmentDetails: json['installment_details'] != null
          ? InstallmentDetailsRes.fromJson(json['installment_details'])
          : null,
    );
  }
}

class OngoingAppointmentDetails {
  final String ongoingAppointmentId;
  final String doctorId;
  final String doctorName;
  final String holdReason;

  OngoingAppointmentDetails({
    required this.ongoingAppointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.holdReason,
  });

  factory OngoingAppointmentDetails.fromJson(Map<String, dynamic> json) {
    return OngoingAppointmentDetails(
      ongoingAppointmentId: json['ongoing_appointment_id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? '',
      holdReason: json['hold_reason']?.toString() ?? '',
    );
  }
}

class PastHistoryModel {
  final String hypertension;
  final String diabetes;
  final String thyroid;
  final String heartAttack;
  final String stroke;
  final String cholesterol;
  final String kidneyFailure;
  final String angioplasty;
  final String bypassSurgery;
  final String asthma;
  final String bpApparatus;
  final String haveGlucometer;

  PastHistoryModel({
    required this.hypertension,
    required this.diabetes,
    required this.thyroid,
    required this.heartAttack,
    required this.stroke,
    required this.cholesterol,
    required this.kidneyFailure,
    required this.angioplasty,
    required this.bypassSurgery,
    required this.asthma,
    required this.bpApparatus,
    required this.haveGlucometer,
  });

  factory PastHistoryModel.fromJson(Map<String, dynamic> json) {
    return PastHistoryModel(
      hypertension: json['hypertension']?.toString() ?? '',
      diabetes: json['diabetes']?.toString() ?? '',
      thyroid: json['thyroid']?.toString() ?? '',
      heartAttack: json['heart_attack']?.toString() ?? '',
      stroke: json['stroke']?.toString() ?? '',
      cholesterol: json['cholesterol']?.toString() ?? '',
      kidneyFailure: json['kidney_failure']?.toString() ?? '',
      angioplasty: json['angioplasty']?.toString() ?? '',
      bypassSurgery: json['bypass_surgery']?.toString() ?? '',
      asthma: json['asthma']?.toString() ?? '',
      bpApparatus: json['bp_apparatus']?.toString() ?? '',
      haveGlucometer: json['have_glucometer']?.toString() ?? '',
    );
  }
}

