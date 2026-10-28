import 'dart:convert';
import 'dart:io';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/request/user/discharge_patient_web_request.dart';
import 'package:digi_icu_flutter/models/request/user/get_discharge_data_request.dart';
import 'package:digi_icu_flutter/models/response/doctor/get_last_prescription_discharge_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/institute_doctor_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/ipd_investigation_response.dart';
import 'package:digi_icu_flutter/models/response/user/discharge_patient_web_response.dart';
import 'package:digi_icu_flutter/models/response/user/get_discharge_data_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';

class DischargeSummaryController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  late final SharedPreferences _prefs;

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

  // Upload DS state
  final RxString dischargePath = ''.obs;
  final RxBool isPrepareDsEnabled = true.obs;
  final RxBool isUploadingPdf = false.obs;

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

  // 6. Vitals at Presentation
  final TextEditingController presSystolicController =
      TextEditingController(text: '130');
  final TextEditingController presDiastolicController =
      TextEditingController(text: '80');
  final TextEditingController presPulseController =
      TextEditingController(text: '80');
  final TextEditingController presSpo2Controller =
      TextEditingController(text: '98');

  final RxString presCvs = 'NAD'.obs;
  final TextEditingController presCvsController =
      TextEditingController(text: 'S1S2 Normal, No Murmur');

  final RxString presRs = 'NAD'.obs;
  final TextEditingController presRsController =
      TextEditingController(text: 'AEEBS, No Crepts, No Rhonchi');

  final RxString presCns = 'NAD'.obs;
  final TextEditingController presCnsController =
      TextEditingController(text: 'Conscious, well oriented');

  final RxString presPa = 'NAD'.obs;
  final TextEditingController presPaController =
      TextEditingController(text: 'Soft, Non tender');

  final TextEditingController presOtherVitalsController =
      TextEditingController();

  final RxString presVolume = 'Good'.obs;
  final RxString presPallor = 'No'.obs;
  final RxString presIcterus = 'No'.obs;
  final RxString presCyanosis = 'No'.obs;
  final RxString presGc = 'Fair'.obs;

  // 7. Vitals at Discharge
  final TextEditingController discSystolicController =
      TextEditingController(text: '130');
  final TextEditingController discDiastolicController =
      TextEditingController(text: '80');
  final TextEditingController discPulseController =
      TextEditingController(text: '70');
  final TextEditingController discSpo2Controller =
      TextEditingController(text: '98');

  final RxString discCvs = 'NAD'.obs;
  final TextEditingController discCvsController =
      TextEditingController(text: 'S1S2 Normal, No Murmur');

  final RxString discRs = 'NAD'.obs;
  final TextEditingController discRsController =
      TextEditingController(text: 'AEEBS, No Crepts, No Rhonchi');

  final RxString discCns = 'NAD'.obs;
  final TextEditingController discCnsController =
      TextEditingController(text: 'Conscious, well oriented');

  final RxString discPa = 'NAD'.obs;
  final TextEditingController discPaController =
      TextEditingController(text: 'Soft, Non tender');

  final TextEditingController discOtherVitalsController =
      TextEditingController();

  final RxString discVolume = 'Good'.obs;
  final RxString discPallor = 'No'.obs;
  final RxString discIcterus = 'No'.obs;
  final RxString discCyanosis = 'No'.obs;
  final RxString discGc = 'Good'.obs;

  // 8. Investigations
  final TextEditingController investigationsController =
      TextEditingController();
  final RxList<IpdInvestigationItem> inbetweenInvestigations =
      <IpdInvestigationItem>[].obs;
  final RxBool isLoadingInvestigations = false.obs;

  // 9. ECG
  final RxString ecgSelection = 'Normal'.obs;
  final List<String> ecgOptions = const ['Normal', 'Abnormal', 'Not Available'];
  final TextEditingController ecgDetailsController = TextEditingController();

  // 10. Surgical Procedures
  final RxString surgicalProcedureSelection = 'No'.obs;
  final List<String> yesNoOptions = const ['No', 'Yes'];
  final TextEditingController surgeonNameController = TextEditingController();
  final TextEditingController surgicalProcedureController =
      TextEditingController();

  // 11. Discharge Type & Templates
  static const String regularCourseText =
      'Patient presented with mentioned diagnosis. Patient was treated with antibiotics, IV fluids, and supportive measures. Patient is being discharged in stable condition. Had uneventful hospital stay.';
  static const String amaCourseText =
      'Patient presented with mentioned diagnosis. Patient was treated with antibiotics, IV fluids, and supportive measures. Patient is being discharged in stable condition. Patient had uneventful hospital stay. Patient is being discharged against medical advice on request by relatives with explained prognosis and risks involved.';
  static const String referredCourseText =
      'Patient presented with mentioned diagnosis. Patient was treated with antibiotics, IV fluids, and supportive measures. Patient is being discharged in stable condition. Patient Had uneventful hospital stay. Patient is referred to higher centre for further evaluation and management, risks and prognosis involved in transportation is well explained to relatives.';

  final RxString dischargeTypeSelection = 'Regular'.obs;
  final List<String> dischargeTypeOptions = const [
    'Regular',
    'On Request',
    'Against Medical Advice',
    'Referred',
  ];

  // 12. Course In The Hospital
  final TextEditingController courseInHospitalController =
      TextEditingController(text: regularCourseText);

  // 13. Advice at Discharge
  final TextEditingController adviceAtDischargeController =
      TextEditingController();

  // 14. Discharge Rx
  final RxList<PrescriptionDischargeItem> dischargeRxList =
      <PrescriptionDischargeItem>[].obs;
  final RxBool isLoadingDischargeRx = false.obs;

  // 15. Follow Up (Default 7 Days)
  final RxString followUpDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().add(const Duration(days: 7)))
      .obs;
  final RxString selectedFollowUpOption = '7 Days'.obs;
  final List<String> followUpDaysOptions = const [
    '7 Days',
    '15 Days',
    '1 Month',
    '2 Month',
  ];

  // 16. Institute Doctors
  final RxList<InstituteDoctorItem> instituteDoctors =
      <InstituteDoctorItem>[].obs;
  final RxSet<String> selectedInstituteDoctorNames = <String>{}.obs;
  final RxBool isLoadingInstituteDoctors = false.obs;

  // 17. Prepared By
  final RxString preparedByName = ''.obs;

  // User Info & Action Progress
  final RxBool isSavingDischarge = false.obs;
  final RxString loggedInUserName = ''.obs;
  final RxString loggedInUserId = ''.obs;
  final RxString loggedInUserType = ''.obs;

  // Standard Option Lists
  final List<String> nadOtherOptions = const ['NAD', 'Other'];
  final List<String> volumeOptions = const [
    'Good',
    'Low',
    'Feeble',
    'Not Palpable',
  ];
  final List<String> signOptions = const ['No', '+', '++'];
  final List<String> gcOptions = const [
    'Good',
    'Conscious',
    'Fair',
    'Bad',
    'Worst',
    'Unconscious',
    'Brought dead',
  ];

  // Draft saved state
  final RxBool isDraftSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.isRegistered<SharedPreferences>()
        ? Get.find<SharedPreferences>()
        : Get.find<StorageService>().prefs;
    _parseArguments();
    _loadUserInfo();
    loadDischargeData();
    loadPatientDiagnosis();
    loadInbetweenInvestigations();
    loadDischargeRx();
    loadInstituteDoctors();
  }

  Future<void> _loadUserInfo() async {
    try {
      final prefs = _prefs;
      loggedInUserName.value =
          prefs.getString(AppConstants.prefUserName) ?? '';
      loggedInUserId.value = prefs.getString(AppConstants.prefUserId) ?? '';
      loggedInUserType.value =
          prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';

      if (preparedByName.value.isEmpty && loggedInUserName.value.isNotEmpty) {
        preparedByName.value = loggedInUserName.value;
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    pastHistoryController.dispose();
    atPresentationComplaintsController.dispose();
    presSystolicController.dispose();
    presDiastolicController.dispose();
    presPulseController.dispose();
    presSpo2Controller.dispose();
    presCvsController.dispose();
    presRsController.dispose();
    presCnsController.dispose();
    presPaController.dispose();
    presOtherVitalsController.dispose();
    discSystolicController.dispose();
    discDiastolicController.dispose();
    discPulseController.dispose();
    discSpo2Controller.dispose();
    discCvsController.dispose();
    discRsController.dispose();
    discCnsController.dispose();
    discPaController.dispose();
    discOtherVitalsController.dispose();
    investigationsController.dispose();
    ecgDetailsController.dispose();
    surgeonNameController.dispose();
    surgicalProcedureController.dispose();
    courseInHospitalController.dispose();
    adviceAtDischargeController.dispose();
    super.onClose();
  }

  void setDischargeType(String val) {
    dischargeTypeSelection.value = val;
    if (val == 'Against Medical Advice') {
      courseInHospitalController.text = amaCourseText;
    } else if (val == 'Referred') {
      courseInHospitalController.text = referredCourseText;
    } else {
      courseInHospitalController.text = regularCourseText;
    }
  }

  void setPresCvs(String val) {
    presCvs.value = val;
    if (val == 'NAD') {
      presCvsController.text = 'S1S2 Normal, No Murmur';
    } else {
      presCvsController.text = '';
    }
  }

  void setPresRs(String val) {
    presRs.value = val;
    if (val == 'NAD') {
      presRsController.text = 'AEEBS, No Crepts, No Rhonchi';
    } else {
      presRsController.text = '';
    }
  }

  void setPresCns(String val) {
    presCns.value = val;
    if (val == 'NAD') {
      presCnsController.text = 'Conscious, well oriented';
    } else {
      presCnsController.text = '';
    }
  }

  void setPresPa(String val) {
    presPa.value = val;
    if (val == 'NAD') {
      presPaController.text = 'Soft, Non tender';
    } else {
      presPaController.text = '';
    }
  }

  void setDiscCvs(String val) {
    discCvs.value = val;
    if (val == 'NAD') {
      discCvsController.text = 'S1S2 Normal, No Murmur';
    } else {
      discCvsController.text = '';
    }
  }

  void setDiscRs(String val) {
    discRs.value = val;
    if (val == 'NAD') {
      discRsController.text = 'AEEBS, No Crepts, No Rhonchi';
    } else {
      discRsController.text = '';
    }
  }

  void setDiscCns(String val) {
    discCns.value = val;
    if (val == 'NAD') {
      discCnsController.text = 'Conscious, well oriented';
    } else {
      discCnsController.text = '';
    }
  }

  void setDiscPa(String val) {
    discPa.value = val;
    if (val == 'NAD') {
      discPaController.text = 'Soft, Non tender';
    } else {
      discPaController.text = '';
    }
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
      final prefs = _prefs;
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

    // Presentation Vitals
    if (data.systolicBp.isNotEmpty) {
      presSystolicController.text = data.systolicBp;
    }
    if (data.diastolicBp.isNotEmpty) {
      presDiastolicController.text = data.diastolicBp;
    }
    if (data.pulseRate.isNotEmpty) {
      presPulseController.text = data.pulseRate;
    }
    if (data.spo2.isNotEmpty) {
      presSpo2Controller.text = data.spo2;
    }
    if (data.cvs.isNotEmpty) {
      presCvs.value = data.cvs;
    }
    if (data.cvsValue.isNotEmpty) {
      presCvsController.text = data.cvsValue;
    }
    if (data.rs.isNotEmpty) {
      presRs.value = data.rs;
    }
    if (data.rsValue.isNotEmpty) {
      presRsController.text = data.rsValue;
    }
    if (data.cns.isNotEmpty) {
      presCns.value = data.cns;
    }
    if (data.cnsValue.isNotEmpty) {
      presCnsController.text = data.cnsValue;
    }
    if (data.pa.isNotEmpty) {
      presPa.value = data.pa;
    }
    if (data.paValue.isNotEmpty) {
      presPaController.text = data.paValue;
    }
    if (data.vitalsPresentOthers.isNotEmpty) {
      presOtherVitalsController.text = data.vitalsPresentOthers;
    }
    if (data.volume.isNotEmpty) {
      presVolume.value = data.volume;
    }
    if (data.pallor.isNotEmpty) {
      presPallor.value = data.pallor;
    }
    if (data.icterus.isNotEmpty) {
      presIcterus.value = data.icterus;
    }
    if (data.cyanosis.isNotEmpty) {
      presCyanosis.value = data.cyanosis;
    }
    if (data.gc.isNotEmpty) {
      presGc.value = data.gc;
    }

    // Discharge Vitals
    if (data.dischargeSystolicBp.isNotEmpty) {
      discSystolicController.text = data.dischargeSystolicBp;
    }
    if (data.dischargeDiastolicBp.isNotEmpty) {
      discDiastolicController.text = data.dischargeDiastolicBp;
    }
    if (data.dischargePulseRate.isNotEmpty) {
      discPulseController.text = data.dischargePulseRate;
    }
    if (data.dischargeSpo2.isNotEmpty) {
      discSpo2Controller.text = data.dischargeSpo2;
    }
    if (data.dischargeCvs.isNotEmpty) {
      discCvs.value = data.dischargeCvs;
    }
    if (data.dischargeCvsValue.isNotEmpty) {
      discCvsController.text = data.dischargeCvsValue;
    }
    if (data.dischargeRs.isNotEmpty) {
      discRs.value = data.dischargeRs;
    }
    if (data.dischargeRsValue.isNotEmpty) {
      discRsController.text = data.dischargeRsValue;
    }
    if (data.dischargeCns.isNotEmpty) {
      discCns.value = data.dischargeCns;
    }
    if (data.dischargeCnsValue.isNotEmpty) {
      discCnsController.text = data.dischargeCnsValue;
    }
    if (data.dischargePa.isNotEmpty) {
      discPa.value = data.dischargePa;
    }
    if (data.dischargePaValue.isNotEmpty) {
      discPaController.text = data.dischargePaValue;
    }
    if (data.vitalsDischargeOthers.isNotEmpty) {
      discOtherVitalsController.text = data.vitalsDischargeOthers;
    }
    if (data.dischargeVolume.isNotEmpty) {
      discVolume.value = data.dischargeVolume;
    }
    if (data.dischargePallor.isNotEmpty) {
      discPallor.value = data.dischargePallor;
    }
    if (data.dischargeIcterus.isNotEmpty) {
      discIcterus.value = data.dischargeIcterus;
    }
    if (data.dischargeCyanosis.isNotEmpty) {
      discCyanosis.value = data.dischargeCyanosis;
    }
    if (data.dischargeGc.isNotEmpty) {
      discGc.value = data.dischargeGc;
    }

    // Investigations
    if (data.investigations.isNotEmpty) {
      investigationsController.text = data.investigations;
    }

    // ECG
    if (data.ecg.isNotEmpty) {
      ecgSelection.value = data.ecg == 'NA' ? 'Not Available' : data.ecg;
    }
    if (data.ecgDetails.isNotEmpty) {
      ecgDetailsController.text = data.ecgDetails;
    }

    // Surgical Procedure
    if (data.surgicalProcedure.isNotEmpty) {
      surgicalProcedureSelection.value = data.surgicalProcedure;
    }
    if (data.surgenName.isNotEmpty) {
      surgeonNameController.text = data.surgenName;
    }
    if (data.procedurePerformed.isNotEmpty) {
      surgicalProcedureController.text = data.procedurePerformed;
    }

    // Discharge Type
    if (data.dischargeType.isNotEmpty) {
      dischargeTypeSelection.value = data.dischargeType;
    }

    // Course in Hospital
    if (data.courceInHospital.isNotEmpty) {
      courseInHospitalController.text = data.courceInHospital;
    }

    // Advice at Discharge
    if (data.dischargeAdvice.isNotEmpty) {
      adviceAtDischargeController.text = data.dischargeAdvice;
    }

    // Follow Up
    if (data.followDate.isNotEmpty) {
      try {
        final parsed = DateFormat('yyyy-MM-dd').parse(data.followDate);
        followUpDate.value = DateFormat('dd-MM-yyyy').format(parsed);
      } catch (_) {
        followUpDate.value = data.followDate;
      }
    }

    // Institute Doctors
    if (data.instituteDoctors.isNotEmpty) {
      final docs = data.instituteDoctors
          .split(',')
          .map((e) => e.trim())
          .filter((e) => e.isNotEmpty);
      selectedInstituteDoctorNames.addAll(docs);
    }

    // Prepared By
    if (data.preparedBy.isNotEmpty) {
      preparedByName.value = data.preparedBy;
    } else if (preparedByName.value.isEmpty &&
        loggedInUserName.value.isNotEmpty) {
      preparedByName.value = loggedInUserName.value;
    }

    // Discharge PDF Path
    if (data.dischargePath.isNotEmpty) {
      dischargePath.value = data.dischargePath;
      isPrepareDsEnabled.value = false;
      activeTab.value = 'upload';
    } else {
      dischargePath.value = '';
      isPrepareDsEnabled.value = true;
    }

    isDraftSaved.value = true;
  }

  /// Loads in-between investigations from admission to today
  Future<void> loadInbetweenInvestigations() async {
    if (admitId.value.isEmpty) {
      return;
    }

    try {
      isLoadingInvestigations.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getInvestigationsForIpdAdmit,
        data: {'admit_id': admitId.value},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          final res = IpdInvestigationResponse.fromJson(rawData);
          if (res.status == 'success') {
            inbetweenInvestigations.assignAll(res.data);
          }
        }
      }
    } catch (_) {
      // Fail silently
    } finally {
      isLoadingInvestigations.value = false;
    }
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
      final prefs = _prefs;
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

  /// Loads Discharge Rx list
  Future<void> loadDischargeRx() async {
    if (admitId.value.isEmpty) return;
    try {
      isLoadingDischargeRx.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getLastPrescriptionForDischarge,
        data: {'admit_id': admitId.value},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          final res = GetLastPrescriptionDischargeResponse.fromJson(rawData);
          if (res.status == 'success') {
            dischargeRxList.assignAll(res.data);
          }
        }
      }
    } catch (_) {
    } finally {
      isLoadingDischargeRx.value = false;
    }
  }

  /// Delete a prescription item from discharge
  Future<bool> deleteDischargePrescription(String medicineId) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.deleteDischargePrescription,
        data: {'medicine_id': medicineId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic> && rawData['status'] == 'success') {
          await loadDischargeRx();
          AppSnackbars.showSuccess(
            'success'.tr,
            rawData['msg']?.toString() ?? 'ds_prescription_deleted'.tr,
          );
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  /// Add or Update manual Rx in discharge summary
  Future<bool> saveManualRx({
    String? manualRxId,
    required String content,
  }) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final finalId = manualRxId ??
          dischargeRxList.firstWhereOrNull((item) => item.isManual)?.id;

      dio.Response response;
      if (finalId != null && finalId.isNotEmpty) {
        // Update existing manual Rx
        final formData = dio.FormData.fromMap({
          'manual_rx_id': finalId,
          'manual_rx': content,
        });
        response = await apiClient.post(
          ApiEndpoints.updateManualRx,
          data: formData,
          options: dio.Options(headers: {'Authorization': token}),
        );
      } else {
        // Add new manual Rx
        final formData = dio.FormData.fromMap({
          'admit_id': admitId.value,
          'patient_id': patientId.value,
          'appointment_id': appointmentId.value,
          'manual_rx': content,
        });
        response = await apiClient.post(
          ApiEndpoints.addDischargePrescription,
          data: formData,
          options: dio.Options(headers: {'Authorization': token}),
        );
      }

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic> && rawData['status'] == 'success') {
          await loadDischargeRx();
          AppSnackbars.showSuccess(
            'success'.tr,
            rawData['msg']?.toString() ??
                (finalId != null
                    ? 'ds_prescription_updated'.tr
                    : 'ds_prescription_added'.tr),
          );
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  /// Sets follow up date from quick days radio option
  void setFollowUpDays(String option, int days) {
    selectedFollowUpOption.value = option;
    final targetDate = DateTime.now().add(Duration(days: days));
    followUpDate.value = DateFormat('dd-MM-yyyy').format(targetDate);
  }

  /// Sets manual follow up date from calendar picker
  void setManualFollowUpDate(DateTime date) {
    selectedFollowUpOption.value = '';
    followUpDate.value = DateFormat('dd-MM-yyyy').format(date);
  }

  /// Load Institute Doctors
  Future<void> loadInstituteDoctors() async {
    if (instituteId.value.isEmpty) return;
    try {
      isLoadingInstituteDoctors.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getDoctorListAdmin,
        data: {
          'page_no': 1,
          'user_id': instituteId.value,
          'user_type': 'Institute',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          final res = InstituteDoctorResponse.fromJson(rawData);
          if (res.status == 'success') {
            instituteDoctors.assignAll(res.data);
          }
        }
      }
    } catch (_) {
    } finally {
      isLoadingInstituteDoctors.value = false;
    }
  }

  /// Toggle Institute Doctor selection
  void toggleInstituteDoctor(String name, bool isSelected) {
    if (isSelected) {
      selectedInstituteDoctorNames.add(name);
    } else {
      selectedInstituteDoctorNames.remove(name);
    }
  }

  /// Set prepared by name
  void setPreparedByName(String name) {
    preparedByName.value = name;
  }

  /// Show dialog to edit Prepared By doctor/staff name
  void showPreparedByDialog(BuildContext context) {
    final textController = TextEditingController(text: preparedByName.value);

    AppDialog.show(
      title: 'ds_prepared_by_dialog_title'.tr,
      body: AppLabeledTextField(
        label: 'ds_enter_prepared_by_name'.tr,
        controller: textController,
      ),
      confirmLabel: 'submit'.tr,
      cancelLabel: 'cancel'.tr,
      onConfirm: () {
        final name = textController.text.trim();
        if (name.isNotEmpty) {
          setPreparedByName(name);
          Get.back();
        } else {
          AppSnackbars.showWarning(
            'warning_title'.tr,
            'ds_name_cannot_be_empty'.tr,
          );
        }
      },
      onCancel: () => Get.back(),
    );
  }

  /// Builds DischargePatientWebRequest model from current form state
  Future<DischargePatientWebRequest> buildDischargeRequest({
    required bool isPrintDraft,
    required bool isFinalDischarge,
  }) async {
    final prefs = _prefs;
    final userId = loggedInUserId.value.isNotEmpty
        ? loggedInUserId.value
        : (prefs.getString(AppConstants.prefUserId) ?? '');
    final userType = loggedInUserType.value.isNotEmpty
        ? loggedInUserType.value
        : (prefs.getString(AppConstants.prefLoginType) ?? 'Doctor');
    final userName = preparedByName.value.isNotEmpty
        ? preparedByName.value
        : (prefs.getString(AppConstants.prefUserName) ?? 'Doctor');

    String formattedFollowDate = followUpDate.value.trim();
    if (formattedFollowDate.isNotEmpty) {
      try {
        final parsed = DateFormat('dd-MM-yyyy').parse(formattedFollowDate);
        formattedFollowDate = DateFormat('yyyy-MM-dd').format(parsed);
      } catch (_) {}
    }

    return DischargePatientWebRequest(
      admitId: admitId.value,
      patientCondition: patientCondition.value,
      gc: presGc.value,
      pastHistory: pastHistoryController.text.trim(),
      investigations: investigationsController.text.trim(),
      presentComplaints: atPresentationComplaintsController.text.trim(),
      systolicBp: presSystolicController.text.trim(),
      diastolicBp: presDiastolicController.text.trim(),
      pulseRate: presPulseController.text.trim(),
      spo2: presSpo2Controller.text.trim(),
      cvs: presCvs.value,
      cvsValue: presCvsController.text.trim(),
      rs: presRs.value,
      rsValue: presRsController.text.trim(),
      cns: presCns.value,
      cnsValue: presCnsController.text.trim(),
      pa: presPa.value,
      paValue: presPaController.text.trim(),
      vitalsPresentOthers: presOtherVitalsController.text.trim(),
      volume: presVolume.value,
      pallor: presPallor.value,
      icterus: presIcterus.value,
      cyanosis: presCyanosis.value,
      dischargeSystolicBp: discSystolicController.text.trim(),
      dischargeDiastolicBp: discDiastolicController.text.trim(),
      dischargePulseRate: discPulseController.text.trim(),
      dischargeSpo2: discSpo2Controller.text.trim(),
      dischargeCvs: discCvs.value,
      dischargeCvsValue: discCvsController.text.trim(),
      dischargeRs: discRs.value,
      dischargeRsValue: discRsController.text.trim(),
      dischargeCns: discCns.value,
      dischargeCnsValue: discCnsController.text.trim(),
      dischargePa: discPa.value,
      dischargePaValue: discPaController.text.trim(),
      vitalsDischargeOthers: discOtherVitalsController.text.trim(),
      dischargeVolume: discVolume.value,
      dischargePallor: discPallor.value,
      dischargeIcterus: discIcterus.value,
      dischargeCyanosis: discCyanosis.value,
      dischargeGc: discGc.value,
      ecg: ecgSelection.value == 'Not Available' ? 'NA' : ecgSelection.value,
      ecgDetails: ecgDetailsController.text.trim(),
      surgicalProcedure: surgicalProcedureSelection.value,
      surgenName: surgeonNameController.text.trim(),
      procedurePerformed: surgicalProcedureController.text.trim(),
      dischargeAdvice: adviceAtDischargeController.text.trim(),
      followDate: formattedFollowDate,
      dischargeType: dischargeTypeSelection.value,
      courceInHospital: courseInHospitalController.text.trim(),
      instituteDoctors: selectedInstituteDoctorNames.join(', '),
      preparedBy: userName,
      dischargeBy: userType,
      dischargeById: userId,
      isFinalDischarge: isFinalDischarge ? 'true' : 'false',
      isPrintDraft: isPrintDraft ? 'true' : 'false',
    );
  }

  /// Common API submission handler for discharge
  Future<DischargePatientWebResponse?> _submitDischargePatientWeb(
    DischargePatientWebRequest request,
  ) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.dischargePatientWeb,
        data: request.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          return DischargePatientWebResponse.fromJson(rawData);
        }
      }
    } on dio.DioException catch (e) {
      final errorMsg = e.response?.data?['msg']?.toString() ??
          e.message ??
          'Connection error';
      AppSnackbars.showError('error'.tr, errorMsg);
    } catch (e) {
      AppSnackbars.showError('error'.tr, e.toString());
    }
    return null;
  }

  /// Print Draft functionality: submits draft and opens returned receipt PDF
  Future<void> printDraft() async {
    try {
      isSavingDischarge.value = true;
      final request = await buildDischargeRequest(
        isPrintDraft: true,
        isFinalDischarge: false,
      );

      final res = await _submitDischargePatientWeb(request);
      if (res != null && res.status == 'success') {
        final receiptPath = res.receiptPath;
        if (receiptPath.isNotEmpty) {
          final url = receiptPath.startsWith('http')
              ? receiptPath
              : '${AppConstants.baseUrl}patient_reports/$receiptPath';
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            AppSnackbars.showError('error'.tr, 'Could not open PDF: $url');
          }
        } else {
          AppSnackbars.showInfo(
            'info_title'.tr,
            res.msg.isNotEmpty ? res.msg : 'Draft generated successfully',
          );
        }
      } else if (res != null) {
        AppSnackbars.showError('error'.tr, res.msg.isNotEmpty ? res.msg : 'Something went wrong!');
      }
    } finally {
      isSavingDischarge.value = false;
    }
  }

  /// Save Draft functionality: submits draft, updates state, redirects and shows success snackbar
  Future<void> saveDraft() async {
    try {
      isSavingDischarge.value = true;
      final request = await buildDischargeRequest(
        isPrintDraft: false,
        isFinalDischarge: false,
      );

      final res = await _submitDischargePatientWeb(request);
      if (res != null && res.status == 'success') {
        isDraftSaved.value = true;
        final msg = res.msg.isNotEmpty ? res.msg : 'ds_draft_saved_success'.tr;
        Get.back(result: true);
        Future.delayed(const Duration(milliseconds: 100), () {
          AppSnackbars.showSuccess('success'.tr, msg);
        });
      } else if (res != null) {
        AppSnackbars.showError('error'.tr, res.msg.isNotEmpty ? res.msg : 'Something went wrong!');
      }
    } finally {
      isSavingDischarge.value = false;
    }
  }

  /// Final Discharge Summary: validates diagnosis, asks confirmation, submits final DS, redirects, opens PDF and shows snackbar
  Future<void> finalizeDischarge() async {
    final diag = diagnosisText.value.trim();
    if (diag.isEmpty || diag == '-') {
      AppSnackbars.showWarning('warning_title'.tr, 'ds_add_diagnosis_warning'.tr);
      return;
    }

    final confirmed = await AppDialog.show<bool>(
      title: 'ds_final_discharge_confirm_title'.tr,
      body: Text(
        'ds_final_discharge_confirm_msg'.tr,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 14,
        ),
      ),
      confirmLabel: 'ds_yes_opt'.tr,
      cancelLabel: 'no_opt'.tr,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed != true) return;

    try {
      isSavingDischarge.value = true;
      final request = await buildDischargeRequest(
        isPrintDraft: true,
        isFinalDischarge: true,
      );

      final res = await _submitDischargePatientWeb(request);
      if (res != null && res.status == 'success') {
        final receiptPath = res.receiptPath;
        if (receiptPath.isNotEmpty) {
          final url = receiptPath.startsWith('http')
              ? receiptPath
              : '${AppConstants.baseUrl}patient_reports/$receiptPath';
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
        final msg = res.msg.isNotEmpty ? res.msg : 'ds_discharge_success'.tr;
        Get.back(result: true);
        Future.delayed(const Duration(milliseconds: 100), () {
          AppSnackbars.showSuccess('success'.tr, msg);
        });
      } else if (res != null) {
        AppSnackbars.showError('error'.tr, res.msg.isNotEmpty ? res.msg : 'Something went wrong!');
      }
    } finally {
      isSavingDischarge.value = false;
    }
  }

  /// Handles Prepare DS tab selection with disabled validation check
  void onPrepareDsTabSelected() {
    if (!isPrepareDsEnabled.value) {
      AppSnackbars.showInfo(
        'info_title'.tr,
        'ds_prepare_disabled_hint'.tr,
      );
      return;
    }
    activeTab.value = 'prepare';
  }

  /// Handles Upload DS tab selection
  void onUploadDsTabSelected(BuildContext context) {
    if (dischargePath.value.isNotEmpty) {
      activeTab.value = 'upload';
    } else {
      if (isDraftSaved.value) {
        showWarningDialog(
          context: context,
          message: 'ds_warning_draft_saved'.tr,
          onConfirm: () {
            openReportFolder();
          },
        );
      } else {
        openReportFolder();
      }
    }
  }

  /// Handles adding or replacing an uploaded PDF
  void onAddOrReplacePdfClicked(BuildContext context) {
    if (isDraftSaved.value || dischargePath.value.isNotEmpty) {
      showWarningDialog(
        context: context,
        message: dischargePath.value.isNotEmpty
            ? 'ds_warning_pdf_exists'.tr
            : 'ds_warning_draft_saved'.tr,
        onConfirm: () => openReportFolder(),
      );
    } else {
      openReportFolder();
    }
  }

  /// Opens the Reports screen
  Future<void> openReportFolder() async {
    await Get.toNamed(
      '/serving-patient',
      arguments: {
        'patientId': patientId.value,
        'fullName': patientName.value,
        'age': age.value,
        'gender': gender.value,
        'mhcId': mhcId.value,
        'admitId': admitId.value,
        'initialTab': 'Reports',
        'reportName': 'Discharge Summary',
        'isFrom': 'discharge_summary',
        'isFromID': admitId.value,
      },
    );

    // Always reload after returning — the upload may have succeeded
    activeTab.value = 'upload';
    await loadDischargeData();
  }

  /// Standard warning confirmation dialog
  void showWarningDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
  }) {
    AppDialog.show(
      title: 'warning_title'.tr,
      body: Text(
        message,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 14,
        ),
      ),
      confirmLabel: 'ds_yes_opt'.tr,
      cancelLabel: 'no_opt'.tr,
      onConfirm: () {
        Get.back();
        onConfirm();
      },
      onCancel: () => Get.back(),
    );
  }

  /// Launches system file picker to select a PDF or image
  Future<void> pickAndUploadPdf() async {
    try {
      final platformFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (platformFile != null &&
          platformFile.path != null &&
          platformFile.path!.isNotEmpty) {
        await uploadDischargeSummaryPdf(File(platformFile.path!));
      }
    } catch (e) {
      AppSnackbars.showError('error'.tr, e.toString());
    }
  }

  /// Uploads chosen PDF to api/v2/User/upload_discharge_summary_pdf
  Future<void> uploadDischargeSummaryPdf(File file) async {
    try {
      isUploadingPdf.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userId = loggedInUserId.value.isNotEmpty
          ? loggedInUserId.value
          : (prefs.getString(AppConstants.prefUserId) ?? '');
      final userType = loggedInUserType.value.isNotEmpty
          ? loggedInUserType.value
          : (prefs.getString(AppConstants.prefLoginType) ?? 'Doctor');

      final fileName = file.path.split(Platform.pathSeparator).last;

      final formData = dio.FormData.fromMap({
        'admit_id': admitId.value,
        'patient_id': patientId.value,
        'uploaded_by': userType,
        'uploaded_by_id': userId,
        'discharge_pdf': await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await apiClient.post(
        ApiEndpoints.uploadDischargeSummaryPdf,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.data != null) {
        dynamic rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          if (rawData['status'] == 'success') {
            final receiptPath = rawData['receipt_path']?.toString() ?? fileName;
            dischargePath.value = receiptPath;
            isPrepareDsEnabled.value = false;
            activeTab.value = 'upload';
            AppSnackbars.showSuccess(
              'success'.tr,
              rawData['msg']?.toString() ?? 'ds_pdf_uploaded_success'.tr,
            );
            await loadDischargeData();
          } else {
            AppSnackbars.showError(
              'error'.tr,
              rawData['msg']?.toString() ?? 'Failed to upload discharge summary',
            );
          }
        }
      }
    } on dio.DioException catch (e) {
      final errorMsg = e.response?.data?['msg']?.toString() ??
          e.message ??
          'Upload error';
      AppSnackbars.showError('error'.tr, errorMsg);
    } catch (e) {
      AppSnackbars.showError('error'.tr, e.toString());
    } finally {
      isUploadingPdf.value = false;
    }
  }

  /// Constructs full URL to view/download discharge summary PDF
  String get fullDischargePdfUrl {
    final path = dischargePath.value;
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '${AppConstants.patientReportUrl}$path';
  }

  /// Opens the uploaded discharge PDF in an external browser or viewer
  Future<void> openPdf() async {
    final url = fullDischargePdfUrl;
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbars.showError('error'.tr, 'Could not open PDF: $url');
    }
  }

  /// Shares the discharge summary PDF link
  Future<void> sharePdf() async {
    final url = fullDischargePdfUrl;
    if (url.isEmpty) return;
    try {
      await SharePlus.instance.share(
        ShareParams(
          uri: Uri.tryParse(url),
          subject: 'Discharge Summary',
        ),
      );
    } catch (e) {
      AppSnackbars.showError('error'.tr, e.toString());
    }
  }

  /// Sets active top tab
  void setTab(String tab) {
    activeTab.value = tab;
  }
}

extension _IterableFilter<E> on Iterable<E> {
  Iterable<E> filter(bool Function(E element) test) => where(test);
}
