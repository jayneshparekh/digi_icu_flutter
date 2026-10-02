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
  final Rxn<InstallmentDetailsRes> rxInstallmentDetails =
      Rxn<InstallmentDetailsRes>();

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
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final args = Get.arguments as Map<String, dynamic>?;

    final passedPatientId =
        (args?['patientId'] ?? args?['patient_id'])?.toString();
    if (passedPatientId != null && passedPatientId.isNotEmpty) {
      patientId = passedPatientId;
      userName =
          (args?['userName'] ?? args?['patientName'])?.toString() ?? '';
      userAge =
          (args?['userAge'] ?? args?['patientAge'])?.toString() ?? '';
      userGender =
          (args?['userGender'] ?? args?['patientGender'])?.toString() ?? '';
      type = args?['type']?.toString() ?? '';
      leaderId = args?['leaderId']?.toString() ?? '';
      isFrom = args?['isFrom']?.toString() ?? '';
      doctorId = args?['doctorId']?.toString() ?? '';
      isFromDoctorHomeService =
          args?['isFromDoctorHomeService'] as bool? ?? false;
      homeServiceDoctorId = args?['doctor_id']?.toString() ?? '';
      doctorHsReqId = args?['doctor_hs_req_id']?.toString() ?? '';
      problem = args?['problem']?.toString() ?? '';

      // Persist active patient session
      await prefs.setString(AppConstants.prefSelectedPatientId, patientId);
      await prefs.setString(AppConstants.prefSelectedPatientName, userName);
      await prefs.setString(AppConstants.prefSelectedPatientAge, userAge);
      await prefs.setString(
        AppConstants.prefSelectedPatientGender,
        userGender,
      );
      await prefs.setString(AppConstants.prefSelectedPatientType, type);
      await prefs.setString(AppConstants.prefSelectedLeaderId, leaderId);
      await prefs.setString(AppConstants.prefSelectedDoctorId, doctorId);
    } else {
      // Restore active patient session from SharedPreferences
      final loginType = prefs.getString(AppConstants.prefLoginType) ?? '';
      patientId = prefs.getString(AppConstants.prefSelectedPatientId) ?? '';
      if (patientId.isEmpty && loginType.toLowerCase() == 'patient') {
        patientId = prefs.getString(AppConstants.prefUserId) ?? '';
      }
      userName =
          prefs.getString(AppConstants.prefSelectedPatientName) ??
          prefs.getString(AppConstants.prefUserName) ??
          '';
      userAge =
          prefs.getString(AppConstants.prefSelectedPatientAge) ??
          prefs.getString(AppConstants.prefUserAge) ??
          '';
      userGender =
          prefs.getString(AppConstants.prefSelectedPatientGender) ??
          prefs.getString(AppConstants.prefUserGender) ??
          '';
      type = prefs.getString(AppConstants.prefSelectedPatientType) ?? '';
      leaderId = prefs.getString(AppConstants.prefSelectedLeaderId) ?? '';
      doctorId = prefs.getString(AppConstants.prefSelectedDoctorId) ?? '';
    }

    rxUserName.value = userName;
    doctorName.value = prefs.getString(AppConstants.prefUserName) ?? 'Doctor';

    fetchSliders();
    checkHome();
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
    if (patientId.isEmpty) return;
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
          if (homeRes.patientName.isNotEmpty) {
            rxUserName.value = homeRes.patientName;
            userName = homeRes.patientName;
            await prefs.setString(
              AppConstants.prefSelectedPatientName,
              homeRes.patientName,
            );
          }
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
          rxOngoingAppointmentId.value =
              homeRes.ongoingAppointmentDetails?.ongoingAppointmentId ?? '';
          rxOngoingDoctorId.value =
              homeRes.ongoingAppointmentDetails?.doctorId ?? '';
          rxOngoingDoctorName.value =
              homeRes.ongoingAppointmentDetails?.doctorName ?? '';
          rxHoldReason.value =
              homeRes.ongoingAppointmentDetails?.holdReason ?? '';
          rxPtMobileNo.value = homeRes.ptMobileNo;
          rxScreeningId.value = homeRes.screeningId;
          rxParentId.value = homeRes.parentId;
          rxAdmitId.value = homeRes.admitId;
          rxAdmitStatus.value = homeRes.admitStatus;
          rxPackageStop.value = homeRes.packageStop;
          rxServiceLocation.value = homeRes.serviceLocation;
          rxServiceLocationLat.value = homeRes.serviceLocationLat;
          rxServiceLocationLong.value = homeRes.serviceLocationLong;
          rxServiceLocationLastUpdated.value =
              homeRes.serviceLocationLastUpdated;
          rxInstallmentDetails.value = homeRes.installmentDetails;
          rxPastHistory.value = homeRes.pastHistory;

          if (homeRes.firstTimeAppointment.isNotEmpty) {
            await prefs.setString(
              AppConstants.prefFirstTimeAppointment,
              homeRes.firstTimeAppointment,
            );
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

  final Rxn<PastHistoryModel> rxPastHistory = Rxn<PastHistoryModel>();

  void handleDoctorAppointmentTap() {
    if (rxPackageStop.value == "1") {
      final details = rxInstallmentDetails.value;
      if (details != null) {
        Get.dialog(
          InstallmentPaymentDialog(data: details, onPayNowClick: onPayNowClick),
          barrierDismissible: false,
        );
      }
    } else {
      Get.toNamed(
        '/appointment',
        arguments: {
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
        },
      );
    }
  }

  void handleChestPainTap() {
    final ph = rxPastHistory.value;
    Get.toNamed(
      '/check-chest-pain',
      arguments: {
        'patient_id': patientId,
        'patientName': rxUserName.value.isNotEmpty
            ? rxUserName.value
            : userName,
        'patientAge': userAge,
        'patientGender': userGender,
        'admitId': rxAdmitId.value,
        'pinCode': rxRegisteredPinCode.value,
        'regAddress': rxRegisteredAddress.value,
        'regLatitude': rxLatitude.value,
        'regLongitude': rxLongitude.value,
        'ptMobileNo': rxPtMobileNo.value,
        'hypertension': ph?.hypertension ?? '',
        'diabetes': ph?.diabetes ?? '',
        'heartAttack': ph?.heartAttack ?? '',
        'thyroid': ph?.thyroid ?? '',
        'stroke': ph?.stroke ?? '',
      },
    );
  }

  void handleBack() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed('/doctor-dashboard');
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
