import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/response/doctors/dashboard_details_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServingPatientDashboardController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  final Rxn<DashboardTabDataModel> dashboardData = Rxn<DashboardTabDataModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late final String patientId;

  @override
  void onInit() {
    super.onInit();
    final parent = Get.find<ServingPatientController>();
    patientId = parent.patientId;
    fetchDashboardDetails();
  }

  Future<void> fetchDashboardDetails() async {
    if (patientId.isEmpty) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.dashboardDetails,
        data: {
          'patient_id': patientId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = DashboardDetailsResponse.fromJson(response.data);
        if (res.status == 'success') {
          dashboardData.value = res.data;
        } else {
          errorMessage.value = res.msg.isNotEmpty ? res.msg : 'Failed to load dashboard details.';
        }
      } else {
        errorMessage.value = 'Failed to load details: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Connection error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addQuickForm(String hba1cValue, String hba1cDate) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.quickForm,
        data: {
          'patient_id': patientId,
          'hba1c': hba1cValue,
          'hba1c_date': hba1cDate,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final statusVal = response.data['status']?.toString() ?? '';
        final msgVal = response.data['msg']?.toString() ?? '';
        if (statusVal == 'success') {
          Get.rawSnackbar(
            message: msgVal.isNotEmpty ? msgVal : 'HbA1c added successfully.',
            backgroundColor: Colors.green,
          );
          fetchDashboardDetails();
          return true;
        } else {
          Get.rawSnackbar(
            message: msgVal.isNotEmpty ? msgVal : 'Failed to submit HbA1c.',
            backgroundColor: Colors.red,
          );
          return false;
        }
      } else {
        Get.rawSnackbar(message: 'Server error: ${response.statusCode}', backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error submitting HbA1c: $e', backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
