import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/constants/api_endpoints.dart';
import '../core/constants/app_constants.dart';
import '../models/request/patients/add_ambulance_service_req.dart';
import '../models/response/patients/add_ambulance_res.dart';
import '../models/response/payment/order_response.dart';
import '../services/api/api_client.dart';
import '../services/storage_service.dart';
import '../services/razorpay_service.dart';
import '../views/widgets/app_snackbars.dart';

class AmbulanceServiceRequestController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final RazorpayService _razorpayService = RazorpayService();

  // Route arguments / patient session data
  String patientId = '';
  String patientName = '';
  String ptMobileNo = '';
  String regAddress = '';
  String regLatitude = '';
  String regLongitude = '';
  String regPinCode = '';
  String userType = '';

  final RxString rxPtMobileNo = ''.obs;
  final RxString rxPatientName = ''.obs;

  // Form selections & observables
  final RxString forWhom = 'Myself'.obs;
  final RxBool isEditingMyselfMobile = false.obs;
  final RxString locationType = 'Current'.obs; // 'RegisterLocation', 'Current', 'Other'
  final RxString visitType = 'Urgent'.obs; // 'Urgent', 'Today', 'Tomorrow', 'Schedule ambulance visit'

  // Current detected location
  final RxString currentAddress = ''.obs;
  final RxString currentPinCode = ''.obs;
  final RxString currentLatitude = ''.obs;
  final RxString currentLongitude = ''.obs;
  final RxBool isLocating = false.obs;

  // Visit Scheduling selections
  final Rxn<TimeOfDay> selectedTodayTime = Rxn<TimeOfDay>();
  final Rxn<TimeOfDay> selectedTomorrowTime = Rxn<TimeOfDay>();
  final Rxn<DateTime> selectedScheduleDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedScheduleTime = Rxn<TimeOfDay>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    final args = Get.arguments as Map<String, dynamic>?;
    final prefs = StorageService.to.prefs;

    patientId = (args?['patientId'] ??
            args?['patient_id'] ??
            prefs.getString(AppConstants.prefSelectedPatientId) ??
            prefs.getString(AppConstants.prefUserId) ??
            '')
        .toString();

    final passedName = (args?['patientName'] ??
            args?['userName'] ??
            prefs.getString(AppConstants.prefSelectedPatientName) ??
            prefs.getString(AppConstants.prefUserName) ??
            '')
        .toString();
    patientName = passedName;
    rxPatientName.value = passedName;

    final passedMobile = (args?['ptMobileNo'] ??
            args?['mobileNo'] ??
            args?['mobile_no'] ??
            args?['userMobile'] ??
            prefs.getString(AppConstants.prefUserMobileNumber) ??
            '')
        .toString();
    ptMobileNo = passedMobile;
    rxPtMobileNo.value = passedMobile;

    regAddress = (args?['regAddress'] ??
            prefs.getString(AppConstants.prefAddress) ??
            '')
        .toString();

    regLatitude = (args?['regLatitude'] ?? '').toString();
    regLongitude = (args?['regLongitude'] ?? '').toString();
    regPinCode = (args?['pinCode'] ?? '').toString();
    userType = (args?['userType'] ??
            prefs.getString(AppConstants.prefLoginType) ??
            'Patient')
        .toString();

    final passedProblem = (args?['problem'] ?? '').toString();
    if (passedProblem.isNotEmpty) {
      problemController.text = passedProblem;
    }

    if (patientName.isNotEmpty) {
      nameController.text = patientName;
    }
    if (ptMobileNo.isNotEmpty) {
      mobileController.text = ptMobileNo;
    }

    // If mobile or address is empty, fetch check_home
    if ((rxPtMobileNo.value.isEmpty || regAddress.isEmpty) && patientId.isNotEmpty) {
      _fetchPatientDetails();
    }

    // Default to Current location and detect
    detectCurrentLocation();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      final prefs = StorageService.to.prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await _apiClient.post(
        ApiEndpoints.checkHome,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final mobile = data['pt_mobile_no']?.toString() ??
            data['mobile_no']?.toString() ??
            '';
        if (mobile.isNotEmpty) {
          rxPtMobileNo.value = mobile;
          ptMobileNo = mobile;
          mobileController.text = mobile;
        }
        final name = data['patient_name']?.toString() ?? '';
        if (name.isNotEmpty && rxPatientName.value.isEmpty) {
          rxPatientName.value = name;
          patientName = name;
          nameController.text = name;
        }
        final addr = data['registered_address']?.toString() ?? '';
        if (addr.isNotEmpty) {
          regAddress = addr;
        }
        final pin = data['registered_pin_code']?.toString() ??
            data['pin_code']?.toString() ??
            '';
        if (pin.isNotEmpty) {
          regPinCode = pin;
        }
        final lat = data['latitude']?.toString() ?? '';
        if (lat.isNotEmpty) {
          regLatitude = lat;
        }
        final lng = data['longitude']?.toString() ?? '';
        if (lng.isNotEmpty) {
          regLongitude = lng;
        }
      }
    } catch (_) {
      // Ignore background fetch error
    }
  }

  Future<void> detectCurrentLocation({bool showError = false}) async {
    isLocating.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (showError) {
          AppSnackbars.showError('Error', 'Please enable GPS location service.');
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (showError) {
            AppSnackbars.showError('Error', 'Location permission denied.');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (showError) {
          AppSnackbars.showError('Error', 'Location permission is permanently denied.');
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      currentLatitude.value = position.latitude.toString();
      currentLongitude.value = position.longitude.toString();

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final addressParts = [
          p.name,
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ]
            .whereType<String>()
            .where((e) => e.trim().isNotEmpty)
            .toSet()
            .toList();

        currentAddress.value = addressParts.join(', ');
        currentPinCode.value = p.postalCode ?? '';

        if (locationType.value == 'Current') {
          addressController.text = currentAddress.value;
          pinCodeController.text = currentPinCode.value;
        }
      }
    } catch (_) {
      // Fallback silently if auto-detect fails
    } finally {
      isLocating.value = false;
    }
  }

  void onForWhomChanged(String value) {
    forWhom.value = value;
    if (value == 'Myself') {
      isEditingMyselfMobile.value = false;
      nameController.text = rxPatientName.value.isNotEmpty ? rxPatientName.value : patientName;
      mobileController.text = rxPtMobileNo.value.isNotEmpty ? rxPtMobileNo.value : ptMobileNo;
    } else {
      nameController.clear();
      mobileController.clear();
    }
  }

  void toggleEditMyselfMobile() {
    isEditingMyselfMobile.value = !isEditingMyselfMobile.value;
    final fallbackMobile = rxPtMobileNo.value.isNotEmpty ? rxPtMobileNo.value : ptMobileNo;
    mobileController.text = fallbackMobile;
  }

  void onLocationTypeChanged(String value) {
    locationType.value = value;
    if (value == 'RegisterLocation') {
      addressController.text = regAddress;
      pinCodeController.text = regPinCode;
    } else if (value == 'Current') {
      addressController.text = currentAddress.value;
      pinCodeController.text = currentPinCode.value;
      if (currentAddress.value.isEmpty) {
        detectCurrentLocation(showError: true);
      }
    } else if (value == 'Other') {
      addressController.clear();
      pinCodeController.clear();
    }
  }

  void onVisitTypeChanged(String value) {
    visitType.value = value;
  }

  Future<void> selectTodayTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTodayTime.value ?? now,
    );
    if (picked != null) {
      selectedTodayTime.value = picked;
    }
  }

  Future<void> selectTomorrowTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTomorrowTime.value ?? now,
    );
    if (picked != null) {
      selectedTomorrowTime.value = picked;
    }
  }

  Future<void> selectScheduleDate(BuildContext context) async {
    final now = DateTime.now();
    final firstAllowedDate = now.add(const Duration(days: 1));
    final lastAllowedDate = now.add(const Duration(days: 4));

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedScheduleDate.value ?? firstAllowedDate,
      firstDate: firstAllowedDate,
      lastDate: lastAllowedDate,
    );
    if (picked != null) {
      selectedScheduleDate.value = picked;
    }
  }

  Future<void> selectScheduleTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedScheduleTime.value ?? now,
    );
    if (picked != null) {
      selectedScheduleTime.value = picked;
    }
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> submitAndProceed() async {
    // 1. Validation
    final problem = problemController.text.trim();
    if (problem.isEmpty) {
      AppSnackbars.showError('Error', 'please_enter_problem'.tr);
      return;
    }

    String selectedName = rxPatientName.value.isNotEmpty ? rxPatientName.value : patientName;
    String selectedMobile = rxPtMobileNo.value.isNotEmpty ? rxPtMobileNo.value : ptMobileNo;

    if (forWhom.value == 'Other') {
      selectedName = nameController.text.trim();
      selectedMobile = mobileController.text.trim();
      if (selectedName.isEmpty) {
        AppSnackbars.showError('Error', 'please_enter_valid_name'.tr);
        return;
      }
      if (selectedMobile.length != 10) {
        AppSnackbars.showError('Error', 'please_enter_valid_mobile'.tr);
        return;
      }
    } else if (forWhom.value == 'Myself' && isEditingMyselfMobile.value) {
      selectedMobile = mobileController.text.trim();
      if (selectedMobile.length != 10) {
        AppSnackbars.showError('Error', 'please_enter_valid_mobile'.tr);
        return;
      }
    }

    String selectedAddress = '';
    String selectedPin = '';
    String selectedLat = '';
    String selectedLong = '';

    if (locationType.value == 'RegisterLocation') {
      selectedAddress = regAddress;
      selectedPin = regPinCode;
      selectedLat = regLatitude;
      selectedLong = regLongitude;
      if (selectedAddress.isEmpty) {
        AppSnackbars.showError('Error', 'please_enter_address'.tr);
        return;
      }
    } else if (locationType.value == 'Current') {
      selectedAddress = currentAddress.value.isNotEmpty
          ? currentAddress.value
          : addressController.text.trim();
      selectedPin = currentPinCode.value.isNotEmpty
          ? currentPinCode.value
          : pinCodeController.text.trim();
      selectedLat = currentLatitude.value;
      selectedLong = currentLongitude.value;
      if (selectedAddress.isEmpty) {
        AppSnackbars.showError('Error', 'please_enter_address'.tr);
        return;
      }
    } else {
      selectedAddress = addressController.text.trim();
      selectedPin = pinCodeController.text.trim();
      if (selectedAddress.isEmpty) {
        AppSnackbars.showError('Error', 'please_enter_address'.tr);
        return;
      }
      if (selectedPin.isEmpty) {
        AppSnackbars.showError('Error', 'please_enter_pincode'.tr);
        return;
      }
    }

    String formattedVisitType = 'Urgent';
    if (visitType.value == 'Today') {
      if (selectedTodayTime.value == null) {
        AppSnackbars.showError('Error', 'please_select_time'.tr);
        return;
      }
      formattedVisitType = 'Today (${formatTimeOfDay(selectedTodayTime.value)})';
    } else if (visitType.value == 'Tomorrow') {
      if (selectedTomorrowTime.value == null) {
        AppSnackbars.showError('Error', 'please_select_time'.tr);
        return;
      }
      formattedVisitType = 'Tomorrow (${formatTimeOfDay(selectedTomorrowTime.value)})';
    } else if (visitType.value == 'Schedule ambulance visit') {
      if (selectedScheduleDate.value == null || selectedScheduleTime.value == null) {
        AppSnackbars.showError('Error', 'please_select_date_time'.tr);
        return;
      }
      final dateStr = DateFormat('dd/MM/yyyy').format(selectedScheduleDate.value!);
      final timeStr = formatTimeOfDay(selectedScheduleTime.value);
      formattedVisitType = 'Schedule ambulance visit ($dateStr $timeStr)';
    }

    // 2. Generate Razorpay Order
    isLoading.value = true;
    try {
      final prefs = StorageService.to.prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userEmail = prefs.getString(AppConstants.prefUserEmail) ?? '';
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? patientId;

      final amount = visitType.value == 'Urgent' ? '50000' : '30000';

      final orderPayload = {
        'user_id': patientId.isNotEmpty ? patientId : currentUserId,
        'package_id': 0,
        'amount': amount,
        'payment_for': 'Ambulance Service',
        'payment_by': userType.isNotEmpty ? userType : 'Patient',
        'payment_by_id': currentUserId.isNotEmpty ? currentUserId : patientId,
      };

      final orderRes = await _apiClient.post(
        ApiEndpoints.getOrder,
        data: orderPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (orderRes.statusCode != 200 || orderRes.data == null) {
        AppSnackbars.showError('Payment Error', 'Failed to generate payment order');
        return;
      }

      final orderData = OrderResponse.fromJson(orderRes.data as Map<String, dynamic>);
      if (orderData.status != 'success' || orderData.orderId.isEmpty) {
        AppSnackbars.showError(
          'Payment Error',
          orderData.msg.isNotEmpty ? orderData.msg : 'Failed to generate order',
        );
        return;
      }

      final int amountInPaise = int.tryParse(amount) ?? 50000;

      // 3. Open Razorpay Checkout
      _razorpayService.openPayment(
        amountInPaise: amountInPaise,
        orderId: orderData.orderId,
        appName: orderData.appName.isNotEmpty ? orderData.appName : 'Digi ICU',
        appLogo: orderData.appLogo,
        contactNumber: selectedMobile,
        email: userEmail,
        description: 'Ambulance Service',
        onSuccess: (PaymentSuccessResponse success) async {
          await _verifyAndSubmitAmbulance(
            signature: success.signature ?? '',
            paymentId: success.paymentId ?? '',
            orderId: orderData.orderId,
            selectedName: selectedName,
            selectedMobile: selectedMobile,
            selectedAddress: selectedAddress,
            selectedLat: selectedLat,
            selectedLong: selectedLong,
            selectedPin: selectedPin,
            problem: problem,
            formattedVisitType: formattedVisitType,
            token: token,
          );
        },
        onFailure: (PaymentFailureResponse failure) {
          AppSnackbars.showError(
            'Payment Failed',
            failure.message ?? 'Ambulance service payment was cancelled or failed.',
          );
        },
      );
    } catch (e) {
      AppSnackbars.showError('Payment Error', 'Failed to initiate online payment');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyAndSubmitAmbulance({
    required String signature,
    required String paymentId,
    required String orderId,
    required String selectedName,
    required String selectedMobile,
    required String selectedAddress,
    required String selectedLat,
    required String selectedLong,
    required String selectedPin,
    required String problem,
    required String formattedVisitType,
    required String token,
  }) async {
    isLoading.value = true;
    try {
      final prefs = StorageService.to.prefs;
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? patientId;

      // 1. Verify Payment Signature
      final verifyPayload = {
        'user_id': patientId.isNotEmpty ? patientId : currentUserId,
        'signature': signature,
        'payment_id': paymentId,
        'order_id': orderId,
        'request_from': 'Ambulance Service',
      };

      final verifyRes = await _apiClient.post(
        ApiEndpoints.verifySignature,
        data: verifyPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (verifyRes.statusCode != 200 || verifyRes.data == null) {
        AppSnackbars.showError('Payment Error', 'Failed to verify payment signature');
        return;
      }

      final status = verifyRes.data['status']?.toString() ?? '';
      if (status != 'success') {
        AppSnackbars.showError(
          'Payment Error',
          verifyRes.data['msg']?.toString() ?? 'Signature verification failed',
        );
        return;
      }

      // 2. Signature verified - Now create ambulance request in database
      final req = AddAmbulanceServiceReq(
        patientId: patientId,
        forWhom: forWhom.value,
        name: selectedName,
        mobileNo: selectedMobile,
        addressType: locationType.value,
        location: selectedAddress,
        latitude: selectedLat,
        longitude: selectedLong,
        pinCode: selectedPin,
        problem: problem,
        visitType: formattedVisitType,
      );

      final response = await _apiClient.post(
        ApiEndpoints.addAmbulanceService,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = AddAmbulanceRes.fromJson(response.data as Map<String, dynamic>);
        if (res.status == 'success') {
          final successMessage =
              res.msg.isNotEmpty ? res.msg : 'ambulance_request_submitted'.tr;
          Get.until((route) =>
              route.settings.name == '/patient-dashboard' || route.isFirst);
          AppSnackbars.showSuccess(
            'success'.tr,
            successMessage,
          );
        } else {
          AppSnackbars.showError(
            'Error',
            res.msg.isNotEmpty ? res.msg : 'Failed to register ambulance request',
          );
        }
      } else {
        AppSnackbars.showError('Error', 'Failed to register ambulance request');
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'An error occurred while confirming ambulance request');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _razorpayService.dispose();
    nameController.dispose();
    mobileController.dispose();
    problemController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }
}
