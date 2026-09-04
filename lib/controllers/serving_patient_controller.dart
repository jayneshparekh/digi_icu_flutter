import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctor/bp_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/other_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/sugar_graph_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServingPatientController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

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
  late final String qrCode;
  late final bool fromPatient;
  late final String isFrom;

  // Active Center tab state
  final RxString currentTab = 'Dashboard'.obs;

  // Patient detail properties
  final RxString patientRating = '0'.obs;
  final RxBool isLoadingDetails = false.obs;
  final RxString userType = 'Doctor'.obs;

  // Graph tab state & data
  final RxBool isLoadingGraph = false.obs;
  final RxList<BPGraphData> bpGraphList = <BPGraphData>[].obs;
  final Rxn<TargetBp> targetBp = Rxn<TargetBp>();
  final RxList<SugarGraphData> sugarGraphList = <SugarGraphData>[].obs;
  final RxList<OtherGraphData> otherGraphList = <OtherGraphData>[].obs;

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
    qrCode = args['qrCode']?.toString() ?? '';
    fromPatient = args['fromPatient'] as bool? ?? false;
    isFrom = args['isFrom']?.toString() ?? '';

    _loadUserType().then((_) {
      fetchPatientDetails();
    });
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
  }

  Future<void> fetchPatientDetails() async {
    if (patientId.isEmpty || bookingId.isEmpty) return;
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.patientDetails,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          final ratingVal = response.data['data']?['rating']?.toString() ?? '0';
          patientRating.value = ratingVal;
        }
      }
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void changeTab(String tab) {
    currentTab.value = tab;
    if (tab == 'Graph' && bpGraphList.isEmpty && sugarGraphList.isEmpty && otherGraphList.isEmpty) {
      fetchGraphData();
    }
  }

  Future<void> fetchGraphData() async {
    if (patientId.isEmpty) return;
    isLoadingGraph.value = true;
    try {
      await Future.wait([
        fetchBPGraph(),
        fetchSugarGraph(),
        fetchOtherGraph(),
      ]);
    } finally {
      isLoadingGraph.value = false;
    }
  }

  Future<void> fetchBPGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.bpGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = BPGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          bpGraphList.value = res.data ?? [];
          targetBp.value = res.targetBp;
        }
      }
    } catch (e) {
      debugPrint('Error fetching BP graph: $e');
    }
  }

  Future<void> fetchSugarGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.sugarGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = SugarGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          sugarGraphList.value = res.data ?? [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching Sugar graph: $e');
    }
  }

  Future<void> fetchOtherGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.otherGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = OtherGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          otherGraphList.value = res.data ?? [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching Other graph: $e');
    }
  }

  Future<void> addRating(String ratingValue) async {
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.addRating,
        data: {
          'patient_id': patientId,
          'rating': ratingValue,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          patientRating.value = ratingValue;
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Rating added successfully.',
            backgroundColor: AppColors.success,
          );
          _showFinishAppointmentDialog();
        } else {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Failed to add rating.',
            backgroundColor: AppColors.error,
          );
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error adding rating: $e', backgroundColor: AppColors.error);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void _showFinishAppointmentDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Finish'),
        content: const Text('Do you want to Finish this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.medicalGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              changeAppointmentStatus('', '1');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
            child: const Text('Yes', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> changeAppointmentStatus(String reason, String statusValue) async {
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.updateAppointmentStatus,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
          'status': statusValue,
          'hold_reason': reason,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Appointment status updated.',
            backgroundColor: AppColors.success,
          );
          Get.offAllNamed('/patient-list');
        } else {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Failed to update appointment status.',
            backgroundColor: AppColors.error,
          );
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error updating status: $e', backgroundColor: AppColors.error);
    } finally {
      isLoadingDetails.value = false;
    }
  }
}
