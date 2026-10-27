import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/request/emergency/get_remain_credit_list_req.dart';
import '../models/request/emergency/get_user_package_detail_req.dart';
import '../models/request/emergency/update_user_package_track_req.dart';
import '../models/request/emergency/update_user_wallet_track_req.dart';
import '../models/response/emergency/get_remain_credit_res.dart';
import '../models/response/emergency/get_user_package_detail_res.dart';
import '../models/response/patients/appointment_slots_response.dart';
import '../models/response/patients/book_appointment_response.dart';
import '../models/response/patients/check_home_response.dart';
import '../models/response/patients/installment_details_res.dart';
import '../models/response/patients/slider_response.dart';
import '../models/response/payment/order_response.dart';
import '../services/api/api_client.dart';
import '../services/razorpay_service.dart';
import '../../views/widgets/installment_payment_dialog.dart';
import '../views/widgets/app_snackbars.dart';
import '../views/widgets/emergency_consultation_dialog.dart';
import '../views/screens/serving_patient_quick_form_view.dart';

class PatientDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final RazorpayService _razorpayService = RazorpayService();

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
  final RxString loggedInUserType = ''.obs;

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
    final prefLoginType = prefs.getString(AppConstants.prefLoginType) ?? '';
    loggedInUserType.value = prefLoginType;
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

  void handleAmbulanceTap() {
    Get.toNamed(
      '/ambulance-service-request',
      arguments: {
        'patientId': patientId,
        'patientName': rxUserName.value.isNotEmpty
            ? rxUserName.value
            : userName,
        'pinCode': rxRegisteredPinCode.value,
        'regAddress': rxRegisteredAddress.value,
        'regLatitude': rxLatitude.value,
        'regLongitude': rxLongitude.value,
        'ptMobileNo': rxPtMobileNo.value,
        'userType': type,
      },
    );
  }

  void handleReportTap(String reportCategory) {
    Get.toNamed(
      '/serving-patient',
      arguments: {
        'patientId': patientId,
        'fullName': rxUserName.value.isNotEmpty ? rxUserName.value : userName,
        'age': userAge,
        'gender': userGender,
        'mhcId': rxMhcId.value,
        'mobileNo': rxPtMobileNo.value,
        'isAdmitted': rxIsAdmitted.value,
        'instituteId': rxInstituteId.value,
        'fromPatient': true,
        'doctorId': doctorId,
        'userType': type.isNotEmpty ? type : 'Patient',
        'initialTab': 'Reports',
        'initialReportName': reportCategory,
      },
    );
  }

  void handleOtherReportsTap() {
    handleReportTap('');
  }

  void handleOpenServingPatientTab(String tabName) {
    Get.toNamed(
      '/serving-patient',
      arguments: {
        'patientId': patientId,
        'fullName': rxUserName.value.isNotEmpty ? rxUserName.value : userName,
        'age': userAge,
        'gender': userGender,
        'mhcId': rxMhcId.value,
        'mobileNo': rxPtMobileNo.value,
        'isAdmitted': rxIsAdmitted.value,
        'instituteId': rxInstituteId.value,
        'fromPatient': true,
        'doctorId': doctorId,
        'userType': type.isNotEmpty ? type : 'Patient',
        'initialTab': tabName,
      },
    );
  }

  void handleOpenQuickForm() {
    Get.to(
      () => const ServingPatientQuickFormView(),
      arguments: {
        'patientId': patientId,
        'formId': null,
      },
    );
  }

  void handleOpenMedicalForm() {
    Get.toNamed(
      '/medical-form',
      arguments: {
        'patientId': patientId,
        'userName': rxUserName.value.isNotEmpty ? rxUserName.value : userName,
        'userAge': userAge,
        'userGender': userGender,
        'from': 'from_medical_form',
        'type': type.isNotEmpty ? type : 'Patient',
        'doctorId': doctorId,
        'doctorName': doctorName.value,
      },
    );
  }

  void handleCategoryTap(String key) {
    switch (key) {
      case 'my_dashboard':
        handleOpenServingPatientTab('Dashboard');
        break;
      case 'quick_form':
        handleOpenQuickForm();
        break;
      case 'my_graphs':
        handleOpenServingPatientTab('Graph');
        break;
      case 'my_forms':
        handleOpenServingPatientTab('Form');
        break;
      case 'echo_cardiography_report':
        handleReportTap('Echo');
        break;
      default:
        break;
    }
  }


  final RxBool isEmergencyLoading = false.obs;
  final RxString emergencySelectedOption = 'Package / Online'.obs;

  Future<void> handleEmergencyDoctorTap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? '';
      final currentUserType = prefs.getString(AppConstants.prefLoginType) ?? type;

      // 1. Fetch remaining credit list
      int myCredit = 0;
      try {
        final creditReq = GetRemainCreditListReq(
          userId: currentUserId,
          userType: currentUserType,
        );
        final creditRes = await apiClient.post(
          ApiEndpoints.getRemainingCreditList,
          data: creditReq.toJson(),
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (creditRes.statusCode == 200 && creditRes.data != null) {
          final res = GetRemainCreditRes.fromJson(creditRes.data);
          if (res.status == 'success') {
            myCredit = int.tryParse(res.myCredit) ?? 0;
          }
        }
      } catch (e) {
        // Fail silently
      }

      // 2. Fetch user emergency package details
      String remainPackage = '0';
      try {
        final pkgReq = GetUserPackageDetailReq(
          userId: currentUserId,
          userType: currentUserType,
          packageType: 'Emergency Consultation',
        );
        final pkgRes = await apiClient.post(
          ApiEndpoints.getUserPackageDetails,
          data: pkgReq.toJson(),
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (pkgRes.statusCode == 200 && pkgRes.data != null) {
          final res = GetUserPackageDetailRes.fromJson(pkgRes.data);
          remainPackage = res.remain;
        }
      } catch (e) {
        // Fail silently
      }

      emergencySelectedOption.value = 'Package / Online';

      Get.dialog(
        EmergencyConsultationDialog(
          remainPackages: remainPackage,
          myCredit: myCredit,
          consultationFee: 300,
          userType: currentUserType,
          selectedOption: emergencySelectedOption,
          isLoading: isEmergencyLoading.value,
          onPay: () {
            _onEmergencyPay(
              remainPackages: remainPackage,
              myCredit: myCredit,
              currentUserId: currentUserId,
              currentUserType: currentUserType,
              token: token,
            );
          },
        ),
      );
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to initialize emergency service');
    }
  }

  Future<void> _onEmergencyPay({
    required String remainPackages,
    required int myCredit,
    required String currentUserId,
    required String currentUserType,
    required String token,
  }) async {
    final hasPackage = remainPackages != "0" && remainPackages.isNotEmpty;

    if (hasPackage) {
      // Deduct from emergency package
      isEmergencyLoading.value = true;
      try {
        final trackReq = UpdateUserPackageTrackReq(
          patientId: patientId,
          userId: currentUserId,
          userType: currentUserType,
          type: 'Emergency Consultation',
          refId: '',
        );
        final res = await apiClient.post(
          ApiEndpoints.updateUserPackageTrack,
          data: trackReq.toJson(),
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (res.statusCode == 200 && res.data != null) {
          final status = res.data['status']?.toString() ?? '';
          if (status == 'success') {
            await _bookEmergencyAppointmentNow();
          } else {
            AppSnackbars.showError('Error', res.data['msg']?.toString() ?? 'Failed to update package');
          }
        }
      } catch (e) {
        AppSnackbars.showError('Error', 'Failed to deduct package');
      } finally {
        isEmergencyLoading.value = false;
      }
    } else if (emergencySelectedOption.value == "Wallet") {
      if (myCredit < 300) {
        AppSnackbars.showError('Error', 'insufficient_wallet_credit'.tr);
        return;
      }
      isEmergencyLoading.value = true;
      try {
        final walletReq = UpdateUserWalletTrackReq(
          patientId: patientId,
          amount: '300',
          type: 'Emergency Consultation',
          userId: currentUserId,
          userType: currentUserType,
          packageId: '',
        );
        final res = await apiClient.post(
          ApiEndpoints.updateUserWalletTrack,
          data: walletReq.toJson(),
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (res.statusCode == 200 && res.data != null) {
          final status = res.data['status']?.toString() ?? '';
          if (status == 'success') {
            await _bookEmergencyAppointmentNow();
          } else {
            AppSnackbars.showError('Error', res.data['msg']?.toString() ?? 'Wallet deduction failed');
          }
        }
      } catch (e) {
        AppSnackbars.showError('Error', 'Wallet transaction failed');
      } finally {
        isEmergencyLoading.value = false;
      }
    } else {
      // Online payment via Razorpay
      await _startEmergencyOnlinePayment(
        amount: '30000',
        currentUserId: currentUserId,
        currentUserType: currentUserType,
        token: token,
      );
    }
  }

  Future<void> _startEmergencyOnlinePayment({
    required String amount,
    required String currentUserId,
    required String currentUserType,
    required String token,
  }) async {
    isEmergencyLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString(AppConstants.prefUserEmail) ?? '';
      final userMobile = prefs.getString(AppConstants.prefUserMobileNumber) ?? '';

      // 1. Create Order via api/v2/Payment/get_order
      final orderPayload = {
        'user_id': patientId.isNotEmpty ? patientId : currentUserId,
        'package_id': 0,
        'amount': amount,
        'payment_for': 'Emergency Doctor',
        'payment_by': currentUserType.isNotEmpty ? currentUserType : 'Patient',
        'payment_by_id': currentUserId.isNotEmpty ? currentUserId : patientId,
      };

      final orderRes = await apiClient.post(
        ApiEndpoints.getOrder,
        data: orderPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (orderRes.statusCode != 200 || orderRes.data == null) {
        AppSnackbars.showError('Payment Error', 'Failed to generate payment order');
        return;
      }

      final orderData = OrderResponse.fromJson(orderRes.data);
      if (orderData.status != 'success' || orderData.orderId.isEmpty) {
        AppSnackbars.showError('Payment Error', orderData.msg.isNotEmpty ? orderData.msg : 'Failed to generate order');
        return;
      }

      final int amountInPaise = int.tryParse(amount) ?? 30000;

      // 2. Open Razorpay Checkout
      _razorpayService.openPayment(
        amountInPaise: amountInPaise,
        orderId: orderData.orderId,
        appName: orderData.appName.isNotEmpty ? orderData.appName : 'Digi ICU',
        appLogo: orderData.appLogo,
        contactNumber: userMobile,
        email: userEmail,
        description: 'Emergency Consultation',
        onSuccess: (PaymentSuccessResponse success) async {
          await _verifyEmergencySignature(
            signature: success.signature ?? '',
            paymentId: success.paymentId ?? '',
            orderId: orderData.orderId,
            token: token,
          );
        },
        onFailure: (PaymentFailureResponse failure) {
          AppSnackbars.showError(
            'Payment Failed',
            failure.message ?? 'Emergency consultation payment was cancelled or failed.',
          );
        },
      );
    } catch (e) {
      AppSnackbars.showError('Payment Error', 'Failed to initiate online payment');
    } finally {
      isEmergencyLoading.value = false;
    }
  }

  Future<void> _verifyEmergencySignature({
    required String signature,
    required String paymentId,
    required String orderId,
    required String token,
  }) async {
    isEmergencyLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? '';
      final targetUserId = patientId.isNotEmpty ? patientId : currentUserId;

      final verifyPayload = {
        'user_id': targetUserId,
        'signature': signature,
        'payment_id': paymentId,
        'order_id': orderId,
        'request_from': 'Emergency Doctor',
      };

      final verifyRes = await apiClient.post(
        ApiEndpoints.verifySignature,
        data: verifyPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (verifyRes.statusCode == 200 && verifyRes.data != null) {
        final status = verifyRes.data['status']?.toString() ?? '';
        if (status == 'success') {
          AppSnackbars.showSuccess('Payment Successful', 'Payment verified successfully!');
          await _bookEmergencyAppointmentNow();
        } else {
          AppSnackbars.showError('Payment Error', verifyRes.data['msg']?.toString() ?? 'Signature verification failed');
        }
      } else {
        AppSnackbars.showError('Payment Error', 'Failed to verify payment signature');
      }
    } catch (e) {
      AppSnackbars.showError('Payment Error', 'Payment verification failed');
    } finally {
      isEmergencyLoading.value = false;
    }
  }

  Future<void> _bookEmergencyAppointmentNow() async {
    isEmergencyLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? '';
      final currentUserType = prefs.getString(AppConstants.prefLoginType) ?? type;

      final now = DateTime.now();
      final dayName = DateFormat('EEEE').format(now);
      final dateStr = DateFormat('yyyy-MM-dd').format(now);
      final timeStr = DateFormat('HH:mm:ss').format(now);

      // 1. Fetch Emergency Doctor Slots
      final slotsResponse = await apiClient.post(
        ApiEndpoints.getTimeSlotNew,
        data: {
          'doctor_id': AppConstants.emergencyDoctorId,
          'day': dayName,
          'date': dateStr,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (slotsResponse.statusCode != 200 || slotsResponse.data == null) {
        AppSnackbars.showError('Error', 'doctor_not_available_now'.tr);
        return;
      }

      final slotsData = AppointmentSlotsResponse.fromJson(slotsResponse.data);
      if (slotsData.status != 'success' || slotsData.data.isEmpty) {
        AppSnackbars.showInfo(
          'doctor_not_available_now'.tr,
          'doctor_not_available_now'.tr,
        );
        return;
      }

      // Slot resolution: find matching current slot or fallback to last slot
      AppointmentSlotModel matchedSlot = slotsData.data.last;
      for (final slot in slotsData.data) {
        final slotTimes = slot.timeSlot.split('to');
        if (slotTimes.length == 2) {
          try {
            final startFormat = DateFormat('yyyy-MM-dd hh:mm a');
            final start = startFormat.parse('$dateStr ${slotTimes[0].trim().toLowerCase()}');
            final end = startFormat.parse('$dateStr ${slotTimes[1].trim().toLowerCase()}');
            if (now.isAfter(start) && now.isBefore(end)) {
              matchedSlot = slot;
              break;
            }
          } catch (e) {
            // Ignore format parse exceptions
          }
        }
      }

      final String appointmentBy = (currentUserType == 'Patient') ? 'self' : currentUserType;
      final bookingPayload = {
        'place': '',
        'patient_id': patientId,
        'doctor_id': AppConstants.emergencyDoctorId,
        'time_slot_id': matchedSlot.id,
        'time_slot': matchedSlot.timeSlot,
        'booking_date': dateStr,
        'booking_time': timeStr,
        'appointment_by': appointmentBy,
        'appointment_by_id': currentUserId,
        'speciality': 'Emergency Consultation',
        'problem': 'Emergency Doctor Consultation',
        'home_service_id': '',
        'platform': 'App',
        'appointment_type': 'Emergency',
        'amount': 300,
      };

      final bookResponse = await apiClient.post(
        ApiEndpoints.bookAppointment,
        data: bookingPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (bookResponse.statusCode == 200 && bookResponse.data != null) {
        final res = BookAppointmentResponse.fromJson(bookResponse.data);
        if (res.status == 'success') {
          AppSnackbars.showSuccess('Success', 'Appointment booked successfully!');
          if (Get.currentRoute != '/patient-dashboard') {
            Get.toNamed('/patient-dashboard');
          }
        } else {
          AppSnackbars.showError('Error', res.msg.isNotEmpty ? res.msg : 'Failed to book appointment');
        }
      } else {
        AppSnackbars.showError('Error', 'Failed to book emergency appointment');
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to connect with Emergency Doctor');
    } finally {
      isEmergencyLoading.value = false;
    }
  }

  void handleBack() {
    if (loggedInUserType.value.toLowerCase() == 'patient') {
      AppSnackbars.showWarning('warning'.tr, 'you_cant_go_back'.tr);
      return;
    }
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed('/doctor-dashboard');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }

  void onPayNowClick(
    String payableAmount,
    String packageId,
    String packageType,
    String packageName,
    String paymentReferenceId,
  ) {
    // Razorpay Integration Order creation
  }

  @override
  void onClose() {
    _razorpayService.dispose();
    super.onClose();
  }
}
