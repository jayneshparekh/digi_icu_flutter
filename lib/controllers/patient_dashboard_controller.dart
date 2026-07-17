import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/response/patients/check_home_response.dart';
import '../models/response/patients/installment_details_res.dart';
import '../models/response/patients/slider_response.dart';
import '../services/api/api_client.dart';
import '../../views/widgets/installment_payment_dialog.dart';

class PatientDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Navigation arguments
  String patientId = '';
  String userName = '';
  String userAge = '';
  String userGender = '';
  String type = '';
  String leaderId = '';
  String isFrom = '';
  String doctorId = '';
  String isAdmitted = '0';
  bool isFromDoctorHomeService = false;
  String homeServiceDoctorId = '';
  String doctorHsReqId = '';
  String problem = '';

  final RxString doctorName = ''.obs;
  final Rxn<InstallmentDetailsRes> rxInstallmentDetails = Rxn<InstallmentDetailsRes>();

  // Sliders and marquee content loaded from API
  final RxList<SliderItem> homeSliders = <SliderItem>[].obs;
  final RxList<SliderItem> awarenessSliders = <SliderItem>[].obs;
  final RxString marqueeText = ''.obs;
  final RxBool isSlidersLoading = false.obs;

  // Check home reactive states
  final RxString rxUserName = ''.obs;
  final RxString rxIsAdmitted = '0'.obs;
  final RxString rxInstituteId = ''.obs;
  final RxString rxFollowDate = ''.obs;
  final RxString rxCovidIconShow = '0'.obs;
  final RxString rxMhcId = ''.obs;
  final RxString rxPaymentStatus = ''.obs;
  final RxString rxAppointmentId = ''.obs;
  final RxString rxRegisteredAddress = ''.obs;
  final RxString rxLatitude = ''.obs;
  final RxString rxLongitude = ''.obs;
  final RxString rxRegisteredPinCode = ''.obs;
  final RxString rxMedicalForm = ''.obs;
  final RxString rxOngoingAppointment = ''.obs;
  final RxString rxOngoingAppointmentId = ''.obs;
  final RxString rxOngoingDoctorId = ''.obs;
  final RxString rxOngoingDoctorName = ''.obs;
  final RxString rxHoldReason = ''.obs;
  final RxString rxPtMobileNo = ''.obs;
  final RxString rxScreeningId = ''.obs;
  final RxString rxParentId = ''.obs;
  final RxString rxAdmitId = ''.obs;
  final RxString rxAdmitStatus = ''.obs;
  final RxString rxPackageStop = '0'.obs;
  final RxString rxServiceLocation = ''.obs;
  final RxString rxServiceLocationLat = ''.obs;
  final RxString rxServiceLocationLong = ''.obs;
  final RxString rxServiceLocationLastUpdated = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      patientId = args['patientId']?.toString() ?? '';
      userName = args['userName']?.toString() ?? '';
      userAge = args['userAge']?.toString() ?? '';
      userGender = args['userGender']?.toString() ?? '';
      type = args['type']?.toString() ?? '';
      leaderId = args['leaderId']?.toString() ?? '';
      isFrom = args['isFrom']?.toString() ?? '';
      doctorId = args['doctorId']?.toString() ?? '';
      isFromDoctorHomeService = args['isFromDoctorHomeService'] as bool? ?? false;
      homeServiceDoctorId = args['doctor_id']?.toString() ?? '';
      doctorHsReqId = args['doctor_hs_req_id']?.toString() ?? '';
      problem = args['problem']?.toString() ?? '';
    }
    rxUserName.value = userName; // Fallback to route arg name
    _loadDoctorName();
    fetchSliders();
    checkHome();
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';
  }

  Future<void> fetchSliders() async {
    isSlidersLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getSliders,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final sliderRes = SliderResponse.fromJson(response.data);
        if (sliderRes.status == 'success') {
          homeSliders.assignAll(sliderRes.homeSlider);
          awarenessSliders.assignAll(sliderRes.awarenessSlider);
          if (sliderRes.textSlider.isNotEmpty) {
            marqueeText.value = sliderRes.textSlider[0].textMsg;
          }
        }
      }
    } catch (e) {
      // Fail silently, fallbacks are loaded
    } finally {
      isSlidersLoading.value = false;
    }
  }

  Future<void> checkHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.checkHome,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final homeRes = CheckHomeResponse.fromJson(response.data);
        if (homeRes.status == 'success') {
          rxUserName.value = homeRes.patientName;
          rxIsAdmitted.value = homeRes.isAdmitted;
          rxInstituteId.value = homeRes.instituteId;
          rxFollowDate.value = homeRes.followDate;
          rxCovidIconShow.value = homeRes.covidIconShow;
          rxMhcId.value = homeRes.mhcId;
          rxPaymentStatus.value = homeRes.paymentStatus;
          rxAppointmentId.value = homeRes.appointmentId;
          rxRegisteredAddress.value = homeRes.registeredAddress;
          rxLatitude.value = homeRes.latitude;
          rxLongitude.value = homeRes.longitude;
          rxRegisteredPinCode.value = homeRes.registeredPinCode;
          rxMedicalForm.value = homeRes.medicalForm;
          rxOngoingAppointment.value = homeRes.ongoingAppointment;
          rxOngoingAppointmentId.value = homeRes.ongoingAppointmentDetails?.ongoingAppointmentId ?? '';
          rxOngoingDoctorId.value = homeRes.ongoingAppointmentDetails?.doctorId ?? '';
          rxOngoingDoctorName.value = homeRes.ongoingAppointmentDetails?.doctorName ?? '';
          rxHoldReason.value = homeRes.ongoingAppointmentDetails?.holdReason ?? '';
          rxPtMobileNo.value = homeRes.ptMobileNo;
          rxScreeningId.value = homeRes.screeningId;
          rxParentId.value = homeRes.parentId;
          rxAdmitId.value = homeRes.admitId;
          rxAdmitStatus.value = homeRes.admitStatus;
          rxPackageStop.value = homeRes.packageStop;
          rxServiceLocation.value = homeRes.serviceLocation;
          rxServiceLocationLat.value = homeRes.serviceLocationLat;
          rxServiceLocationLong.value = homeRes.serviceLocationLong;
          rxServiceLocationLastUpdated.value = homeRes.serviceLocationLastUpdated;
          rxInstallmentDetails.value = homeRes.installmentDetails;

          if (homeRes.firstTimeAppointment.isNotEmpty) {
            await prefs.setString(AppConstants.prefFirstTimeAppointment, homeRes.firstTimeAppointment);
          }
          if (homeRes.leaderId.isNotEmpty) {
            await prefs.setString(AppConstants.prefLeaderId, homeRes.leaderId);
          }
          if (homeRes.age.isNotEmpty) {
            await prefs.setString(AppConstants.prefUserAge, homeRes.age);
          }
          if (homeRes.height.isNotEmpty) {
            await prefs.setString(AppConstants.prefUserHeight, homeRes.height);
          }
          if (homeRes.weight.isNotEmpty) {
            await prefs.setString(AppConstants.prefUserWeight, homeRes.weight);
          }
          if (homeRes.gender.isNotEmpty) {
            await prefs.setString(AppConstants.prefUserGender, homeRes.gender);
          }

          // Firebase messaging subscribe topic placeholder
          /*
          if (homeRes.pastHistory != null) {
            final ph = homeRes.pastHistory!;
            if (ph.hypertension == "Yes") FirebaseMessaging.instance.subscribeToTopic("hypertension");
            if (ph.diabetes == "Yes") FirebaseMessaging.instance.subscribeToTopic("diabetes");
            if (ph.thyroid == "Yes") FirebaseMessaging.instance.subscribeToTopic("thyroid");
            if (ph.heartAttack == "Yes") FirebaseMessaging.instance.subscribeToTopic("heart_attack");
            if (ph.stroke == "Yes") FirebaseMessaging.instance.subscribeToTopic("stroke");
            if (ph.cholesterol == "Yes") FirebaseMessaging.instance.subscribeToTopic("cholesterol");
            if (ph.kidneyFailure == "Yes") FirebaseMessaging.instance.subscribeToTopic("kidney_failure");
            if (ph.angioplasty == "Yes") FirebaseMessaging.instance.subscribeToTopic("angioplasty");
            if (ph.bypassSurgery == "Yes") FirebaseMessaging.instance.subscribeToTopic("bypass_surgery");
            if (ph.asthma == "Yes") FirebaseMessaging.instance.subscribeToTopic("asthma");
            if (ph.bpApparatus == "Yes") FirebaseMessaging.instance.subscribeToTopic("bp_appartus");
            if (ph.haveGlucometer == "Yes") FirebaseMessaging.instance.subscribeToTopic("glucometer");
          }
          */
        }
      }
    } catch (e) {
      // Fail silently
    }
  }

  String getFormattedFollowDate() {
    final raw = rxFollowDate.value;
    if (raw.isEmpty) return '';
    try {
      final parts = raw.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}'; // dd-MM-yyyy
      }
    } catch (e) {
      // Fail silently
    }
    return raw;
  }

  void handleDoctorAppointmentTap() {
    if (rxPackageStop.value == "1") {
      final details = rxInstallmentDetails.value;
      if (details != null) {
        Get.dialog(
          InstallmentPaymentDialog(
            data: details,
            onPayNowClick: onPayNowClick,
          ),
          barrierDismissible: false,
        );
      }
    } else {
      Get.toNamed('/appointment', arguments: {
        'patientId': patientId,
        'userAge': userAge,
        'userGender': userGender,
        'patientName': userName,
        'isFromDoctorHomeService': isFromDoctorHomeService,
        'doctor_id': homeServiceDoctorId,
        'doctor_hs_req_id': doctorHsReqId,
        'problem': problem,
        'type': type,
        'leaderId': leaderId,
      });
    }
  }

  void onPayNowClick(
    String payableAmount,
    String packageId,
    String packageType,
    String packageName,
    String paymentReferenceId,
  ) {
    // TODO: Implement Razorpay Integration Order creation
    // generateOrder(payableAmount, packageId, packageType, packageName, paymentReferenceId);
  }

  // void generateOrder(
  //   String payableAmount,
  //   String packageId,
  //   String packageType,
  //   String packageName,
  //   String paymentReferenceId,
  // ) {
  //   // Order generation and signature verification logic
  // }
}


