import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_endpoints.dart';
import '../core/constants/app_constants.dart';
import '../models/response/patients/medical_form_details_model.dart';
import '../services/api/api_client.dart';

class MedicalFormController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Route arguments / User Info
  String doctorId = '';
  String patientId = '';
  String patientName = '';
  String doctorName = '';
  String patientAge = '';
  String gender = '';
  String speciality = '';
  String doctorHsReqId = '';
  String problem = '';
  String userType = '';
  String from = '';
  String isFrom = '';
  bool isFromDoctorHomeService = false;

  final RxBool isLoading = false.obs;
  final RxString loggedInUserName = ''.obs;

  // Form State Model
  final mMedicalFormData = MedicalFormDetailsModel();

  // --- SECTION 1 STATES ---
  // Hypertension States
  final RxString hasHypertension = ''.obs; // Yes, No, Don't know
  final RxString htnYears = 'Select'.obs;
  final RxString htnOnMedicine = ''.obs; // Yes, No
  final RxString htnMedicineRegular = ''.obs; // Yes, No
  final RxInt htnMedCount = 0.obs; // 0 to 3
  
  final htnMedName1Controller = TextEditingController();
  final htnMedName2Controller = TextEditingController();
  final htnMedName3Controller = TextEditingController();
  
  final RxString htnMedFreq1 = 'One Time'.obs;
  final RxString htnMedFreq2 = 'One Time'.obs;
  final RxString htnMedFreq3 = 'One Time'.obs;
  
  final RxList<File> htnReports = <File>[].obs;

  // Diabetes States
  final RxString hasDiabetes = ''.obs; // Yes, No, Don't know
  final RxString diabetesYears = 'Select'.obs;
  final RxString diabetesOnMedicine = ''.obs; // Yes, No
  final RxString diabetesMedicineRegular = ''.obs; // Yes, No
  final RxInt diabetesMedCount = 0.obs; // 0 to 3
  
  final diabetesMedName1Controller = TextEditingController();
  final diabetesMedName2Controller = TextEditingController();
  final diabetesMedName3Controller = TextEditingController();
  
  final RxString diabetesMedFreq1 = 'One Time'.obs;
  final RxString diabetesMedFreq2 = 'One Time'.obs;
  final RxString diabetesMedFreq3 = 'One Time'.obs;
  
  final RxList<File> diabetesReports = <File>[].obs;

  // Thyroid States
  final RxString hasThyroid = ''.obs; // Yes, No, Don't know
  final RxString thyroidYears = 'Select'.obs;
  final RxString thyroidOnMedicine = ''.obs; // Yes, No
  final RxString thyroidMedicineRegular = ''.obs; // Yes, No
  final RxInt thyroidMedCount = 0.obs; // 0 to 3
  
  final thyroidMedName1Controller = TextEditingController();
  final thyroidMedName2Controller = TextEditingController();
  final thyroidMedName3Controller = TextEditingController();
  
  final RxString thyroidMedFreq1 = 'One Time'.obs;
  final RxString thyroidMedFreq2 = 'One Time'.obs;
  final RxString thyroidMedFreq3 = 'One Time'.obs;
  
  final RxList<File> thyroidReports = <File>[].obs;

  // Cholesterol & Asthma
  final RxString hasCholesterol = ''.obs; // Yes, No, Don't Know
  final RxString hasAsthma = ''.obs; // Yes, No

  // Pregnancy fields
  final RxString isPregnant = ''.obs; // Yes, No, May be
  final RxString duringPregnancy = ''.obs; // Hypertension, Diabetes, Both, None


  // --- SECTION 2 STATES ---
  // Heart Attack States
  final RxString hasHeartAttack = ''.obs; // Yes, No
  final RxString heartAttackYears = 'Select'.obs;
  final RxString heartAttackOnMedicine = ''.obs; // Yes, No
  final RxInt heartAttackMedCount = 0.obs; // 0 to 3

  final heartAttackMedName1Controller = TextEditingController();
  final heartAttackMedName2Controller = TextEditingController();
  final heartAttackMedName3Controller = TextEditingController();

  final RxString heartAttackMedFreq1 = 'One Time'.obs;
  final RxString heartAttackMedFreq2 = 'One Time'.obs;
  final RxString heartAttackMedFreq3 = 'One Time'.obs;

  final RxList<File> heartAttackReports = <File>[].obs;

  // Stroke States
  final RxString hasStroke = ''.obs; // Yes, No
  final RxString strokeYears = 'Select'.obs;
  final RxString strokeOnMedicine = ''.obs; // Yes, No
  final RxInt strokeMedCount = 0.obs; // 0 to 3

  final strokeMedName1Controller = TextEditingController();
  final strokeMedName2Controller = TextEditingController();
  final strokeMedName3Controller = TextEditingController();

  final RxString strokeMedFreq1 = 'One Time'.obs;
  final RxString strokeMedFreq2 = 'One Time'.obs;
  final RxString strokeMedFreq3 = 'One Time'.obs;

  final RxList<File> strokeReports = <File>[].obs;

  // Kidney Failure States
  final RxString hasKidneyFailure = ''.obs; // Yes, No
  final RxString kidneyFailureYears = 'Select'.obs;
  final RxString kidneyFailureOnMedicine = ''.obs; // Yes, No
  final RxInt kidneyFailureMedCount = 0.obs; // 0 to 3

  final kidneyFailureMedName1Controller = TextEditingController();
  final kidneyFailureMedName2Controller = TextEditingController();
  final kidneyFailureMedName3Controller = TextEditingController();

  final RxString kidneyFailureMedFreq1 = 'One Time'.obs;
  final RxString kidneyFailureMedFreq2 = 'One Time'.obs;
  final RxString kidneyFailureMedFreq3 = 'One Time'.obs;

  final RxList<File> kidneyFailureReports = <File>[].obs;

  // Angioplasty States
  final RxString hasAngioplasty = ''.obs; // Yes, No
  final RxString angioplastyYears = 'Select'.obs;
  final RxString angioplastyOnMedicine = ''.obs; // Yes, No
  final RxInt angioplastyMedCount = 0.obs; // 0 to 3

  final angioplastyMedName1Controller = TextEditingController();
  final angioplastyMedName2Controller = TextEditingController();
  final angioplastyMedName3Controller = TextEditingController();

  final RxString angioplastyMedFreq1 = 'One Time'.obs;
  final RxString angioplastyMedFreq2 = 'One Time'.obs;
  final RxString angioplastyMedFreq3 = 'One Time'.obs;

  final RxList<File> angioplastyReports = <File>[].obs;

  // Bypass Surgery States
  final RxString hasBypass = ''.obs; // Yes, No
  final RxString bypassYears = 'Select'.obs;
  final RxString bypassOnMedicine = ''.obs; // Yes, No
  final RxInt bypassMedCount = 0.obs; // 0 to 3

  final bypassMedName1Controller = TextEditingController();
  final bypassMedName2Controller = TextEditingController();
  final bypassMedName3Controller = TextEditingController();

  final RxString bypassMedFreq1 = 'One Time'.obs;
  final RxString bypassMedFreq2 = 'One Time'.obs;
  final RxString bypassMedFreq3 = 'One Time'.obs;

  final RxList<File> bypassReports = <File>[].obs;

  // Allergy States
  final RxString hasAllergy = ''.obs; // Yes, No
  final RxInt allergyMedCount = 0.obs; // 0 to 3
  final allergyMedName1Controller = TextEditingController();
  final allergyMedName2Controller = TextEditingController();
  final allergyMedName3Controller = TextEditingController();

  // Bleeding Tendency
  final RxString hasBleedingTendency = ''.obs; // Yes, No

  // Other Surgery States
  final RxString hasOtherSurgery = ''.obs; // Yes, No
  final RxInt surgeryMedCount = 0.obs; // 0 to 3
  final surgeryName1Controller = TextEditingController();
  final surgeryName2Controller = TextEditingController();
  final surgeryName3Controller = TextEditingController();


  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      doctorId = args['doctorId']?.toString() ?? '';
      patientId = args['patientId']?.toString() ?? '';
      patientName = args['userName']?.toString() ?? '';
      doctorName = args['doctorName']?.toString() ?? '';
      patientAge = args['userAge']?.toString() ?? '';
      gender = args['userGender']?.toString() ?? '';
      speciality = args['speciality']?.toString() ?? '';
      doctorHsReqId = args['doctor_hs_req_id']?.toString() ?? '';
      problem = args['problem']?.toString() ?? '';
      userType = args['type']?.toString() ?? '';
      from = args['from']?.toString() ?? '';
      isFrom = args['isFrom']?.toString() ?? '';
      isFromDoctorHomeService = args['isFromDoctorHomeService'] == true;
    }

    _loadPatientInfo();
  }

  @override
  void onClose() {
    // Disposing Controllers
    htnMedName1Controller.dispose();
    htnMedName2Controller.dispose();
    htnMedName3Controller.dispose();
    diabetesMedName1Controller.dispose();
    diabetesMedName2Controller.dispose();
    diabetesMedName3Controller.dispose();
    thyroidMedName1Controller.dispose();
    thyroidMedName2Controller.dispose();
    thyroidMedName3Controller.dispose();

    heartAttackMedName1Controller.dispose();
    heartAttackMedName2Controller.dispose();
    heartAttackMedName3Controller.dispose();
    strokeMedName1Controller.dispose();
    strokeMedName2Controller.dispose();
    strokeMedName3Controller.dispose();
    kidneyFailureMedName1Controller.dispose();
    kidneyFailureMedName2Controller.dispose();
    kidneyFailureMedName3Controller.dispose();
    angioplastyMedName1Controller.dispose();
    angioplastyMedName2Controller.dispose();
    angioplastyMedName3Controller.dispose();
    bypassMedName1Controller.dispose();
    bypassMedName2Controller.dispose();
    bypassMedName3Controller.dispose();

    allergyMedName1Controller.dispose();
    allergyMedName2Controller.dispose();
    allergyMedName3Controller.dispose();
    surgeryName1Controller.dispose();
    surgeryName2Controller.dispose();
    surgeryName3Controller.dispose();

    super.onClose();
  }

  Future<void> _loadPatientInfo() async {
    final prefs = await SharedPreferences.getInstance();
    loggedInUserName.value = prefs.getString(AppConstants.prefUserName) ?? '';
    if (patientId.isEmpty) {
      patientId = prefs.getString(AppConstants.prefUserId) ?? '';
    }
    final loggedInUserType = prefs.getString(AppConstants.prefLoginType) ?? '';
    if (userType.isEmpty) {
      userType = loggedInUserType;
    }

    if (userType == 'Patient') {
      gender = prefs.getString(AppConstants.prefUserGender) ?? '';
      patientAge = prefs.getString(AppConstants.prefUserAge) ?? '';
    }
    update();
  }

  bool get showPregnancySection {
    if (gender != 'Female') return false;
    return true;
  }

  bool get showIsPregnantQuestion {
    if (gender != 'Female') return false;
    if (patientAge.isEmpty) return false;
    final age = int.tryParse(patientAge);
    if (age == null) return false;
    return age >= 18 && age <= 45;
  }

  // File Picker Methods
  Future<void> pickReportImage(String type, ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (type == 'HTN') {
          if (htnReports.length < 3) htnReports.add(file);
        } else if (type == 'Diabetes') {
          if (diabetesReports.length < 3) diabetesReports.add(file);
        } else if (type == 'Thyroid') {
          if (thyroidReports.length < 3) thyroidReports.add(file);
        } else if (type == 'HeartAttack') {
          if (heartAttackReports.length < 3) heartAttackReports.add(file);
        } else if (type == 'Stroke') {
          if (strokeReports.length < 3) strokeReports.add(file);
        } else if (type == 'KidneyFailure') {
          if (kidneyFailureReports.length < 3) kidneyFailureReports.add(file);
        } else if (type == 'Angioplasty') {
          if (angioplastyReports.length < 3) angioplastyReports.add(file);
        } else if (type == 'Bypass') {
          if (bypassReports.length < 3) bypassReports.add(file);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  bool validateForm() {
    // --- SECTION 1 VALIDATION ---
    if (hasHypertension.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have hypertension');
      return false;
    }
    if (hasHypertension.value == 'Yes') {
      if (htnYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select how many years you have hypertension');
        return false;
      }
      if (htnOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on hypertension medicines');
        return false;
      }
      if (htnOnMedicine.value == 'Yes') {
        if (htnMedicineRegular.value.isEmpty) {
          Get.snackbar('Validation Error', 'Please select if you take medicines regularly');
          return false;
        }
        if (htnMedCount.value == 0) {
          Get.snackbar('Validation Error', 'Please add at least one hypertension medicine name');
          return false;
        }
        if (htnMedCount.value >= 1 && htnMedName1Controller.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Please enter first hypertension medicine name');
          return false;
        }
      }
    }

    if (hasDiabetes.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have diabetes');
      return false;
    }
    if (hasDiabetes.value == 'Yes') {
      if (diabetesYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select how many years you have diabetes');
        return false;
      }
      if (diabetesOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on diabetes medicines');
        return false;
      }
      if (diabetesOnMedicine.value == 'Yes') {
        if (diabetesMedicineRegular.value.isEmpty) {
          Get.snackbar('Validation Error', 'Please select if you take diabetes medicines regularly');
          return false;
        }
        if (diabetesMedCount.value == 0) {
          Get.snackbar('Validation Error', 'Please add at least one diabetes medicine name');
          return false;
        }
        if (diabetesMedCount.value >= 1 && diabetesMedName1Controller.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Please enter first diabetes medicine name');
          return false;
        }
      }
    }

    if (hasThyroid.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have thyroid');
      return false;
    }
    if (hasThyroid.value == 'Yes') {
      if (thyroidYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select how many years you have thyroid');
        return false;
      }
      if (thyroidOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on thyroid medicines');
        return false;
      }
      if (thyroidOnMedicine.value == 'Yes') {
        if (thyroidMedicineRegular.value.isEmpty) {
          Get.snackbar('Validation Error', 'Please select if you take thyroid medicines regularly');
          return false;
        }
        if (thyroidMedCount.value == 0) {
          Get.snackbar('Validation Error', 'Please add at least one thyroid medicine name');
          return false;
        }
        if (thyroidMedCount.value >= 1 && thyroidMedName1Controller.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Please enter first thyroid medicine name');
          return false;
        }
      }
    }

    if (hasCholesterol.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have a cholesterol problem');
      return false;
    }

    if (hasAsthma.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have asthma');
      return false;
    }


    // --- SECTION 2 VALIDATION ---
    if (hasHeartAttack.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had a heart attack');
      return false;
    }
    if (hasHeartAttack.value == 'Yes') {
      if (heartAttackYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select when you had a heart attack');
        return false;
      }
      if (heartAttackOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on heart attack medicines');
        return false;
      }
    }

    if (hasStroke.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had a stroke');
      return false;
    }
    if (hasStroke.value == 'Yes') {
      if (strokeYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select when you had a stroke');
        return false;
      }
      if (strokeOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on stroke medicines');
        return false;
      }
    }

    if (hasKidneyFailure.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had kidney failure');
      return false;
    }
    if (hasKidneyFailure.value == 'Yes') {
      if (kidneyFailureYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select when you had kidney failure');
        return false;
      }
      if (kidneyFailureOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on kidney failure medicines');
        return false;
      }
    }

    if (hasAngioplasty.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had angioplasty');
      return false;
    }
    if (hasAngioplasty.value == 'Yes') {
      if (angioplastyYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select when you had angioplasty');
        return false;
      }
      if (angioplastyOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on angioplasty medicines');
        return false;
      }
    }

    if (hasBypass.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had bypass surgery');
      return false;
    }
    if (hasBypass.value == 'Yes') {
      if (bypassYears.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select when you had bypass surgery');
        return false;
      }
      if (bypassOnMedicine.value.isEmpty) {
        Get.snackbar('Validation Error', 'Please select if you are on bypass surgery medicines');
        return false;
      }
    }

    if (hasAllergy.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have a medicine allergy');
      return false;
    }

    if (hasBleedingTendency.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you have bleeding tendencies');
      return false;
    }

    if (hasOtherSurgery.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select if you had other surgeries');
      return false;
    }

    return true;
  }

  Future<void> submitMedicalForm() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final Map<String, dynamic> fields = {
        'patient_id': patientId,

        // Section 1 - Clinical History
        'hypertension': hasHypertension.value,
        'htn_since': hasHypertension.value == 'Yes' ? (htnYears.value == 'Select' ? '' : htnYears.value) : '',
        'htn_med': hasHypertension.value == 'Yes' ? htnOnMedicine.value : '',
        'htn_med_regular': (hasHypertension.value == 'Yes' && htnOnMedicine.value == 'Yes') ? htnMedicineRegular.value : '',
        'htn_med_name_1': htnMedName1Controller.text.trim(),
        'htn_med_name_2': htnMedName2Controller.text.trim(),
        'htn_med_name_3': htnMedName3Controller.text.trim(),
        'htn_med_freq_1': htnMedFreq1.value,
        'htn_med_freq_2': htnMedFreq2.value,
        'htn_med_freq_3': htnMedFreq3.value,

        'diabetes': hasDiabetes.value,
        'dia_since': hasDiabetes.value == 'Yes' ? (diabetesYears.value == 'Select' ? '' : diabetesYears.value) : '',
        'dia_med': hasDiabetes.value == 'Yes' ? diabetesOnMedicine.value : '',
        'dia_med_regular': (hasDiabetes.value == 'Yes' && diabetesOnMedicine.value == 'Yes') ? diabetesMedicineRegular.value : '',
        'dia_med_name_1': diabetesMedName1Controller.text.trim(),
        'dia_med_name_2': diabetesMedName2Controller.text.trim(),
        'dia_med_name_3': diabetesMedName3Controller.text.trim(),
        'dia_med_freq_1': diabetesMedFreq1.value,
        'dia_med_freq_2': diabetesMedFreq2.value,
        'dia_med_freq_3': diabetesMedFreq3.value,

        'thyroid': hasThyroid.value,
        'thyroid_since': hasThyroid.value == 'Yes' ? (thyroidYears.value == 'Select' ? '' : thyroidYears.value) : '',
        'thyroid_med': hasThyroid.value == 'Yes' ? thyroidOnMedicine.value : '',
        'thyroid_med_regular': (hasThyroid.value == 'Yes' && thyroidOnMedicine.value == 'Yes') ? thyroidMedicineRegular.value : '',
        'thyroid_med_name_1': thyroidMedName1Controller.text.trim(),
        'thyroid_med_name_2': thyroidMedName2Controller.text.trim(),
        'thyroid_med_name_3': thyroidMedName3Controller.text.trim(),
        'thyroid_med_freq_1': thyroidMedFreq1.value,
        'thyroid_med_freq_2': thyroidMedFreq2.value,
        'thyroid_med_freq_3': thyroidMedFreq3.value,

        'cholesterol': hasCholesterol.value,
        'asthma': hasAsthma.value,
        'is_pregnant': showIsPregnantQuestion ? isPregnant.value : '',
        'htn_dia_pregnancy': showPregnancySection ? duringPregnancy.value : '',

        // Section 2 - Past History
        'heart_attack': hasHeartAttack.value,
        'heart_atk_when': hasHeartAttack.value == 'Yes' ? (heartAttackYears.value == 'Select' ? '' : heartAttackYears.value) : '',
        'heart_atk_med': hasHeartAttack.value == 'Yes' ? heartAttackOnMedicine.value : '',
        'heart_atk_med_name_1': heartAttackMedName1Controller.text.trim(),
        'heart_atk_med_name_2': heartAttackMedName2Controller.text.trim(),
        'heart_atk_med_name_3': heartAttackMedName3Controller.text.trim(),
        'heart_atk_med_freq_1': heartAttackMedFreq1.value,
        'heart_atk_med_freq_2': heartAttackMedFreq2.value,
        'heart_atk_med_freq_3': heartAttackMedFreq3.value,

        'stroke': hasStroke.value,
        'stroke_when': hasStroke.value == 'Yes' ? (strokeYears.value == 'Select' ? '' : strokeYears.value) : '',
        'stroke_med': hasStroke.value == 'Yes' ? strokeOnMedicine.value : '',
        'stroke_med_name_1': strokeMedName1Controller.text.trim(),
        'stroke_med_name_2': strokeMedName2Controller.text.trim(),
        'stroke_med_name_3': strokeMedName3Controller.text.trim(),
        'stroke_med_freq_1': strokeMedFreq1.value,
        'stroke_med_freq_2': strokeMedFreq2.value,
        'stroke_med_freq_3': strokeMedFreq3.value,

        'kidney_failure': hasKidneyFailure.value,
        'kidney_fail_when': hasKidneyFailure.value == 'Yes' ? (kidneyFailureYears.value == 'Select' ? '' : kidneyFailureYears.value) : '',
        'kidney_fail_med': hasKidneyFailure.value == 'Yes' ? kidneyFailureOnMedicine.value : '',
        'kidney_fail_med_name_1': kidneyFailureMedName1Controller.text.trim(),
        'kidney_fail_med_name_2': kidneyFailureMedName2Controller.text.trim(),
        'kidney_fail_med_name_3': kidneyFailureMedName3Controller.text.trim(),
        'kidney_fail_med_freq_1': kidneyFailureMedFreq1.value,
        'kidney_fail_med_freq_2': kidneyFailureMedFreq2.value,
        'kidney_fail_med_freq_3': kidneyFailureMedFreq3.value,

        'angioplasty': hasAngioplasty.value,
        'angioplasty_when': hasAngioplasty.value == 'Yes' ? (angioplastyYears.value == 'Select' ? '' : angioplastyYears.value) : '',
        'angioplasty_med': hasAngioplasty.value == 'Yes' ? angioplastyOnMedicine.value : '',
        'angioplasty_med_name_1': angioplastyMedName1Controller.text.trim(),
        'angioplasty_med_name_2': angioplastyMedName2Controller.text.trim(),
        'angioplasty_med_name_3': angioplastyMedName3Controller.text.trim(),
        'angioplasty_med_freq_1': angioplastyMedFreq1.value,
        'angioplasty_med_freq_2': angioplastyMedFreq2.value,
        'angioplasty_med_freq_3': angioplastyMedFreq3.value,

        'bypass_surgery': hasBypass.value,
        'bypass_surg_when': hasBypass.value == 'Yes' ? (bypassYears.value == 'Select' ? '' : bypassYears.value) : '',
        'bypass_surg_med': hasBypass.value == 'Yes' ? bypassOnMedicine.value : '',
        'bypass_surg_med_name_1': bypassMedName1Controller.text.trim(),
        'bypass_surg_med_name_2': bypassMedName2Controller.text.trim(),
        'bypass_surg_med_name_3': bypassMedName3Controller.text.trim(),
        'bypass_surg_med_freq_1': bypassMedFreq1.value,
        'bypass_surg_med_freq_2': bypassMedFreq2.value,
        'bypass_surg_med_freq_3': bypassMedFreq3.value,

        'med_allergy': hasAllergy.value,
        'allergy_med_name_1': allergyMedName1Controller.text.trim(),
        'allergy_med_name_2': allergyMedName2Controller.text.trim(),
        'allergy_med_name_3': allergyMedName3Controller.text.trim(),

        'bleeding_tendency': hasBleedingTendency.value,
        'other_surgery': hasOtherSurgery.value,
        'other_surg_name_1': surgeryName1Controller.text.trim(),
        'other_surg_name_2': surgeryName2Controller.text.trim(),
        'other_surg_name_3': surgeryName3Controller.text.trim(),

        // Section 3 - Family History (defaulted to No to satisfy API required check)
        'heart_atk_family': 'No',
        'heart_atk_to': '',
        'age_when_hrt_atk': '',
        'stroke_family': 'No',
        'stroke_to': '',
        'age_when_stroke': '',
        'surgery_family': 'No',
        'surgery_to': '',
        'age_when_surgery': '',
        'death_in_family': 'No',
        'death_of': '',
        'age_when_death': '',
        'death_reason': '',

        // Section 4 - Habits (defaulted to No to satisfy API required check)
        'smoke': 'No',
        'alcohol': 'No',
        'extra_salt': 'No',
        'morning_walk': 'No',
        'yoga': 'No',

        // Section 5 - Vitals
        'height': '',
        'weight': '',
        'bp_systolic': '',
        'bp_diastolic': '',

        // Section 6 - Others
        'bp_apparatus': '',
        'have_glucometer': '',
        'give_other_info': '',
        'other_info': '',
      };

      // Section 1 report files
      for (int i = 0; i < htnReports.length; i++) {
        fields['htn_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(htnReports[i].path);
      }
      for (int i = 0; i < diabetesReports.length; i++) {
        fields['dia_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(diabetesReports[i].path);
      }
      for (int i = 0; i < thyroidReports.length; i++) {
        fields['thy_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(thyroidReports[i].path);
      }

      // Section 2 report files
      for (int i = 0; i < heartAttackReports.length; i++) {
        fields['hrt_atk_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(heartAttackReports[i].path);
      }
      for (int i = 0; i < strokeReports.length; i++) {
        fields['stroke_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(strokeReports[i].path);
      }
      for (int i = 0; i < kidneyFailureReports.length; i++) {
        fields['kidney_fail_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(kidneyFailureReports[i].path);
      }
      for (int i = 0; i < angioplastyReports.length; i++) {
        fields['angioplasty_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(angioplastyReports[i].path);
      }
      for (int i = 0; i < bypassReports.length; i++) {
        fields['bypass_surg_med_img_${i + 1}'] = await dio.MultipartFile.fromFile(bypassReports[i].path);
      }

      final formData = dio.FormData.fromMap(fields);

      final response = await apiClient.post(
        ApiEndpoints.medicalFormNew,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          Get.offAllNamed('/take-appointment', arguments: {
            'doctorId': doctorId,
            'doctorName': doctorName,
            'patientId': patientId,
            'userName': patientName,
            'userAge': patientAge,
            'userGender': gender,
            'type': userType,
            'speciality': speciality,
            'isFromDoctorHomeService': isFromDoctorHomeService,
            'doctor_hs_req_id': doctorHsReqId,
            'problem': problem,
          });
        } else {
          Get.snackbar('Error', response.data['msg'] ?? 'Failed to submit form');
        }
      } else {
        Get.snackbar('Error', 'Failed to submit. Server status: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred during submission: $e');
    }
  }
}
