class AdmitPatientRequestModel {
  final String? instituteId;
  final String? patientId;
  final String? appointmentId;
  final String? doctorId;
  final String? referralDoctor;
  final String admitDate;
  final String admitTime;
  final String dischargeDate;
  final String dischargeTime;
  final String approxCost;
  final String approxDays;
  final String admissionAmount;
  final String admissionChargesStatus;
  final String admissionChargesMode;
  final String admissionTransactionId;
  final String advanceAmount;
  final String advancePaymentStatus;
  final String advancePaymentMode;
  final String advanceTransactionId;
  final String place;
  final String admitBy;
  final String admitById;
  final String instituteLogo;
  final String instituteName;
  final String instituteAddress;
  final String instituteMobile;

  const AdmitPatientRequestModel({
    this.instituteId,
    this.patientId,
    this.appointmentId,
    this.doctorId,
    this.referralDoctor,
    required this.admitDate,
    required this.admitTime,
    required this.dischargeDate,
    required this.dischargeTime,
    required this.approxCost,
    required this.approxDays,
    required this.admissionAmount,
    required this.admissionChargesStatus,
    required this.admissionChargesMode,
    required this.admissionTransactionId,
    required this.advanceAmount,
    required this.advancePaymentStatus,
    required this.advancePaymentMode,
    required this.advanceTransactionId,
    required this.place,
    required this.admitBy,
    required this.admitById,
    this.instituteLogo = '',
    this.instituteName = '',
    this.instituteAddress = '',
    this.instituteMobile = '',
  });

  Map<String, dynamic> toJson() => {
    'institute_id': instituteId,
    'patient_id': patientId,
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'referral_doctor': referralDoctor,
    'admit_date': admitDate,
    'admit_time': admitTime,
    'discharge_date': dischargeDate,
    'discharge_time': dischargeTime,
    'approx_cost': approxCost,
    'approx_days': approxDays,
    'admission_amount': admissionAmount,
    'admission_amount_payment_status': admissionChargesStatus,
    'admission_amount_payment_mode': admissionChargesMode,
    'admission_transaction_id': admissionTransactionId,
    'advance_amount': advanceAmount,
    'advance_amount_payment_status': advancePaymentStatus,
    'advance_amount_payment_mode': advancePaymentMode,
    'advance_transaction_id': advanceTransactionId,
    'place': place,
    'admit_by': admitBy,
    'admit_by_id': admitById,
    'institute_logo': instituteLogo,
    'institute_name': instituteName,
    'institute_address': instituteAddress,
    'institute_mobile': instituteMobile,
  };
}
