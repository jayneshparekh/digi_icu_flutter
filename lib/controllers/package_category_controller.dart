import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/request/payment/get_order_request.dart';
import '../models/response/patients/doctor_list_patient_side_response.dart';
import '../models/response/payment/get_order_response.dart';
import '../models/response/users/package_categories_response.dart';
import '../services/api/api_client.dart';
import '../services/razorpay_service.dart';

class PackageCategoryController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  late final RazorpayService _razorpayService;

  // Route arguments
  String patientId = '';
  String patientName = '';
  String age = '';
  String gender = '';
  String medicalForm = '0';
  String consultationCharge = '';
  String packageType = '';
  String userType = '';
  String leaderId = '';
  String userId = '';
  String contactNumber = '';
  String email = '';
  DoctorDataModel? doctorData;

  // UI state
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;
  final RxList<PackageCategoryModel> categories = <PackageCategoryModel>[].obs;
  final RxList<PackageCategoryModel> filteredCategories = <PackageCategoryModel>[].obs;
  final RxString selectedPaymentType = 'online'.obs;
  final RxString loggedInUserName = ''.obs;
  final promoCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _razorpayService = RazorpayService();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      patientId = args['patientId']?.toString() ?? '';
      patientName = args['patientName']?.toString() ?? '';
      age = args['userAge']?.toString() ?? '';
      gender = args['userGender']?.toString() ?? '';
      medicalForm = args['medicalForm']?.toString() ?? '0';
      consultationCharge = args['consultationCharge']?.toString() ?? '';
      packageType = args['packageType']?.toString() ?? '';
      userType = args['type']?.toString() ?? '';
      leaderId = args['leaderId']?.toString() ?? '';
      doctorData = args['mData'] as DoctorDataModel?;
    }

    _loadUserPrefs();
    fetchPackageCategories();
  }

  @override
  void onClose() {
    _razorpayService.dispose();
    promoCodeController.dispose();
    super.onClose();
  }

  Future<void> _loadUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(AppConstants.prefUserId) ?? '';
    contactNumber = prefs.getString(AppConstants.prefUserMobileNumber) ?? '';
    email = prefs.getString(AppConstants.prefUserEmail) ?? '';
    loggedInUserName.value = prefs.getString(AppConstants.prefUserName) ?? '';
  }

  Future<void> fetchPackageCategories() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getPackageCategories,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final catRes = PackageCategoriesResponse.fromJson(response.data);
        if (catRes.status == 'success') {
          categories.assignAll(catRes.data);
          filteredCategories.assignAll(catRes.data);
        } else {
          errorMsg.value = catRes.msg;
        }
      } else {
        errorMsg.value = 'Failed to load categories';
      }
    } catch (e) {
      errorMsg.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredCategories.assignAll(categories.where((cat) {
        return cat.name.toLowerCase().contains(lowercaseQuery);
      }).toList());
    }
  }

  /// Step 1: Call the server to create a Razorpay order, then open the checkout.
  Future<void> initiateOnlinePayment() async {
    final chargeStr = consultationCharge.replaceAll(RegExp(r'[^0-9.]'), '');
    final chargeAmount = double.tryParse(chargeStr) ?? 0;
    if (chargeAmount <= 0) {
      Get.snackbar('Error', 'Invalid consultation charge amount');
      return;
    }

    // Razorpay expects amount in paise (1 INR = 100 paise).
    final amountInPaise = (chargeAmount * 100).toInt();

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final request = GetOrderRequest(
        userId: userId,
        packageId: 0,
        amount: amountInPaise.toString(),
        paymentBy: userType,
        paymentById: userId,
        paymentFor: 'Package',
      );

      final response = await apiClient.post(
        ApiEndpoints.getOrder,
        data: request.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.data != null) {
        final orderRes = GetOrderResponse.fromJson(response.data as Map<String, dynamic>);
        if (orderRes.status == 'success') {
          // Step 2: Open Razorpay checkout with the server-returned order details.
          _openRazorpayCheckout(
            amountInPaise: amountInPaise,
            orderId: orderRes.orderId,
            appName: orderRes.appName,
            appLogo: orderRes.appLogo,
          );
        } else {
          Get.snackbar('Order Error', orderRes.msg);
        }
      } else {
        Get.snackbar('Error', 'Failed to create payment order. Please try again.');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    }
  }

  void _openRazorpayCheckout({
    required int amountInPaise,
    required String orderId,
    required String appName,
    required String appLogo,
  }) {
    _razorpayService.openPayment(
      amountInPaise: amountInPaise,
      orderId: orderId,
      appName: appName,
      appLogo: appLogo,
      email: email,
      contactNumber: contactNumber,
      description: 'One Time Consultation',
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
      onExternalWallet: _onExternalWallet,
    );
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar(
      'Payment Successful',
      'Payment ID: ${response.paymentId}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
    redirectToScreen();
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment was not completed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External Wallet',
      'Payment via ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter the promo code');
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.checkPromocode,
        data: {
          'patient_id': patientId,
          'promo_code': code,
          'package_id': '1',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final status = response.data['status']?.toString();
        final msg = response.data['msg']?.toString() ?? '';
        if (status == 'success') {
          Get.snackbar(
            'Success',
            'Package booked successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 2),
          );
          redirectToScreen();
        } else {
          Get.snackbar('Promo Code Error', msg);
        }
      } else {
        Get.snackbar('Error', 'Failed to check promo code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong applying promo code');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentType(String type) {
    selectedPaymentType.value = type;
  }

  void redirectToScreen() {
    if (medicalForm == '1') {
      Get.offAllNamed('/take-appointment', arguments: {
        'doctorId': doctorData?.id,
        'doctorName': doctorData != null ? 'Dr. ${doctorData!.firstName} ${doctorData!.lastName}' : '',
        'patientId': patientId,
        'userName': patientName,
        'userAge': age,
        'userGender': gender,
        'type': userType,
      });
    } else {
      Get.toNamed('/medical-form', arguments: {
        'doctorId': doctorData?.id,
        'patientId': patientId,
        'doctorName': doctorData != null ? 'Dr. ${doctorData!.firstName} ${doctorData!.lastName}' : '',
        'userAge': age,
        'userGender': gender,
        'type': userType,
      });
    }
  }
}


