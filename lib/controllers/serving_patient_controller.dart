import 'package:get/get.dart';

class ServingPatientController extends GetxController {
  // Navigation / screen arguments
  late final String patientId;
  late final String fullName;
  late final String age;
  late final String gender;
  late final String mhcId;
  late final String bookingId;
  late final String mobileNo;
  late final String note;
  late final String selectTab;
  late final String status;
  late final String leaderName;
  late final String leaderMobNo;
  late final String isRefer;
  late final String doctorHomeServiceId;
  late final String doctorId;
  late final String isAdmitted;
  late final String videoUrl;
  late final String clinicalFormStatus;
  late final String medicalFormStatus;
  late final String instituteId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    patientId = args['patientId']?.toString() ?? '';
    fullName = args['fullName']?.toString() ?? '';
    age = args['age']?.toString() ?? '';
    gender = args['gender']?.toString() ?? '';
    mhcId = args['mhcId']?.toString() ?? '';
    bookingId = args['bookingId']?.toString() ?? '';
    mobileNo = args['mobileNo']?.toString() ?? '';
    note = args['note']?.toString() ?? '';
    selectTab = args['selectTab']?.toString() ?? '';
    status = args['status']?.toString() ?? '';
    leaderName = args['leaderName']?.toString() ?? '';
    leaderMobNo = args['leaderMobNo']?.toString() ?? '';
    isRefer = args['isRefer']?.toString() ?? '';
    doctorHomeServiceId = args['doctor_home_service_id']?.toString() ?? '';
    doctorId = args['doctorId']?.toString() ?? '';
    isAdmitted = args['isAdmitted']?.toString() ?? '';
    videoUrl = args['videoUrl']?.toString() ?? '';
    clinicalFormStatus = args['clinical_form_status']?.toString() ?? '';
    medicalFormStatus = args['medical_form_status']?.toString() ?? '';
    instituteId = args['instituteId']?.toString() ?? '';
  }
}
