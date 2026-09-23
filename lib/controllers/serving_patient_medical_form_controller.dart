import 'dart:convert';
import 'dart:io';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/models/response/doctors/medical_form_detail_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class ServingPatientMedicalFormController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();

  // Context info
  final formId = ''.obs;
  final patientId = ''.obs;
  final patientName = ''.obs;
  final patientGender = ''.obs;
  final patientAge = ''.obs;
  final isLoading = false.obs;

  // ================= SECTION 1: CLINICAL HISTORY =================
  // 1. Hypertension
  final hasHypertension = 'No'.obs; // Yes, No, Don't Know
  final htnYears = 'Select'.obs;
  final htnOnMedicine = 'No'.obs;
  final htnMedicineRegular = 'No'.obs;
  final htnMedCount = 0.obs;
  final htnMedName1Ctrl = TextEditingController();
  final htnMedName2Ctrl = TextEditingController();
  final htnMedName3Ctrl = TextEditingController();
  final htnMedFreq1 = 'One Time'.obs;
  final htnMedFreq2 = 'One Time'.obs;
  final htnMedFreq3 = 'One Time'.obs;
  final htnReports = <File>[].obs;
  final htnNetworkImages = <String>[].obs;

  // 2. Diabetes
  final hasDiabetes = 'No'.obs;
  final diabetesYears = 'Select'.obs;
  final diabetesOnMedicine = 'No'.obs;
  final diabetesMedicineRegular = 'No'.obs;
  final diabetesMedCount = 0.obs;
  final diabetesMedName1Ctrl = TextEditingController();
  final diabetesMedName2Ctrl = TextEditingController();
  final diabetesMedName3Ctrl = TextEditingController();
  final diabetesMedFreq1 = 'One Time'.obs;
  final diabetesMedFreq2 = 'One Time'.obs;
  final diabetesMedFreq3 = 'One Time'.obs;
  final diabetesReports = <File>[].obs;
  final diabetesNetworkImages = <String>[].obs;

  // 3. Thyroid
  final hasThyroid = 'No'.obs;
  final thyroidYears = 'Select'.obs;
  final thyroidOnMedicine = 'No'.obs;
  final thyroidMedicineRegular = 'No'.obs;
  final thyroidMedCount = 0.obs;
  final thyroidMedName1Ctrl = TextEditingController();
  final thyroidMedName2Ctrl = TextEditingController();
  final thyroidMedName3Ctrl = TextEditingController();
  final thyroidMedFreq1 = 'One Time'.obs;
  final thyroidMedFreq2 = 'One Time'.obs;
  final thyroidMedFreq3 = 'One Time'.obs;
  final thyroidReports = <File>[].obs;
  final thyroidNetworkImages = <String>[].obs;

  // 4. Cholesterol & 5. Asthma
  final hasCholesterol = 'No'.obs;
  final hasAsthma = 'No'.obs;

  // 6. Pregnancy details
  final isPregnant = 'No'.obs;
  final duringPregnancy = 'None'.obs;

  // ================= SECTION 2: PAST HISTORY =================
  // 1. Heart Attack
  final hasHeartAttack = 'No'.obs;
  final heartAttackYears = 'Select'.obs;
  final heartAttackOnMedicine = 'No'.obs;
  final heartAttackMedCount = 0.obs;
  final heartAttackMedName1Ctrl = TextEditingController();
  final heartAttackMedName2Ctrl = TextEditingController();
  final heartAttackMedName3Ctrl = TextEditingController();
  final heartAttackMedFreq1 = 'One Time'.obs;
  final heartAttackMedFreq2 = 'One Time'.obs;
  final heartAttackMedFreq3 = 'One Time'.obs;
  final heartAttackReports = <File>[].obs;
  final heartAttackNetworkImages = <String>[].obs;

  // 2. Stroke
  final hasStroke = 'No'.obs;
  final strokeYears = 'Select'.obs;
  final strokeOnMedicine = 'No'.obs;
  final strokeMedCount = 0.obs;
  final strokeMedName1Ctrl = TextEditingController();
  final strokeMedName2Ctrl = TextEditingController();
  final strokeMedName3Ctrl = TextEditingController();
  final strokeMedFreq1 = 'One Time'.obs;
  final strokeMedFreq2 = 'One Time'.obs;
  final strokeMedFreq3 = 'One Time'.obs;
  final strokeReports = <File>[].obs;
  final strokeNetworkImages = <String>[].obs;

  // 3. Kidney Failure
  final hasKidneyFailure = 'No'.obs;
  final kidneyFailureYears = 'Select'.obs;
  final kidneyFailureOnMedicine = 'No'.obs;
  final kidneyFailureMedCount = 0.obs;
  final kidneyFailureMedName1Ctrl = TextEditingController();
  final kidneyFailureMedName2Ctrl = TextEditingController();
  final kidneyFailureMedName3Ctrl = TextEditingController();
  final kidneyFailureMedFreq1 = 'One Time'.obs;
  final kidneyFailureMedFreq2 = 'One Time'.obs;
  final kidneyFailureMedFreq3 = 'One Time'.obs;
  final kidneyFailureReports = <File>[].obs;
  final kidneyFailureNetworkImages = <String>[].obs;

  // 4. Angioplasty
  final hasAngioplasty = 'No'.obs;
  final angioplastyYears = 'Select'.obs;
  final angioplastyOnMedicine = 'No'.obs;
  final angioplastyMedCount = 0.obs;
  final angioplastyMedName1Ctrl = TextEditingController();
  final angioplastyMedName2Ctrl = TextEditingController();
  final angioplastyMedName3Ctrl = TextEditingController();
  final angioplastyMedFreq1 = 'One Time'.obs;
  final angioplastyMedFreq2 = 'One Time'.obs;
  final angioplastyMedFreq3 = 'One Time'.obs;
  final angioplastyReports = <File>[].obs;
  final angioplastyNetworkImages = <String>[].obs;

  // 5. Bypass Surgery
  final hasBypass = 'No'.obs;
  final bypassYears = 'Select'.obs;
  final bypassOnMedicine = 'No'.obs;
  final bypassMedCount = 0.obs;
  final bypassMedName1Ctrl = TextEditingController();
  final bypassMedName2Ctrl = TextEditingController();
  final bypassMedName3Ctrl = TextEditingController();
  final bypassMedFreq1 = 'One Time'.obs;
  final bypassMedFreq2 = 'One Time'.obs;
  final bypassMedFreq3 = 'One Time'.obs;
  final bypassReports = <File>[].obs;
  final bypassNetworkImages = <String>[].obs;

  // 6. Allergy to Medicines
  final hasAllergy = 'No'.obs;
  final allergyMedCount = 0.obs;
  final allergyMedName1Ctrl = TextEditingController();
  final allergyMedName2Ctrl = TextEditingController();
  final allergyMedName3Ctrl = TextEditingController();

  // 7. Bleeding Tendency
  final hasBleedingTendency = 'No'.obs;

  // 8. Other Surgery / Treatment
  final hasOtherSurgery = 'No'.obs;
  final surgeryMedCount = 0.obs;
  final surgeryName1Ctrl = TextEditingController();
  final surgeryName2Ctrl = TextEditingController();
  final surgeryName3Ctrl = TextEditingController();

  // Section 2 Extensions
  final heartAttackStatus = 'No Records'.obs; // Acute, Recent, Old, No Records
  final strokeStatus = 'No Records'.obs; // Acute, Recent, Old, No Records
  final kidneyFailureStatus = 'No Records'.obs; // Acute, Chronic, No Records
  final kidneyFailureDialysis = 'Regular'.obs; // Regular, Sometimes
  final angioplastyStents = 'I'.obs; // I, II, III, IV
  final angioplastyBrilinta = 'No'.obs; // Yes, No
  final angioplastyClopilet = 'No'.obs; // Yes, No
  final angioplastyPrasita = 'No'.obs; // Yes, No
  final allergicToCardiacDiabetic = 'No'.obs; // Yes, No
  final bleedingSeverity = 'Mild'.obs; // Mild, Moderate, Severe
  final canAspirinContinue = 'No'.obs; // Yes, No

  // Surgery Type Checkboxes
  final surgeryAbdominal = false.obs;
  final surgeryNeuro = false.obs;
  final surgeryCardiac = false.obs;
  final surgeryOrtho = false.obs;
  final surgeryGynaec = false.obs;
  final surgeryVascular = false.obs;
  final surgeryCancer = false.obs;
  final surgeryTumor = false.obs;
  final surgeryENT = false.obs;

  // ================= SECTION 3: FAMILY HISTORY =================
  // 1. Family Heart Attack
  final hasFamilyHeartAttack = 'No'.obs;
  final famHeartAttackFather = false.obs;
  final famHeartAttackFatherAgeCtrl = TextEditingController();
  final famHeartAttackMother = false.obs;
  final famHeartAttackMotherAgeCtrl = TextEditingController();
  final famHeartAttackBrother = false.obs;
  final famHeartAttackBrotherAgeCtrl = TextEditingController();
  final famHeartAttackSister = false.obs;
  final famHeartAttackSisterAgeCtrl = TextEditingController();
  final famHeartAttackGrandparents = false.obs;
  final famHeartAttackGrandparentsAgeCtrl = TextEditingController();
  final famHeartAttackSignificance = 'Significant'.obs;

  // 2. Family Stroke
  final hasFamilyStroke = 'No'.obs;
  final famStrokeFather = false.obs;
  final famStrokeFatherAgeCtrl = TextEditingController();
  final famStrokeMother = false.obs;
  final famStrokeMotherAgeCtrl = TextEditingController();
  final famStrokeBrother = false.obs;
  final famStrokeBrotherAgeCtrl = TextEditingController();
  final famStrokeSister = false.obs;
  final famStrokeSisterAgeCtrl = TextEditingController();
  final famStrokeGrandparents = false.obs;
  final famStrokeGrandparentsAgeCtrl = TextEditingController();
  final famStrokeSignificance = 'Significant'.obs;

  // 3. Family Angioplasty
  final hasFamilyAngioplasty = 'No'.obs;
  final famAngioplastyFather = false.obs;
  final famAngioplastyFatherAgeCtrl = TextEditingController();
  final famAngioplastyMother = false.obs;
  final famAngioplastyMotherAgeCtrl = TextEditingController();
  final famAngioplastyBrother = false.obs;
  final famAngioplastyBrotherAgeCtrl = TextEditingController();
  final famAngioplastySister = false.obs;
  final famAngioplastySisterAgeCtrl = TextEditingController();
  final famAngioplastyGrandparents = false.obs;
  final famAngioplastyGrandparentsAgeCtrl = TextEditingController();
  final famAngioplastySignificance = 'Significant'.obs;
  final famAngioplastyCommentsCtrl = TextEditingController();

  // 4. Family Sudden Death
  final hasFamilySuddenDeath = 'No'.obs;
  final famDiedFather = false.obs;
  final famDiedFatherAgeCtrl = TextEditingController();
  final famDiedMother = false.obs;
  final famDiedMotherAgeCtrl = TextEditingController();
  final famDiedBrother = false.obs;
  final famDiedBrotherAgeCtrl = TextEditingController();
  final famDiedSister = false.obs;
  final famDiedSisterAgeCtrl = TextEditingController();
  final famDiedGrandparents = false.obs;
  final famDiedGrandparentsAgeCtrl = TextEditingController();
  final famDiedReasonCtrl = TextEditingController();
  final famDiedReasonRadio = 'Heart Attack'
      .obs; // Heart Attack, Stroke, Accident, Other, Reason don't know
  final famDiedSignificance = 'Significant'.obs;

  // ================= SECTION 4: PERSONAL HABITS =================
  final smokeHabit = 'No'.obs; // Yes, No, Ex-Smoker
  final dailyCigaretteCountCtrl = TextEditingController();
  final smokeStopBeforeYears = 'Less than 6 months'.obs;

  final alcoholHabit = 'No'.obs; // Yes, No, Ex-Alcoholic, Not Disclosed
  final extraSaltHabit = 'No'.obs;
  final familyMembersCountCtrl = TextEditingController();
  final morningWalkHabit = 'No'.obs;
  final yogaHabit = 'No'.obs;

  // ================= SECTION 5: VITALS & EVALUATION =================
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final bpSystolicCtrl = TextEditingController();
  final bpDiastolicCtrl = TextEditingController();

  final hasOtherInfo = 'No'.obs;
  final otherInfoCtrl = TextEditingController();

  final evaluationNoteCtrl = TextEditingController();

  final hasOtherCare = 'No'.obs;
  final otherCareDetailsCtrl = TextEditingController();

  static const List<String> validYearsOptions = [
    'Select',
    'Less than 6 months',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6-10 Years',
    'More than 10 years',
  ];

  static const List<String> validFreqOptions = [
    'One Time',
    'Two Time',
    'Three Time',
    'Four Time',
    'SOS',
  ];

  @override
  void onInit() {
    super.onInit();
    _initPatientData();
  }

  Future<void> _initPatientData() async {
    if (Get.isRegistered<ServingPatientController>()) {
      final sp = Get.find<ServingPatientController>();
      patientId.value = sp.patientId;
      patientName.value = sp.fullName;
      patientGender.value = sp.gender;
      patientAge.value = sp.age;
    }

    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['formId'] != null) formId.value = args['formId'].toString();
      if (args['patientId'] != null) {
        patientId.value = args['patientId'].toString();
      }
      if (args['gender'] != null) {
        patientGender.value = args['gender'].toString();
      }
    }

    if (patientGender.value.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      patientGender.value = prefs.getString(AppConstants.prefUserGender) ?? '';
    }

    if (formId.value.isNotEmpty) {
      fetchMedicalFormData(formId.value);
    }
  }

  bool get showPregnancySection {
    return patientGender.value.toLowerCase() == 'female';
  }

  String _normalizeYears(String? val) {
    if (val == null || val.trim().isEmpty) return 'Select';
    final trimmed = val.trim();
    for (final opt in validYearsOptions) {
      if (opt.toLowerCase() == trimmed.toLowerCase()) return opt;
    }
    // Check numeric-only e.g. "1" -> "1 Year", "2" -> "2 Years"
    if (trimmed == '1') return '1 Year';
    if (trimmed == '2') return '2 Years';
    if (trimmed == '3') return '3 Years';
    if (trimmed == '4') return '4 Years';
    if (trimmed == '5') return '5 Years';
    if (trimmed.contains('10')) return 'More than 10 years';
    return 'Select';
  }

  String _normalizeFreq(String? val) {
    if (val == null || val.trim().isEmpty) return 'One Time';
    final trimmed = val.trim();
    for (final opt in validFreqOptions) {
      if (opt.toLowerCase() == trimmed.toLowerCase()) return opt;
    }
    return 'One Time';
  }

  int _calcCount(String? val1, String? val2, String? val3) {
    if (val3 != null && val3.trim().isNotEmpty) return 3;
    if (val2 != null && val2.trim().isNotEmpty) return 2;
    if (val1 != null && val1.trim().isNotEmpty) return 1;
    return 0;
  }

  Future<void> fetchMedicalFormData(String id) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.post(
        ApiEndpoints.getMedicalForm,
        data: {'form_id': id},
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = MedicalFormDetailResponse.fromJson(
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : Map<String, dynamic>.from(response.data as Map),
        );

        if (res.status.toLowerCase() == 'success' && res.data != null) {
          final d = res.data!;

          // 1. Hypertension
          hasHypertension.value =
              (d.hypertension != null && d.hypertension!.isNotEmpty)
              ? d.hypertension!
              : 'No';
          htnYears.value = _normalizeYears(d.htnSince);
          htnOnMedicine.value = d.htnMed ?? 'No';
          htnMedicineRegular.value = d.htnMedRegular ?? 'No';
          htnMedName1Ctrl.text = d.htnMedName1 ?? '';
          htnMedName2Ctrl.text = d.htnMedName2 ?? '';
          htnMedName3Ctrl.text = d.htnMedName3 ?? '';
          htnMedFreq1.value = _normalizeFreq(d.htnMedFreq1);
          htnMedFreq2.value = _normalizeFreq(d.htnMedFreq2);
          htnMedFreq3.value = _normalizeFreq(d.htnMedFreq3);
          htnMedCount.value = _calcCount(
            d.htnMedName1,
            d.htnMedName2,
            d.htnMedName3,
          );
          htnNetworkImages.assignAll([
            if (d.htnMedImg1?.isNotEmpty == true) d.htnMedImg1!,
            if (d.htnMedImg2?.isNotEmpty == true) d.htnMedImg2!,
            if (d.htnMedImg3?.isNotEmpty == true) d.htnMedImg3!,
          ]);

          // 2. Diabetes
          hasDiabetes.value = (d.diabetes != null && d.diabetes!.isNotEmpty)
              ? d.diabetes!
              : 'No';
          diabetesYears.value = _normalizeYears(d.diaSince);
          diabetesOnMedicine.value = d.diaMed ?? 'No';
          diabetesMedicineRegular.value = d.diaMedRegular ?? 'No';
          diabetesMedName1Ctrl.text = d.diaMedName1 ?? '';
          diabetesMedName2Ctrl.text = d.diaMedName2 ?? '';
          diabetesMedName3Ctrl.text = d.diaMedName3 ?? '';
          diabetesMedFreq1.value = _normalizeFreq(d.diaMedFreq1);
          diabetesMedFreq2.value = _normalizeFreq(d.diaMedFreq2);
          diabetesMedFreq3.value = _normalizeFreq(d.diaMedFreq3);
          diabetesMedCount.value = _calcCount(
            d.diaMedName1,
            d.diaMedName2,
            d.diaMedName3,
          );
          diabetesNetworkImages.assignAll([
            if (d.diaMedImg1?.isNotEmpty == true) d.diaMedImg1!,
            if (d.diaMedImg2?.isNotEmpty == true) d.diaMedImg2!,
            if (d.diaMedImg3?.isNotEmpty == true) d.diaMedImg3!,
          ]);

          // 3. Thyroid
          hasThyroid.value = (d.thyroid != null && d.thyroid!.isNotEmpty)
              ? d.thyroid!
              : 'No';
          thyroidYears.value = _normalizeYears(d.thyroidSince);
          thyroidOnMedicine.value = d.thyroidMed ?? 'No';
          thyroidMedicineRegular.value = d.thyroidMedRegular ?? 'No';
          thyroidMedName1Ctrl.text = d.thyroidMedName1 ?? '';
          thyroidMedName2Ctrl.text = d.thyroidMedName2 ?? '';
          thyroidMedName3Ctrl.text = d.thyroidMedName3 ?? '';
          thyroidMedFreq1.value = _normalizeFreq(d.thyroidMedFreq1);
          thyroidMedFreq2.value = _normalizeFreq(d.thyroidMedFreq2);
          thyroidMedFreq3.value = _normalizeFreq(d.thyroidMedFreq3);
          thyroidMedCount.value = _calcCount(
            d.thyroidMedName1,
            d.thyroidMedName2,
            d.thyroidMedName3,
          );
          thyroidNetworkImages.assignAll([
            if (d.thyroidMedImg1?.isNotEmpty == true) d.thyroidMedImg1!,
            if (d.thyroidMedImg2?.isNotEmpty == true) d.thyroidMedImg2!,
            if (d.thyroidMedImg3?.isNotEmpty == true) d.thyroidMedImg3!,
          ]);

          // 4. Cholesterol & 5. Asthma
          hasCholesterol.value = d.cholesterol ?? 'No';
          hasAsthma.value = d.asthma ?? 'No';

          // 6. Pregnancy
          isPregnant.value = d.isPregnant ?? 'No';
          duringPregnancy.value = d.htnDiaPregnancy ?? 'None';

          // ================= SECTION 2 =================
          // 1. Heart Attack
          hasHeartAttack.value =
              (d.heartAttack != null && d.heartAttack!.isNotEmpty)
              ? d.heartAttack!
              : 'No';
          heartAttackYears.value = _normalizeYears(d.heartAtkWhen);
          heartAttackOnMedicine.value = d.heartAtkMed ?? 'No';
          heartAttackMedName1Ctrl.text = d.heartAtkMedName1 ?? '';
          heartAttackMedName2Ctrl.text = d.heartAtkMedName2 ?? '';
          heartAttackMedName3Ctrl.text = d.heartAtkMedName3 ?? '';
          heartAttackMedFreq1.value = _normalizeFreq(d.heartAtkMedFreq1);
          heartAttackMedFreq2.value = _normalizeFreq(d.heartAtkMedFreq2);
          heartAttackMedFreq3.value = _normalizeFreq(d.heartAtkMedFreq3);
          heartAttackMedCount.value = _calcCount(
            d.heartAtkMedName1,
            d.heartAtkMedName2,
            d.heartAtkMedName3,
          );
          heartAttackNetworkImages.assignAll([
            if (d.hrtAtkMedImg1?.isNotEmpty == true) d.hrtAtkMedImg1!,
            if (d.hrtAtkMedImg2?.isNotEmpty == true) d.hrtAtkMedImg2!,
            if (d.hrtAtkMedImg3?.isNotEmpty == true) d.hrtAtkMedImg3!,
          ]);

          // 2. Stroke
          hasStroke.value = (d.stroke != null && d.stroke!.isNotEmpty)
              ? d.stroke!
              : 'No';
          strokeYears.value = _normalizeYears(d.strokeWhen);
          strokeOnMedicine.value = d.strokeMed ?? 'No';
          strokeMedName1Ctrl.text = d.strokeMedName1 ?? '';
          strokeMedName2Ctrl.text = d.strokeMedName2 ?? '';
          strokeMedName3Ctrl.text = d.strokeMedName3 ?? '';
          strokeMedFreq1.value = _normalizeFreq(d.strokeMedFreq1);
          strokeMedFreq2.value = _normalizeFreq(d.strokeMedFreq2);
          strokeMedFreq3.value = _normalizeFreq(d.strokeMedFreq3);
          strokeMedCount.value = _calcCount(
            d.strokeMedName1,
            d.strokeMedName2,
            d.strokeMedName3,
          );
          strokeNetworkImages.assignAll([
            if (d.strokeMedImg1?.isNotEmpty == true) d.strokeMedImg1!,
            if (d.strokeMedImg2?.isNotEmpty == true) d.strokeMedImg2!,
            if (d.strokeMedImg3?.isNotEmpty == true) d.strokeMedImg3!,
          ]);

          // 3. Kidney Failure
          hasKidneyFailure.value =
              (d.kidneyFailure != null && d.kidneyFailure!.isNotEmpty)
              ? d.kidneyFailure!
              : 'No';
          kidneyFailureYears.value = _normalizeYears(d.kidneyFailWhen);
          kidneyFailureOnMedicine.value = d.kidneyFailMed ?? 'No';
          kidneyFailureMedName1Ctrl.text = d.kidneyFailMedName1 ?? '';
          kidneyFailureMedName2Ctrl.text = d.kidneyFailMedName2 ?? '';
          kidneyFailureMedName3Ctrl.text = d.kidneyFailMedName3 ?? '';
          kidneyFailureMedFreq1.value = _normalizeFreq(d.kidneyFailMedFreq1);
          kidneyFailureMedFreq2.value = _normalizeFreq(d.kidneyFailMedFreq2);
          kidneyFailureMedFreq3.value = _normalizeFreq(d.kidneyFailMedFreq3);
          kidneyFailureMedCount.value = _calcCount(
            d.kidneyFailMedName1,
            d.kidneyFailMedName2,
            d.kidneyFailMedName3,
          );
          kidneyFailureNetworkImages.assignAll([
            if (d.kidneyFailMedImg1?.isNotEmpty == true) d.kidneyFailMedImg1!,
            if (d.kidneyFailMedImg2?.isNotEmpty == true) d.kidneyFailMedImg2!,
            if (d.kidneyFailMedImg3?.isNotEmpty == true) d.kidneyFailMedImg3!,
          ]);

          // 4. Angioplasty
          hasAngioplasty.value =
              (d.angioplasty != null && d.angioplasty!.isNotEmpty)
              ? d.angioplasty!
              : 'No';
          angioplastyYears.value = _normalizeYears(d.angioplastyWhen);
          angioplastyOnMedicine.value = d.angioplastyMed ?? 'No';
          angioplastyMedName1Ctrl.text = d.angioplastyMedName1 ?? '';
          angioplastyMedName2Ctrl.text = d.angioplastyMedName2 ?? '';
          angioplastyMedName3Ctrl.text = d.angioplastyMedName3 ?? '';
          angioplastyMedFreq1.value = _normalizeFreq(d.angioplastyMedFreq1);
          angioplastyMedFreq2.value = _normalizeFreq(d.angioplastyMedFreq2);
          angioplastyMedFreq3.value = _normalizeFreq(d.angioplastyMedFreq3);
          angioplastyMedCount.value = _calcCount(
            d.angioplastyMedName1,
            d.angioplastyMedName2,
            d.angioplastyMedName3,
          );
          angioplastyNetworkImages.assignAll([
            if (d.angioplastyMedImg1?.isNotEmpty == true) d.angioplastyMedImg1!,
            if (d.angioplastyMedImg2?.isNotEmpty == true) d.angioplastyMedImg2!,
            if (d.angioplastyMedImg3?.isNotEmpty == true) d.angioplastyMedImg3!,
          ]);

          // 5. Bypass Surgery
          hasBypass.value =
              (d.bypassSurgery != null && d.bypassSurgery!.isNotEmpty)
              ? d.bypassSurgery!
              : 'No';
          bypassYears.value = _normalizeYears(d.bypassSurgWhen);
          bypassOnMedicine.value = d.bypassSurgMed ?? 'No';
          bypassMedName1Ctrl.text = d.bypassSurgMedName1 ?? '';
          bypassMedName2Ctrl.text = d.bypassSurgMedName2 ?? '';
          bypassMedName3Ctrl.text = d.bypassSurgMedName3 ?? '';
          bypassMedFreq1.value = _normalizeFreq(d.bypassSurgMedFreq1);
          bypassMedFreq2.value = _normalizeFreq(d.bypassSurgMedFreq2);
          bypassMedFreq3.value = _normalizeFreq(d.bypassSurgMedFreq3);
          bypassMedCount.value = _calcCount(
            d.bypassSurgMedName1,
            d.bypassSurgMedName2,
            d.bypassSurgMedName3,
          );
          bypassNetworkImages.assignAll([
            if (d.bypassSurgMedImg1?.isNotEmpty == true) d.bypassSurgMedImg1!,
            if (d.bypassSurgMedImg2?.isNotEmpty == true) d.bypassSurgMedImg2!,
            if (d.bypassSurgMedImg3?.isNotEmpty == true) d.bypassSurgMedImg3!,
          ]);

          // 6. Allergy to Medicines
          hasAllergy.value = d.medAllergy ?? 'No';
          allergyMedName1Ctrl.text = d.allergyMedName1 ?? '';
          allergyMedName2Ctrl.text = d.allergyMedName2 ?? '';
          allergyMedName3Ctrl.text = d.allergyMedName3 ?? '';
          allergyMedCount.value = _calcCount(
            d.allergyMedName1,
            d.allergyMedName2,
            d.allergyMedName3,
          );

          // Section 2 Extensions
          strokeStatus.value = d.strokeStatus ?? 'No Records';
          kidneyFailureStatus.value = d.kidneyFailureStatus ?? 'No Records';
          kidneyFailureDialysis.value = d.dialysis ?? 'No';
          angioplastyStents.value = (d.stent != null && d.stent!.isNotEmpty)
              ? d.stent!
              : 'I';
          angioplastyBrilinta.value = d.brilinta ?? 'No';
          angioplastyClopilet.value = d.clopilet ?? 'No';
          angioplastyPrasita.value = d.prasita ?? 'No';

          // ================= SECTION 3: FAMILY HISTORY =================
          // 1. Family Heart Attack
          hasFamilyHeartAttack.value =
              (d.familyMemberHeartAttack != null &&
                  d.familyMemberHeartAttack!.isNotEmpty)
              ? d.familyMemberHeartAttack!
              : 'No';
          final htnWho = (d.familyMemberHeartAttackWho ?? '').toLowerCase();
          famHeartAttackFather.value = htnWho.contains('father');
          famHeartAttackFatherAgeCtrl.text = d.heartAttackFatherAge ?? '';
          famHeartAttackMother.value = htnWho.contains('mother');
          famHeartAttackMotherAgeCtrl.text = d.heartAttackMotherAge ?? '';
          famHeartAttackBrother.value = htnWho.contains('brother');
          famHeartAttackBrotherAgeCtrl.text = d.heartAttackBrotherAge ?? '';
          famHeartAttackSister.value = htnWho.contains('sister');
          famHeartAttackSisterAgeCtrl.text = d.heartAttackSisterAge ?? '';
          famHeartAttackGrandparents.value =
              htnWho.contains('grandparents') ||
              htnWho.contains('grand parents');
          famHeartAttackGrandparentsAgeCtrl.text =
              d.heartAttackGrandparentsAge ?? '';
          famHeartAttackSignificance.value =
              d.familyHeartAttackFrequency ?? 'Significant';

          // 2. Family Stroke
          hasFamilyStroke.value =
              (d.familyMemberStroke != null && d.familyMemberStroke!.isNotEmpty)
              ? d.familyMemberStroke!
              : 'No';
          final strokeWho = (d.familyMemberStrokeWho ?? '').toLowerCase();
          famStrokeFather.value = strokeWho.contains('father');
          famStrokeFatherAgeCtrl.text = d.strokeFatherAge ?? '';
          famStrokeMother.value = strokeWho.contains('mother');
          famStrokeMotherAgeCtrl.text = d.strokeMotherAge ?? '';
          famStrokeBrother.value = strokeWho.contains('brother');
          famStrokeBrotherAgeCtrl.text = d.strokeBrotherAge ?? '';
          famStrokeSister.value = strokeWho.contains('sister');
          famStrokeSisterAgeCtrl.text = d.strokeSisterAge ?? '';
          famStrokeGrandparents.value =
              strokeWho.contains('grandparents') ||
              strokeWho.contains('grand parents');
          famStrokeGrandparentsAgeCtrl.text = d.strokeGrandparentsAge ?? '';
          famStrokeSignificance.value =
              d.familyStrokeFrequency ?? 'Significant';

          // 3. Family Angioplasty
          hasFamilyAngioplasty.value =
              (d.familyMemberAngioplasty != null &&
                  d.familyMemberAngioplasty!.isNotEmpty)
              ? d.familyMemberAngioplasty!
              : 'No';
          final angioWho = (d.familyMemberAngioplastyWho ?? '').toLowerCase();
          famAngioplastyFather.value = angioWho.contains('father');
          famAngioplastyFatherAgeCtrl.text = d.angioplastyFatherAge ?? '';
          famAngioplastyMother.value = angioWho.contains('mother');
          famAngioplastyMotherAgeCtrl.text = d.angioplastyMotherAge ?? '';
          famAngioplastyBrother.value = angioWho.contains('brother');
          famAngioplastyBrotherAgeCtrl.text = d.angioplastyBrotherAge ?? '';
          famAngioplastySister.value = angioWho.contains('sister');
          famAngioplastySisterAgeCtrl.text = d.angioplastySisterAge ?? '';
          famAngioplastyGrandparents.value =
              angioWho.contains('grandparents') ||
              angioWho.contains('grand parents');
          famAngioplastyGrandparentsAgeCtrl.text =
              d.angioplastyGrandparentsAge ?? '';
          famAngioplastyCommentsCtrl.text = d.angioplastyComments ?? '';

          // 4. Family Sudden Death
          hasFamilySuddenDeath.value =
              (d.familyMemberDied != null && d.familyMemberDied!.isNotEmpty)
              ? d.familyMemberDied!
              : 'No';
          final diedWho = (d.familyMemberDiedWho ?? '').toLowerCase();
          famDiedFather.value = diedWho.contains('father');
          famDiedFatherAgeCtrl.text = d.diedFatherAge ?? '';
          famDiedMother.value = diedWho.contains('mother');
          famDiedMotherAgeCtrl.text = d.diedMotherAge ?? '';
          famDiedBrother.value = diedWho.contains('brother');
          famDiedBrotherAgeCtrl.text = d.diedBrotherAge ?? '';
          famDiedSister.value = diedWho.contains('sister');
          famDiedSisterAgeCtrl.text = d.diedSisterAge ?? '';
          famDiedGrandparents.value =
              diedWho.contains('grandparents') ||
              diedWho.contains('grand parents');
          famDiedGrandparentsAgeCtrl.text = d.diedGrandparentsAge ?? '';
          famDiedReasonCtrl.text = d.familyMemberDiedReason ?? '';

          // ================= SECTION 4: PERSONAL HABITS =================
          smokeHabit.value = d.smoke ?? 'No';
          dailyCigaretteCountCtrl.text = d.dailyCigaretteCount ?? '';
          smokeStopBeforeYears.value = _normalizeYears(d.smokeStopBefore);
          alcoholHabit.value = d.alcohol ?? 'No';
          extraSaltHabit.value = d.extraSalt ?? 'No';
          familyMembersCountCtrl.text = d.familyMemberCount ?? '';
          morningWalkHabit.value = d.morningWalk ?? 'No';
          yogaHabit.value = d.yoga ?? 'No';

          // ================= SECTION 5: VITALS & EVALUATION =================
          heightCtrl.text = d.height ?? '';
          weightCtrl.text = d.weight ?? '';
          bpSystolicCtrl.text = d.bpSystolic ?? '';
          bpDiastolicCtrl.text = d.bpDiastolic ?? '';
          hasOtherInfo.value = d.otherInfo ?? 'No';
          otherInfoCtrl.text = d.otherInfoName ?? '';
          evaluationNoteCtrl.text = d.firstEvaluationImpression ?? '';
          hasOtherCare.value = d.otherCare ?? 'No';
          otherCareDetailsCtrl.text = d.otherCareComments ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching medical form data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _buildWhoString({
    required bool father,
    required bool mother,
    required bool brother,
    required bool sister,
    required bool grandparents,
  }) {
    final list = <String>[];
    if (father) list.add('Father');
    if (mother) list.add('Mother');
    if (brother) list.add('Brother');
    if (sister) list.add('Sister');
    if (grandparents) list.add('Grandparents');
    return list.join(', ');
  }

  String _buildSurgeryTypeString() {
    final list = <String>[];
    if (surgeryAbdominal.value) list.add('Abdominal');
    if (surgeryNeuro.value) list.add('Neuro');
    if (surgeryCardiac.value) list.add('Cardiac');
    if (surgeryOrtho.value) list.add('Ortho');
    if (surgeryGynaec.value) list.add('Gynaec');
    if (surgeryVascular.value) list.add('Vascular');
    if (surgeryCancer.value) list.add('Cancer');
    if (surgeryTumor.value) list.add('Tumor');
    if (surgeryENT.value) list.add('ENT');
    return list.join(' ');
  }

  Future<void> submitUpdateMedicalForm() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';

      final map = <String, dynamic>{
        'patient_id': patientId.value,
        'doctor_id': doctorId,
        'filled_user_type': 'Doctor',

        // Section 1
        'hypertension': hasHypertension.value,
        'htn_since': htnYears.value == 'Select' ? '' : htnYears.value,
        'htn_med': htnOnMedicine.value,
        'htn_med_name_1': htnMedName1Ctrl.text.trim(),
        'htn_med_name_2': htnMedName2Ctrl.text.trim(),
        'htn_med_name_3': htnMedName3Ctrl.text.trim(),
        'htn_med_freq_1': htnMedFreq1.value,
        'htn_med_freq_2': htnMedFreq2.value,
        'htn_med_freq_3': htnMedFreq3.value,
        'htn_med_regular': htnMedicineRegular.value,

        'diabetes': hasDiabetes.value,
        'dia_since': diabetesYears.value == 'Select' ? '' : diabetesYears.value,
        'dia_med': diabetesOnMedicine.value,
        'dia_med_name_1': diabetesMedName1Ctrl.text.trim(),
        'dia_med_name_2': diabetesMedName2Ctrl.text.trim(),
        'dia_med_name_3': diabetesMedName3Ctrl.text.trim(),
        'dia_med_freq_1': diabetesMedFreq1.value,
        'dia_med_freq_2': diabetesMedFreq2.value,
        'dia_med_freq_3': diabetesMedFreq3.value,
        'dia_med_regular': diabetesMedicineRegular.value,

        'thyroid': hasThyroid.value,
        'thyroid_since': thyroidYears.value == 'Select'
            ? ''
            : thyroidYears.value,
        'thyroid_med': thyroidOnMedicine.value,
        'thyroid_med_name_1': thyroidMedName1Ctrl.text.trim(),
        'thyroid_med_name_2': thyroidMedName2Ctrl.text.trim(),
        'thyroid_med_name_3': thyroidMedName3Ctrl.text.trim(),
        'thyroid_med_freq_1': thyroidMedFreq1.value,
        'thyroid_med_freq_2': thyroidMedFreq2.value,
        'thyroid_med_freq_3': thyroidMedFreq3.value,
        'thyroid_med_regular': thyroidMedicineRegular.value,

        'cholesterol': hasCholesterol.value,
        'asthma': hasAsthma.value,
        'is_pregnant': isPregnant.value,
        'htn_dia_pregnancy': duringPregnancy.value,

        // Section 2
        'heart_attack': hasHeartAttack.value,
        'heart_atk_when': heartAttackYears.value == 'Select'
            ? ''
            : heartAttackYears.value,
        'heart_atk_med': heartAttackOnMedicine.value,
        'heart_atk_status': heartAttackStatus.value,
        'heart_atk_med_name_1': heartAttackMedName1Ctrl.text.trim(),
        'heart_atk_med_name_2': heartAttackMedName2Ctrl.text.trim(),
        'heart_atk_med_name_3': heartAttackMedName3Ctrl.text.trim(),
        'heart_atk_med_freq_1': heartAttackMedFreq1.value,
        'heart_atk_med_freq_2': heartAttackMedFreq2.value,
        'heart_atk_med_freq_3': heartAttackMedFreq3.value,

        'stroke': hasStroke.value,
        'stroke_when': strokeYears.value == 'Select' ? '' : strokeYears.value,
        'stroke_med': strokeOnMedicine.value,
        'stroke_status': strokeStatus.value,
        'stroke_med_name_1': strokeMedName1Ctrl.text.trim(),
        'stroke_med_name_2': strokeMedName2Ctrl.text.trim(),
        'stroke_med_name_3': strokeMedName3Ctrl.text.trim(),
        'stroke_med_freq_1': strokeMedFreq1.value,
        'stroke_med_freq_2': strokeMedFreq2.value,
        'stroke_med_freq_3': strokeMedFreq3.value,

        'kidney_failure': hasKidneyFailure.value,
        'kidney_fail_when': kidneyFailureYears.value == 'Select'
            ? ''
            : kidneyFailureYears.value,
        'kidney_fail_med': kidneyFailureOnMedicine.value,
        'kidney_failure_status': kidneyFailureStatus.value,
        'dialysis': kidneyFailureDialysis.value,
        'dialysis_frequency': kidneyFailureDialysis.value,
        'kidney_fail_med_name_1': kidneyFailureMedName1Ctrl.text.trim(),
        'kidney_fail_med_name_2': kidneyFailureMedName2Ctrl.text.trim(),
        'kidney_fail_med_name_3': kidneyFailureMedName3Ctrl.text.trim(),
        'kidney_fail_med_freq_1': kidneyFailureMedFreq1.value,
        'kidney_fail_med_freq_2': kidneyFailureMedFreq2.value,
        'kidney_fail_med_freq_3': kidneyFailureMedFreq3.value,

        'angioplasty': hasAngioplasty.value,
        'angioplasty_when': angioplastyYears.value == 'Select'
            ? ''
            : angioplastyYears.value,
        'angioplasty_med': angioplastyOnMedicine.value,
        'stent': angioplastyStents.value,
        'brilinta': angioplastyBrilinta.value,
        'clopilet': angioplastyClopilet.value,
        'prasita': angioplastyPrasita.value,
        'angioplasty_med_name_1': angioplastyMedName1Ctrl.text.trim(),
        'angioplasty_med_name_2': angioplastyMedName2Ctrl.text.trim(),
        'angioplasty_med_name_3': angioplastyMedName3Ctrl.text.trim(),
        'angioplasty_med_freq_1': angioplastyMedFreq1.value,
        'angioplasty_med_freq_2': angioplastyMedFreq2.value,
        'angioplasty_med_freq_3': angioplastyMedFreq3.value,

        'bypass_surgery': hasBypass.value,
        'bypass_surg_when': bypassYears.value == 'Select'
            ? ''
            : bypassYears.value,
        'bypass_surg_med': bypassOnMedicine.value,
        'bypass_surg_med_name_1': bypassMedName1Ctrl.text.trim(),
        'bypass_surg_med_name_2': bypassMedName2Ctrl.text.trim(),
        'bypass_surg_med_name_3': bypassMedName3Ctrl.text.trim(),
        'bypass_surg_med_freq_1': bypassMedFreq1.value,
        'bypass_surg_med_freq_2': bypassMedFreq2.value,
        'bypass_surg_med_freq_3': bypassMedFreq3.value,

        'med_allergy': hasAllergy.value,
        'allergic_to': allergicToCardiacDiabetic.value,
        'allergy_med_name_1': allergyMedName1Ctrl.text.trim(),
        'allergy_med_name_2': allergyMedName2Ctrl.text.trim(),
        'allergy_med_name_3': allergyMedName3Ctrl.text.trim(),

        'bleeding_tendency': hasBleedingTendency.value,
        'bleeding_frequency': bleedingSeverity.value,
        'on_medicine': canAspirinContinue.value,

        'other_surgery': hasOtherSurgery.value,
        'surgery_type': _buildSurgeryTypeString(),
        'other_surg_name_1': surgeryName1Ctrl.text.trim(),
        'other_surg_name_2': surgeryName2Ctrl.text.trim(),
        'other_surg_name_3': surgeryName3Ctrl.text.trim(),

        // Section 3: Family History
        'family_member_heart_attack': hasFamilyHeartAttack.value,
        'family_member_heart_attack_who': _buildWhoString(
          father: famHeartAttackFather.value,
          mother: famHeartAttackMother.value,
          brother: famHeartAttackBrother.value,
          sister: famHeartAttackSister.value,
          grandparents: famHeartAttackGrandparents.value,
        ),
        'heart_attack_father_age': famHeartAttackFatherAgeCtrl.text.trim(),
        'heart_attack_mother_age': famHeartAttackMotherAgeCtrl.text.trim(),
        'heart_attack_brother_age': famHeartAttackBrotherAgeCtrl.text.trim(),
        'heart_attack_sister_age': famHeartAttackSisterAgeCtrl.text.trim(),
        'heart_attack_grandparents_age': famHeartAttackGrandparentsAgeCtrl.text
            .trim(),
        'family_heart_attack_frequency': famHeartAttackSignificance.value,

        'family_member_stroke': hasFamilyStroke.value,
        'family_member_stroke_who': _buildWhoString(
          father: famStrokeFather.value,
          mother: famStrokeMother.value,
          brother: famStrokeBrother.value,
          sister: famStrokeSister.value,
          grandparents: famStrokeGrandparents.value,
        ),
        'stroke_father_age': famStrokeFatherAgeCtrl.text.trim(),
        'stroke_mother_age': famStrokeMotherAgeCtrl.text.trim(),
        'stroke_brother_age': famStrokeBrotherAgeCtrl.text.trim(),
        'stroke_sister_age': famStrokeSisterAgeCtrl.text.trim(),
        'stroke_grandparents_age': famStrokeGrandparentsAgeCtrl.text.trim(),
        'family_stroke_frequency': famStrokeSignificance.value,

        'family_member_angioplasty': hasFamilyAngioplasty.value,
        'family_member_angioplasty_who': _buildWhoString(
          father: famAngioplastyFather.value,
          mother: famAngioplastyMother.value,
          brother: famAngioplastyBrother.value,
          sister: famAngioplastySister.value,
          grandparents: famAngioplastyGrandparents.value,
        ),
        'angioplasty_father_age': famAngioplastyFatherAgeCtrl.text.trim(),
        'angioplasty_mother_age': famAngioplastyMotherAgeCtrl.text.trim(),
        'angioplasty_brother_age': famAngioplastyBrotherAgeCtrl.text.trim(),
        'angioplasty_sister_age': famAngioplastySisterAgeCtrl.text.trim(),
        'angioplasty_grandparents_age': famAngioplastyGrandparentsAgeCtrl.text
            .trim(),
        'angioplasty_comments': famAngioplastyCommentsCtrl.text.trim(),

        'family_member_died': hasFamilySuddenDeath.value,
        'family_member_died_who': _buildWhoString(
          father: famDiedFather.value,
          mother: famDiedMother.value,
          brother: famDiedBrother.value,
          sister: famDiedSister.value,
          grandparents: famDiedGrandparents.value,
        ),
        'died_father_age': famDiedFatherAgeCtrl.text.trim(),
        'died_mother_age': famDiedMotherAgeCtrl.text.trim(),
        'died_brother_age': famDiedBrotherAgeCtrl.text.trim(),
        'died_sister_age': famDiedSisterAgeCtrl.text.trim(),
        'died_grandparents_age': famDiedGrandparentsAgeCtrl.text.trim(),
        'family_member_died_reason': famDiedReasonRadio.value,

        // Section 4: Personal Habits
        'smoke': smokeHabit.value,
        'daily_cigarette_count': dailyCigaretteCountCtrl.text.trim(),
        'smoke_stop_before': smokeStopBeforeYears.value == 'Select'
            ? ''
            : smokeStopBeforeYears.value,
        'alcohol': alcoholHabit.value,
        'extra_salt': extraSaltHabit.value,
        'family_member_count': familyMembersCountCtrl.text.trim(),
        'morning_walk': morningWalkHabit.value,
        'yoga': yogaHabit.value,

        // Section 5: Vitals & Evaluation
        'height': heightCtrl.text.trim(),
        'weight': weightCtrl.text.trim(),
        'bp_systolic': bpSystolicCtrl.text.trim(),
        'bp_diastolic': bpDiastolicCtrl.text.trim(),
        'other_info': hasOtherInfo.value,
        'other_info_name': otherInfoCtrl.text.trim(),
        'first_evaluation_impression': evaluationNoteCtrl.text.trim(),
        'other_care': hasOtherCare.value,
        'other_care_comments': otherCareDetailsCtrl.text.trim(),
      };

      // Attach file uploads
      for (int i = 0; i < htnReports.length && i < 3; i++) {
        map['htn_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          htnReports[i].path,
          filename: 'htn_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < diabetesReports.length && i < 3; i++) {
        map['dia_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          diabetesReports[i].path,
          filename: 'dia_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < thyroidReports.length && i < 3; i++) {
        map['thyroid_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          thyroidReports[i].path,
          filename: 'thyroid_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < heartAttackReports.length && i < 3; i++) {
        map['hrt_atk_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          heartAttackReports[i].path,
          filename: 'hrt_atk_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < strokeReports.length && i < 3; i++) {
        map['stroke_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          strokeReports[i].path,
          filename: 'stroke_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < kidneyFailureReports.length && i < 3; i++) {
        map['kidney_fail_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          kidneyFailureReports[i].path,
          filename: 'kidney_fail_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < angioplastyReports.length && i < 3; i++) {
        map['angioplasty_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          angioplastyReports[i].path,
          filename: 'angioplasty_med_img_${i + 1}.jpg',
        );
      }
      for (int i = 0; i < bypassReports.length && i < 3; i++) {
        map['bypass_surg_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(
          bypassReports[i].path,
          filename: 'bypass_surg_med_img_${i + 1}.jpg',
        );
      }

      final formData = dio.FormData.fromMap(map);
      final response = await _apiClient.post(
        ApiEndpoints.updateMedicalForm,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> body = {};
        if (response.data is Map) {
          body = Map<String, dynamic>.from(response.data as Map);
        } else if (response.data is String) {
          try {
            final parsed = jsonDecode(response.data as String);
            if (parsed is Map) {
              body = Map<String, dynamic>.from(parsed);
            }
          } catch (_) {}
        }

        final statusStr = body['status']?.toString().toLowerCase() ?? '';
        final isSuccess =
            statusStr == 'success' ||
            statusStr == 'true' ||
            body['status'] == true ||
            statusStr.isEmpty;
        final msg =
            body['msg']?.toString() ??
            body['message']?.toString() ??
            'medical_form_updated_successfully'.tr;

        if (isSuccess) {
          Get.back(result: true);
          AppSnackbars.showSuccess('success'.tr, msg);
          return;
        } else {
          AppSnackbars.showError('error'.tr, msg);
          return;
        }
      } else {
        AppSnackbars.showError('error'.tr, 'something_went_wrong'.tr);
      }
    } catch (e) {
      debugPrint('Error updating medical form: $e');
      AppSnackbars.showError('error'.tr, 'something_went_wrong'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickReportImage(String typeKey, ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null) {
        final file = File(picked.path);
        switch (typeKey) {
          case 'HTN':
            if (htnReports.length < 3) htnReports.add(file);
            break;
          case 'Diabetes':
            if (diabetesReports.length < 3) diabetesReports.add(file);
            break;
          case 'Thyroid':
            if (thyroidReports.length < 3) thyroidReports.add(file);
            break;
          case 'HeartAttack':
            if (heartAttackReports.length < 3) heartAttackReports.add(file);
            break;
          case 'Stroke':
            if (strokeReports.length < 3) strokeReports.add(file);
            break;
          case 'KidneyFailure':
            if (kidneyFailureReports.length < 3) kidneyFailureReports.add(file);
            break;
          case 'Angioplasty':
            if (angioplastyReports.length < 3) angioplastyReports.add(file);
            break;
          case 'Bypass':
            if (bypassReports.length < 3) bypassReports.add(file);
            break;
        }
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    htnMedName1Ctrl.dispose();
    htnMedName2Ctrl.dispose();
    htnMedName3Ctrl.dispose();
    diabetesMedName1Ctrl.dispose();
    diabetesMedName2Ctrl.dispose();
    diabetesMedName3Ctrl.dispose();
    thyroidMedName1Ctrl.dispose();
    thyroidMedName2Ctrl.dispose();
    thyroidMedName3Ctrl.dispose();
    heartAttackMedName1Ctrl.dispose();
    heartAttackMedName2Ctrl.dispose();
    heartAttackMedName3Ctrl.dispose();
    strokeMedName1Ctrl.dispose();
    strokeMedName2Ctrl.dispose();
    strokeMedName3Ctrl.dispose();
    kidneyFailureMedName1Ctrl.dispose();
    kidneyFailureMedName2Ctrl.dispose();
    kidneyFailureMedName3Ctrl.dispose();
    angioplastyMedName1Ctrl.dispose();
    angioplastyMedName2Ctrl.dispose();
    angioplastyMedName3Ctrl.dispose();
    bypassMedName1Ctrl.dispose();
    bypassMedName2Ctrl.dispose();
    bypassMedName3Ctrl.dispose();
    allergyMedName1Ctrl.dispose();
    allergyMedName2Ctrl.dispose();
    allergyMedName3Ctrl.dispose();
    surgeryName1Ctrl.dispose();
    surgeryName2Ctrl.dispose();
    surgeryName3Ctrl.dispose();

    famHeartAttackFatherAgeCtrl.dispose();
    famHeartAttackMotherAgeCtrl.dispose();
    famHeartAttackBrotherAgeCtrl.dispose();
    famHeartAttackSisterAgeCtrl.dispose();
    famHeartAttackGrandparentsAgeCtrl.dispose();

    famStrokeFatherAgeCtrl.dispose();
    famStrokeMotherAgeCtrl.dispose();
    famStrokeBrotherAgeCtrl.dispose();
    famStrokeSisterAgeCtrl.dispose();
    famStrokeGrandparentsAgeCtrl.dispose();

    famAngioplastyFatherAgeCtrl.dispose();
    famAngioplastyMotherAgeCtrl.dispose();
    famAngioplastyBrotherAgeCtrl.dispose();
    famAngioplastySisterAgeCtrl.dispose();
    famAngioplastyGrandparentsAgeCtrl.dispose();
    famAngioplastyCommentsCtrl.dispose();

    famDiedFatherAgeCtrl.dispose();
    famDiedMotherAgeCtrl.dispose();
    famDiedBrotherAgeCtrl.dispose();
    famDiedSisterAgeCtrl.dispose();
    famDiedGrandparentsAgeCtrl.dispose();
    famDiedReasonCtrl.dispose();

    dailyCigaretteCountCtrl.dispose();
    familyMembersCountCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    bpSystolicCtrl.dispose();
    bpDiastolicCtrl.dispose();
    otherInfoCtrl.dispose();
    evaluationNoteCtrl.dispose();
    otherCareDetailsCtrl.dispose();
    super.onClose();
  }
}
