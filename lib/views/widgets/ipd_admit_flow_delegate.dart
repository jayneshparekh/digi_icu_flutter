import 'dart:typed_data';
import 'package:get/get.dart';

/// Interface abstracting the state and actions required by [PreAdmitDialog] and [IpdAdmitDialog].
///
/// Implemented by controllers that provide patient admission workflows
/// (e.g., [ServingPatientController] and [AdmitPatientRequestController]).
abstract class IPDAdmitFlowDelegate {
  // Patient Context
  String get patientId;
  String get bookingId;
  String get fullName;
  String get age;
  String get gender;

  // Institute Selection State
  RxString get selectedInstituteId;
  RxString get selectedInstituteName;
  RxString get selectedInstituteLogo;
  RxString get selectedInstituteAddress;
  RxString get selectedInstituteMobile;
  String get instituteId;

  // Day Care State & Actions
  RxBool get isDayCare;
  RxBool get isDayCareAvailable;
  RxString get dayCareOption;
  Future<void> checkDayCareAvailability(String instId);

  // Doctor & Care State
  RxString get userType;
  String get doctorId;
  RxString get loggedInDoctorName;
  RxString get selectedConsultantDoctorId;
  RxString get selectedConsultantDoctorName;
  RxList<dynamic> get admitDoctors;
  RxString get selectedReferralDoctorId;
  RxList<dynamic> get referralDoctors;
  RxString get referralDoctor;
  RxBool get isAdmitPrescription;

  // Place, Ward & Bed Selection
  RxString get selectedAdmitPlace;
  RxString get selectedAdmitWard;
  RxString get selectedAdmitBed;
  RxList<dynamic> get admitWardOptions;
  RxList<dynamic> get admitBedOptions;

  // Financial & Schedule Fields
  RxString get approxCost;
  RxString get approxDays;
  RxString get admissionAmount;
  RxString get admissionDate;
  RxString get admissionTime;
  RxString get dischargeDate;
  RxString get dischargeTime;
  RxString get advanceAmount;
  RxString get admissionPaymentStatus;
  RxString get admissionPaymentMode;
  RxString get advancePaymentStatus;
  RxString get advancePaymentMode;
  RxString get admissionTransactionId;
  RxString get advanceTransactionId;
  RxString get admissionNotes;

  // Drawing Canvas & Note Image
  Rxn<Uint8List> get canvasDrawingBytes;
  RxString get noteImagePath;

  // Action Methods
  Future<void> showImagePickerForNotes();
  void validateAndConfirmAdmit();
}
