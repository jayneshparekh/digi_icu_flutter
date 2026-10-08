import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/user/get_discharge_data_request.dart';
import 'package:digi_icu_flutter/models/response/user/get_discharge_data_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DischargeSummaryController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Patient Info from arguments
  final RxString patientId = ''.obs;
  final RxString admitId = ''.obs;
  final RxString appointmentId = ''.obs;
  final RxString patientName = ''.obs;
  final RxString age = ''.obs;
  final RxString gender = ''.obs;
  final RxString mhcId = ''.obs;
  final RxString instituteId = ''.obs;

  // Active top tab ('prepare', 'upload', 'death')
  final RxString activeTab = 'prepare'.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // 1. Diagnosis
  final RxString diagnosisText = '-'.obs;

  // 2. Patient Condition ('Stable' or 'Unstable')
  final RxString patientCondition = 'Stable'.obs;

  // 3. Past History
  final TextEditingController pastHistoryController = TextEditingController();

  // 4. Symptoms list & reactive set
  final List<String> standardSymptoms = const [
    'Fever',
    'Chest Pain',
    'Dyspnea',
    'Cough',
    'Bodyache',
    'Giddiness',
    'Leg Pain',
    'Headache',
    'Abdominal Pain',
    'Vomitting',
    'Loose Motions',
    'Asymptomatic',
  ];
  final RxSet<String> selectedSymptoms = <String>{}.obs;

  // 5. At Presentation Complaints
  final TextEditingController atPresentationComplaintsController =
      TextEditingController();

  // Draft saved state
  final RxBool isDraftSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    loadDischargeData();
    loadPatientDiagnosis();
  }

  @override
  void onClose() {
    pastHistoryController.dispose();
    atPresentationComplaintsController.dispose();
    super.onClose();
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map) {
      admitId.value = args['admitId']?.toString() ?? '';
      patientId.value = args['patientId']?.toString() ?? '';
      appointmentId.value = args['appointmentId']?.toString() ?? '';
      patientName.value = args['patientName']?.toString() ?? '';
      age.value = args['age']?.toString() ?? '';
      gender.value = args['gender']?.toString() ?? '';
      mhcId.value = args['mhcId']?.toString() ?? '';
      instituteId.value = args['instituteId']?.toString() ?? '';
      final diag = args['diagnosis']?.toString() ?? '';
      if (diag.isNotEmpty) {
        diagnosisText.value = diag;
      }
    }
  }

  /// Loads existing discharge summary data for this admission
  Future<void> loadDischargeData() async {
    if (admitId.value.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final request = GetDischargeDataRequest(admitId: admitId.value);
      final response = await apiClient.post(
        ApiEndpoints.getDischargeData,
        data: request.toJson(),
        options: dio.Options(
          headers: {'Authorization': token},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }

        if (rawData is Map<String, dynamic>) {
          final res = GetDischargeDataResponse.fromJson(rawData);
          if (res.status == 'success' && res.data != null) {
            _fillDischargeData(res.data!);
          }
        }
      }
    } catch (_) {
      // Fail silently and keep defaults
    } finally {
      isLoading.value = false;
    }
  }

  void _fillDischargeData(DischargeData data) {
    if (data.patientCondition.isNotEmpty) {
      patientCondition.value = data.patientCondition;
    }
    if (data.pastHistory.isNotEmpty) {
      pastHistoryController.text = data.pastHistory;
    }
    if (data.presentComplaints.isNotEmpty) {
      atPresentationComplaintsController.text = data.presentComplaints;
      syncSymptomCheckboxesFromText(data.presentComplaints);
    }
    isDraftSaved.value = true;
  }

  /// Synchronizes symptom checkboxes from complaints text string
  void syncSymptomCheckboxesFromText(String complaintsText) {
    final list = complaintsText
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    selectedSymptoms.clear();
    for (final symptom in standardSymptoms) {
      if (list.contains(symptom.toLowerCase())) {
        selectedSymptoms.add(symptom);
      }
    }
  }

  /// Loads current patient diagnosis from API
  Future<void> loadPatientDiagnosis() async {
    if (patientId.value.isEmpty) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getPatientDiagnosis,
        data: {'patient_id': patientId.value},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic> && rawData['status'] == 'success') {
          final diag = rawData['data']?['diagnosis']?.toString() ?? '';
          if (diag.isNotEmpty) {
            diagnosisText.value = diag;
          }
        }
      }
    } catch (_) {
      // Fail silently
    }
  }

  /// Toggle symptom checkbox and sync with At Presentation Complaints field
  void toggleSymptom(String symptom, bool isChecked) {
    if (isChecked) {
      selectedSymptoms.add(symptom);
    } else {
      selectedSymptoms.remove(symptom);
    }

    final currentText = atPresentationComplaintsController.text.trim();
    List<String> currentList = currentText.isEmpty
        ? []
        : currentText
            .split(',')
            .map((e) => e.trim())
            .filter((e) => e.isNotEmpty)
            .toList();

    if (isChecked) {
      final exists = currentList.any(
        (e) => e.toLowerCase() == symptom.toLowerCase(),
      );
      if (!exists) {
        currentList.add(symptom);
      }
    } else {
      currentList.removeWhere(
        (e) => e.toLowerCase() == symptom.toLowerCase(),
      );
    }

    atPresentationComplaintsController.text = currentList.join(', ');
  }

  /// Navigate to Diagnosis Screen to edit patient diagnosis
  Future<void> openDiagnosisScreen() async {
    await Get.toNamed(
      '/diagnosis',
      arguments: {
        'patientId': patientId.value,
        'bookingId': appointmentId.value,
        'appointmentId': appointmentId.value,
      },
    );
    loadPatientDiagnosis();
  }

  /// Sets active top tab
  void setTab(String tab) {
    activeTab.value = tab;
  }
}

extension _IterableFilter<E> on Iterable<E> {
  Iterable<E> filter(bool Function(E element) test) => where(test);
}
