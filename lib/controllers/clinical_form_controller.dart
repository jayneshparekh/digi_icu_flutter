import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/response/doctors/medical_form_response.dart';
import '../models/response/patients/clinical_form_details_model.dart';
import '../models/response/patients/last_symptoms_response.dart';
import '../services/api/api_client.dart';

class ClinicalFormController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();

  // Route arguments
  String doctorId = '';
  String doctorName = '';
  String patientId = '';
  String patientName = '';
  String appointmentId = '';
  String age = '';
  String place = 'Home';
  String height = '';
  String weight = '';
  String speciality = '';
  String doctorHsReqId = '';
  String formType = '';
  bool isFromDoctorHomeService = false;
  String isFrom = '';

  // Vitals obtained from last symptoms
  String thirdHeartRate = '';
  String thirdSys = '';
  String thirdDiast = '';
  String sugar = '';
  String fastingBsl = '';
  String afterFoodBsl = '';
  String randomBsl = '';
  String ecg = '';
  String ecgPdf = '';
  String ecgImg1 = '';
  String ecgImg2 = '';
  String ecgImg3 = '';
  String ecgImg4 = '';
  String ecgImg5 = '';
  String hbA1cInfo = '';
  String hbA1c = '';
  String hbA1cDate = '';
  String urineAlbuminInfo = '';
  String urineAlbumin = '';
  String urinAlbuminReport = '';

  // UI state
  final RxBool isLoading = false.obs;
  final RxString selectedPlace = 'Home'.obs;
  final RxBool haveBPApparatus = true.obs;
  final RxString spo2Choice = ''.obs; // Yes / No

  // Section 1 Controllers
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseRateController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final spo2Controller = TextEditingController();

  // Section 2 UI State (Toggles)
  final RxBool checkSugarVal = false.obs;
  final RxBool cbCreatinine = false.obs;
  final RxBool cbHba1c = false.obs;
  final RxBool cbCholesterol = false.obs;
  final RxBool cbThyroid = false.obs;
  final RxBool cbUricAcid = false.obs;
  final RxBool cbUrineAlbumin = false.obs;
  final RxBool cbEcg = false.obs;
  final RxString hba1cDateChoice = 'Today'.obs; // Today / Yesterday / Custom Date
  final RxString urineAlbuminType = 'Numeric'.obs; // Numeric / Value
  final RxString urineAlbuminValueSelected = 'Select'.obs; // Select, Negative, Trace, Positive
  final RxString otherInvestigationsChoice = 'No'.obs; // Yes / No

  // Section 2 Controllers
  final fastingController = TextEditingController();
  final afterFoodController = TextEditingController();
  final randomController = TextEditingController();
  final creatinineController = TextEditingController();
  final hba1cController = TextEditingController();
  final totalCholesterolController = TextEditingController();
  final hdlController = TextEditingController();
  final ldlController = TextEditingController();
  final vldlController = TextEditingController();
  final t3Controller = TextEditingController();
  final t4Controller = TextEditingController();
  final tshController = TextEditingController();
  final uricAcidController = TextEditingController();
  final urineAlbuminNumericController = TextEditingController();
  final otherInvestigationsController = TextEditingController();

  // Selected Images
  final RxList<XFile> ecgReportImages = <XFile>[].obs;
  final RxList<XFile> otherReportImages = <XFile>[].obs;

  // Section 3 UI State
  final RxString improvement = 'This is my first consultation'.obs;
  final RxString chestPain = ''.obs;
  final RxString chestPainSweating = ''.obs;
  final RxString breathlessness = ''.obs;
  final RxString breathlessWhile = ''.obs;
  final RxString palpitations = ''.obs;
  final RxString giddiness = ''.obs;
  final RxString headache = ''.obs;
  final RxString dizziness = ''.obs;
  final RxString bleedingEpisode = ''.obs;
  final RxString otherSymptomsChoice = 'No'.obs;

  // Section 3 Controllers
  final otherSymptomsController = TextEditingController();
  final systolic2Controller = TextEditingController();
  final diastolic2Controller = TextEditingController();
  final heartRate2Controller = TextEditingController();
  final dizzinessSystolicController = TextEditingController();
  final dizzinessDiastolicController = TextEditingController();

  // Section 4 UI State
  final RxString smoking = ''.obs;
  final RxString alcohol = ''.obs;
  final RxString reduceSalt = ''.obs;
  final RxString exercise = ''.obs;
  final RxString inStress = ''.obs;
  final RxString missMedicine = ''.obs;
  final RxString lastHospitalization = ''.obs;
  final RxString hospitalizationReasonSelected = 'Select'.obs;
  final RxString remindMedicine = 'No'.obs;
  final RxString setAlarm = 'No'.obs;

  // Section 4 Controllers
  final hospitalizationReasonCustomController = TextEditingController();
  final systolic3Controller = TextEditingController();
  final diastolic3Controller = TextEditingController();
  final heartRate3Controller = TextEditingController();

  final mClinicalFormData = ClinicalFormDetailsModel();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      doctorId = args['doctorId']?.toString() ?? '';
      doctorName = args['doctorName']?.toString() ?? '';
      patientId = args['patientId']?.toString() ?? '';
      patientName = args['patientName']?.toString() ?? '';
      appointmentId = args['appointmentId']?.toString() ?? '';
      age = args['age']?.toString() ?? '';
      place = args['place']?.toString() ?? 'Home';
      height = args['height']?.toString() ?? '';
      weight = args['weight']?.toString() ?? '';
      speciality = args['speciality']?.toString() ?? '';
      doctorHsReqId = args['doctor_hs_req_id']?.toString() ?? '';
      formType = args['formType']?.toString() ?? '';
      isFromDoctorHomeService = args['isFromDoctorHomeService'] as bool? ?? false;
      isFrom = args['isFrom']?.toString() ?? '';

      selectedPlace.value = place;
      mClinicalFormData.place = place;

      if (height.isNotEmpty) heightController.text = height;
      if (weight.isNotEmpty) weightController.text = weight;
    }

    lastSymptoms();
    getMedicalFormData();
  }

  void selectPlace(String val) {
    selectedPlace.value = val;
    mClinicalFormData.place = val;
  }

  void toggleBPApparatus(bool hasApparatus) {
    haveBPApparatus.value = hasApparatus;
  }

  void selectSpo2Choice(String choice) {
    spo2Choice.value = choice;
  }

  Future<void> lastSymptoms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.lastSymptoms,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = LastSymptomsResponse.fromJson(response.data);
        if (res.status == 'success' && res.data != null) {
          final d = res.data!;
          if (d.height != null) heightController.text = d.height!;
          if (d.sitRightSys != null) systolicController.text = d.sitRightSys!;
          if (d.sitRightDiast != null) diastolicController.text = d.sitRightDiast!;
          if (d.sitRightHeartRate != null) pulseRateController.text = d.sitRightHeartRate!;
          if (d.weight != null) weightController.text = d.weight!;
          
          thirdSys = d.bpSys ?? '';
          thirdDiast = d.bpDiast ?? '';
          thirdHeartRate = d.bpHeartRate ?? '';
          sugar = d.checkSugarNow ?? '';
          fastingBsl = d.fastingBsl ?? '';
          afterFoodBsl = d.afterFoodBsl ?? '';
          randomBsl = d.randomBsl ?? '';
          ecg = d.ecg ?? '';
          ecgPdf = d.ecgPdf ?? '';
          ecgImg1 = d.ecgImage1 ?? '';
          ecgImg2 = d.ecgImage2 ?? '';
          ecgImg3 = d.ecgImage3 ?? '';
          ecgImg4 = d.ecgImage4 ?? '';
          ecgImg5 = d.ecgImage5 ?? '';
          hbA1cInfo = d.hba1cInfo ?? '';
          hbA1c = d.hba1c ?? '';
          hbA1cDate = d.hba1cDate ?? '';
          urineAlbuminInfo = d.urineAlbuminInfo ?? '';
          urineAlbumin = d.urineAlbumin ?? '';
          urinAlbuminReport = d.urineAlbuminReport ?? '';

          // Pre-populate Section 2 details if available
          if (sugar == 'Yes') {
            checkSugarVal.value = true;
          }
          if (fastingBsl.isNotEmpty) fastingController.text = fastingBsl;
          if (afterFoodBsl.isNotEmpty) afterFoodController.text = afterFoodBsl;
          if (randomBsl.isNotEmpty) randomController.text = randomBsl;

          if (hbA1cInfo == 'Yes') {
            cbHba1c.value = true;
          }
          if (hbA1c.isNotEmpty) hba1cController.text = hbA1c;
          if (hbA1cDate.isNotEmpty) {
            hba1cDateChoice.value = hbA1cDate;
          }

          if (urineAlbuminInfo == 'Yes') {
            cbUrineAlbumin.value = true;
          }
          if (urineAlbumin.isNotEmpty) {
            urineAlbuminType.value = 'Numeric';
            urineAlbuminNumericController.text = urineAlbumin;
          }
          if (urinAlbuminReport.isNotEmpty) {
            urineAlbuminType.value = 'Value';
            urineAlbuminValueSelected.value = urinAlbuminReport;
          }

          if (ecg == 'Yes') {
            cbEcg.value = true;
          }
        }
      }
    } catch (e) {
      // Handle silently
    }
  }

  Future<void> getMedicalFormData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getMedicalForm,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = MedicalFormResponse.fromJson(response.data);
        if (res.status == 'success' && res.data != null) {
          if (res.data!.height != null && res.data!.height!.isNotEmpty) {
            heightController.text = res.data!.height!;
          }
          if (res.data!.weight != null && res.data!.weight!.isNotEmpty) {
            weightController.text = res.data!.weight!;
          }
        }
      }
    } catch (e) {
      // Handle silently
    }
  }

  Future<void> pickEcgImage(ImageSource source) async {
    if (ecgReportImages.length >= 3) {
      Get.snackbar('Limit Reached', 'You can upload up to 3 ECG images');
      return;
    }
    final XFile? img = await _picker.pickImage(source: source);
    if (img != null) {
      ecgReportImages.add(img);
    }
  }

  void removeEcgImage(int index) {
    ecgReportImages.removeAt(index);
  }

  Future<void> pickOtherImage(ImageSource source) async {
    if (otherReportImages.length >= 3) {
      Get.snackbar('Limit Reached', 'You can upload up to 3 investigation images');
      return;
    }
    final XFile? img = await _picker.pickImage(source: source);
    if (img != null) {
      otherReportImages.add(img);
    }
  }

  void removeOtherImage(int index) {
    otherReportImages.removeAt(index);
  }

  bool checkValidation() {
    if (haveBPApparatus.value) {
      final sysText = systolicController.text.trim();
      final diastText = diastolicController.text.trim();

      if (sysText.isEmpty) {
        Get.snackbar('Validation Error', 'Enter Systolic BP');
        return false;
      }
      final sysVal = int.tryParse(sysText) ?? 0;
      if (sysVal < 20 || sysVal > 300) {
        Get.snackbar('Validation Error', 'Enter valid Systolic BP (20-300)');
        return false;
      }

      if (diastText.isEmpty) {
        Get.snackbar('Validation Error', 'Enter Diastolic BP');
        return false;
      }
      final diastVal = int.tryParse(diastText) ?? 0;
      if (diastVal < 20 || diastVal > 140) {
        Get.snackbar('Validation Error', 'Enter valid Diastolic BP (20-140)');
        return false;
      }
    }

    if (spo2Choice.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose SpO2 option');
      return false;
    }

    final hText = heightController.text.trim();
    if (hText.isNotEmpty) {
      final hVal = int.tryParse(hText) ?? 0;
      if (hVal < 10 || hVal > 200) {
        Get.snackbar('Validation Error', 'Enter valid height (10-200)');
        return false;
      }
    }

    final wText = weightController.text.trim();
    if (wText.isNotEmpty) {
      final wVal = int.tryParse(wText) ?? 0;
      if (wVal < 10 || wVal > 150) {
        Get.snackbar('Validation Error', 'Enter valid weight (10-150)');
        return false;
      }
    }

    return true;
  }

  void submit() {
    mClinicalFormData.systolic1 = systolicController.text.trim();
    mClinicalFormData.diastolic1 = diastolicController.text.trim();
    mClinicalFormData.heartRate1 = pulseRateController.text.trim();
    mClinicalFormData.height = heightController.text.trim();
    mClinicalFormData.weight = weightController.text.trim();
    mClinicalFormData.spo2 = spo2Choice.value;
    mClinicalFormData.spo2Details = spo2Controller.text.trim();
    mClinicalFormData.bpApparatus = haveBPApparatus.value ? 'Yes' : 'No';

    if (mClinicalFormData.height.isNotEmpty && mClinicalFormData.weight.isNotEmpty) {
      final weightVal = double.tryParse(mClinicalFormData.weight) ?? 0.0;
      final heightVal = (double.tryParse(mClinicalFormData.height) ?? 0.0) / 100;
      if (heightVal > 0) {
        final bmi = weightVal / (heightVal * heightVal);
        mClinicalFormData.bmi = bmi.toStringAsFixed(1);
      }
    } else {
      mClinicalFormData.bmi = '';
    }

    if (checkValidation()) {
      Get.toNamed('/clinical-form-sec2');
    }
  }

  bool checkValidationSec2() {
    if (checkSugarVal.value) {
      if (fastingController.text.trim().isEmpty &&
          afterFoodController.text.trim().isEmpty &&
          randomController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Fasting, After Food or Random sugar value must be filled');
        return false;
      }
    }

    if (cbCreatinine.value) {
      if (creatinineController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter Creatinine value');
        return false;
      }
    }

    if (cbHba1c.value) {
      if (hba1cController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter HbA1c value');
        return false;
      }
    }

    if (cbCholesterol.value) {
      if (totalCholesterolController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter Total Cholesterol value');
        return false;
      }
    }

    if (cbThyroid.value) {
      if (t3Controller.text.trim().isEmpty ||
          t4Controller.text.trim().isEmpty ||
          tshController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter all Thyroid values');
        return false;
      }
    }

    if (cbUricAcid.value) {
      if (uricAcidController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter Uric Acid value');
        return false;
      }
    }

    if (cbUrineAlbumin.value) {
      if (urineAlbuminType.value == 'Numeric') {
        if (urineAlbuminNumericController.text.trim().isEmpty) {
          Get.snackbar('Validation Error', 'Please enter Urine Albumin value');
          return false;
        }
      } else {
        if (urineAlbuminValueSelected.value == 'Select') {
          Get.snackbar('Validation Error', 'Please select Urine Albumin value option');
          return false;
        }
      }
    }

    if (otherInvestigationsChoice.value == 'Yes') {
      if (otherInvestigationsController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please describe other investigations');
        return false;
      }
    }

    return true;
  }

  void submitSec2() {
    mClinicalFormData.checkSugar = checkSugarVal.value ? 'Yes' : 'No';
    mClinicalFormData.fasting = fastingController.text.trim();
    mClinicalFormData.afterFood = afterFoodController.text.trim();
    mClinicalFormData.random = randomController.text.trim();

    mClinicalFormData.creatinine = creatinineController.text.trim();
    mClinicalFormData.totalCholesterol = totalCholesterolController.text.trim();
    mClinicalFormData.hdl = hdlController.text.trim();
    mClinicalFormData.ldl = ldlController.text.trim();
    mClinicalFormData.vldl = vldlController.text.trim();

    mClinicalFormData.hba1c = hba1cController.text.trim();
    mClinicalFormData.hba1cDate = hba1cDateChoice.value;

    mClinicalFormData.urineAlbumin = urineAlbuminType.value;
    if (urineAlbuminType.value == 'Numeric') {
      mClinicalFormData.urineAlbuminReport = urineAlbuminNumericController.text.trim();
    } else {
      mClinicalFormData.urineAlbuminReport = urineAlbuminValueSelected.value == 'Select'
          ? ''
          : urineAlbuminValueSelected.value;
    }

    mClinicalFormData.ecg = cbEcg.value ? 'Yes' : 'No';
    mClinicalFormData.thyroid = cbThyroid.value ? 'Yes' : 'No';
    mClinicalFormData.t3 = t3Controller.text.trim();
    mClinicalFormData.t4 = t4Controller.text.trim();
    mClinicalFormData.tsh = tshController.text.trim();
    mClinicalFormData.uricAcid = uricAcidController.text.trim();

    mClinicalFormData.otherInvestigations = otherInvestigationsChoice.value;
    mClinicalFormData.investigationDetails = otherInvestigationsController.text.trim();

    // Map selected images paths
    if (ecgReportImages.isNotEmpty) {
      mClinicalFormData.ecgImage1 = ecgReportImages[0].path;
      if (ecgReportImages.length > 1) mClinicalFormData.ecgImage2 = ecgReportImages[1].path;
      if (ecgReportImages.length > 2) mClinicalFormData.ecgImage3 = ecgReportImages[2].path;
    }

    if (otherReportImages.isNotEmpty) {
      mClinicalFormData.investigationImage1 = otherReportImages[0].path;
      if (otherReportImages.length > 1) mClinicalFormData.investigationImage2 = otherReportImages[1].path;
      if (otherReportImages.length > 2) mClinicalFormData.investigationImage3 = otherReportImages[2].path;
    }

    if (checkValidationSec2()) {
      Get.toNamed('/clinical-form-sec3');
    }
  }

  bool checkValidationSec3() {
    if (improvement.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please select feeling compared to last visit option');
      return false;
    }
    if (chestPain.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose chest pain option');
      return false;
    }
    if (chestPain.value == 'Yes' && chestPainSweating.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose if chest pain has sweating');
      return false;
    }
    if (breathlessness.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose breathlessness option');
      return false;
    }
    if (breathlessness.value == 'Yes' && breathlessWhile.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose breathlessness during activity');
      return false;
    }
    if (palpitations.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose palpitations option');
      return false;
    }
    if (giddiness.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose giddiness option');
      return false;
    }
    if (headache.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose headache option');
      return false;
    }
    if (dizziness.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose dizziness option');
      return false;
    }
    if (bleedingEpisode.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose bleeding episode option');
      return false;
    }
    if (otherSymptomsChoice.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose other symptoms option');
      return false;
    }
    if (otherSymptomsChoice.value == 'Yes' && otherSymptomsController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter other symptoms details');
      return false;
    }
    return true;
  }

  void submitSec3() {
    mClinicalFormData.improvement = improvement.value;
    mClinicalFormData.chestPain = chestPain.value;
    mClinicalFormData.chestPainSweating = chestPainSweating.value;
    mClinicalFormData.breathlessness = breathlessness.value;
    mClinicalFormData.breathlessWhile = breathlessWhile.value;
    mClinicalFormData.palpitations = palpitations.value;
    mClinicalFormData.giddiness = giddiness.value;
    mClinicalFormData.headache = headache.value;
    mClinicalFormData.dizziness = dizziness.value;
    mClinicalFormData.bleedingEpisode = bleedingEpisode.value;
    mClinicalFormData.otherSymptoms = otherSymptomsChoice.value == 'Yes' ? 'Yes' : 'None';
    mClinicalFormData.otherSymptomsDetails = otherSymptomsController.text.trim();

    mClinicalFormData.systolic2 = systolic2Controller.text.trim();
    mClinicalFormData.diastolic2 = diastolic2Controller.text.trim();
    mClinicalFormData.dizzinessSystolic = dizzinessSystolicController.text.trim();
    mClinicalFormData.dizzinessDiaStolic = dizzinessDiastolicController.text.trim();
    mClinicalFormData.heartRate2 = heartRate2Controller.text.trim();

    if (checkValidationSec3()) {
      Get.toNamed('/clinical-form-sec4');
    }
  }

  bool checkValidationSec4() {
    if (reduceSalt.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose if you reduced salt intake');
      return false;
    }
    if (exercise.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose if you go for morning walks');
      return false;
    }
    if (inStress.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose if you are in stress');
      return false;
    }
    if (missMedicine.value.isEmpty && speciality.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose if you missed medication doses');
      return false;
    }
    if (haveBPApparatus.value) {
      if (systolic3Controller.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter Systolic BP value');
        return false;
      }
      final sysVal = int.tryParse(systolic3Controller.text.trim()) ?? 0;
      if (sysVal < 20 || sysVal > 300) {
        Get.snackbar('Validation Error', 'Enter valid Systolic BP (20-300)');
        return false;
      }

      if (diastolic3Controller.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please enter Diastolic BP value');
        return false;
      }
      final diastVal = int.tryParse(diastolic3Controller.text.trim()) ?? 0;
      if (diastVal < 20 || diastVal > 140) {
        Get.snackbar('Validation Error', 'Enter valid Diastolic BP (20-140)');
        return false;
      }
    }
    if (lastHospitalization.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please choose last hospitalization option');
      return false;
    }
    if (lastHospitalization.value == 'Yes') {
      if (hospitalizationReasonSelected.value == 'Select') {
        Get.snackbar('Validation Error', 'Please select hospitalization reason');
        return false;
      }
      if (hospitalizationReasonSelected.value == 'other' &&
          hospitalizationReasonCustomController.text.trim().isEmpty) {
        Get.snackbar('Validation Error', 'Please specify other hospitalization reason');
        return false;
      }
    }
    return true;
  }

  Future<void> submitSec4() async {
    mClinicalFormData.smoking = smoking.value;
    mClinicalFormData.alcohol = alcohol.value;
    mClinicalFormData.reduceSalt = reduceSalt.value;
    mClinicalFormData.exercise = exercise.value;
    mClinicalFormData.inStress = inStress.value;
    mClinicalFormData.missMedicine = missMedicine.value;
    mClinicalFormData.lastHospitalization = lastHospitalization.value;
    if (lastHospitalization.value == 'Yes') {
      mClinicalFormData.hospitalizationReason = hospitalizationReasonSelected.value == 'other'
          ? hospitalizationReasonCustomController.text.trim()
          : hospitalizationReasonSelected.value;
    } else {
      mClinicalFormData.hospitalizationReason = '';
    }

    mClinicalFormData.systolic3 = systolic3Controller.text.trim();
    mClinicalFormData.diastolic3 = diastolic3Controller.text.trim();
    mClinicalFormData.heartRate3 = heartRate3Controller.text.trim();
    mClinicalFormData.remindMedicine = remindMedicine.value;
    mClinicalFormData.setAlarm = setAlarm.value;

    if (!checkValidationSec4()) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final Map<String, dynamic> fields = {
        'patient_id': patientId,
        'appointment_id': appointmentId,
        'form_type': formType,
        'place': mClinicalFormData.place,
        'have_bp_apparatus': haveBPApparatus.value ? 'Yes' : 'No',
        'systolic_1': mClinicalFormData.systolic1,
        'diastolic_1': mClinicalFormData.diastolic1,
        'heart_rate_1': mClinicalFormData.heartRate1,
        'spo2': mClinicalFormData.spo2,
        'spo2_value': mClinicalFormData.spo2Details,
        'height': mClinicalFormData.height,
        'weight': mClinicalFormData.weight,
        'bmi': mClinicalFormData.bmi,
        'investigations': mClinicalFormData.investigations,
        'creatinine': mClinicalFormData.creatinine,
        'total_cholesterol': mClinicalFormData.totalCholesterol,
        'hdl': mClinicalFormData.hdl,
        'ldl': mClinicalFormData.ldl,
        'vldl': mClinicalFormData.vldl,
        'hba1c': mClinicalFormData.hba1c,
        'hba1c_date': mClinicalFormData.hba1cDate,
        'uric_acid': mClinicalFormData.uricAcid,
        'urine_albumin': mClinicalFormData.urineAlbumin,
        'urine_albumin_report': mClinicalFormData.urineAlbuminReport,
        'ecg': mClinicalFormData.ecg,
        'other_investigations': mClinicalFormData.otherInvestigations,
        'investigation_details': mClinicalFormData.investigationDetails,
        'check_sugar': mClinicalFormData.checkSugar,
        'fasting': mClinicalFormData.fasting,
        'after_food': mClinicalFormData.afterFood,
        'random': mClinicalFormData.random,
        'thyroid': mClinicalFormData.thyroid,
        't3': mClinicalFormData.t3,
        't4': mClinicalFormData.t4,
        'tsh': mClinicalFormData.tsh,
        'improvement': mClinicalFormData.improvement,
        'chest_pain': mClinicalFormData.chestPain,
        'chest_pain_sweating': mClinicalFormData.chestPainSweating,
        'breathlessness': mClinicalFormData.breathlessness,
        'breathless_while': mClinicalFormData.breathlessWhile,
        'palpitations': mClinicalFormData.palpitations,
        'giddiness': mClinicalFormData.giddiness,
        'headache': mClinicalFormData.headache,
        'dizziness': mClinicalFormData.dizziness,
        'dizziness_systolic': mClinicalFormData.dizzinessSystolic,
        'dizziness_diastolic': mClinicalFormData.dizzinessDiaStolic,
        'other_symptoms': mClinicalFormData.otherSymptoms,
        'other_symptom_details': mClinicalFormData.otherSymptomsDetails,
        'systolic_2': mClinicalFormData.systolic2,
        'diastolic_2': mClinicalFormData.diastolic2,
        'heart_rate_2': mClinicalFormData.heartRate2,
        'bleeding_episode': mClinicalFormData.bleedingEpisode,
        'reduce_salt': mClinicalFormData.reduceSalt,
        'exercise': mClinicalFormData.exercise,
        'in_stress': mClinicalFormData.inStress,
        'miss_medicine': mClinicalFormData.missMedicine,
        'set_alarm': mClinicalFormData.setAlarm,
        'remind_medicine': mClinicalFormData.remindMedicine,
        'systolic_3': mClinicalFormData.systolic3,
        'diastolic_3': mClinicalFormData.diastolic3,
        'heart_rate_3': mClinicalFormData.heartRate3,
        'smoking': mClinicalFormData.smoking,
        'alcohol': mClinicalFormData.alcohol,
        'last_hospitalization': mClinicalFormData.lastHospitalization,
        'hospitalization_reason': mClinicalFormData.hospitalizationReason,
      };

      // Add files to multipart request
      if (mClinicalFormData.ecgImage1.isNotEmpty) {
        fields['ecg_image_1'] = await dio.MultipartFile.fromFile(mClinicalFormData.ecgImage1);
      }
      if (mClinicalFormData.ecgImage2.isNotEmpty) {
        fields['ecg_image_2'] = await dio.MultipartFile.fromFile(mClinicalFormData.ecgImage2);
      }
      if (mClinicalFormData.ecgImage3.isNotEmpty) {
        fields['ecg_image_3'] = await dio.MultipartFile.fromFile(mClinicalFormData.ecgImage3);
      }
      if (mClinicalFormData.ecgPdf.isNotEmpty) {
        fields['ecg_pdf'] = await dio.MultipartFile.fromFile(mClinicalFormData.ecgPdf);
      }
      if (mClinicalFormData.investigationImage1.isNotEmpty) {
        fields['investigation_img_1'] = await dio.MultipartFile.fromFile(mClinicalFormData.investigationImage1);
      }
      if (mClinicalFormData.investigationImage2.isNotEmpty) {
        fields['investigation_img_2'] = await dio.MultipartFile.fromFile(mClinicalFormData.investigationImage2);
      }
      if (mClinicalFormData.investigationImage3.isNotEmpty) {
        fields['investigation_img_3'] = await dio.MultipartFile.fromFile(mClinicalFormData.investigationImage3);
      }

      final formData = dio.FormData.fromMap(fields);

      final response = await apiClient.post(
        ApiEndpoints.clinicalFormNew,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          Get.snackbar('Success', response.data['msg'] ?? 'Clinical form submitted successfully');
          if (isFromDoctorHomeService) {
            Get.offAllNamed('/patient-list', arguments: {'doctor_hs_req_id': doctorHsReqId});
          } else {
            // Show optional video popup dialog or go back to home
            Get.defaultDialog(
              title: 'Form Submitted',
              middleText: 'Do you want to upload self video of your problems ?',
              textConfirm: 'Yes',
              textCancel: 'No',
              confirmTextColor: AppColors.white,
              buttonColor: AppColors.teal,
              onConfirm: () {
                Get.back();
                Get.snackbar('Video Upload', 'Video upload is currently placeholder');
                Get.offAllNamed('/manage-patients');
              },
              onCancel: () {
                Get.offAllNamed('/manage-patients');
              },
            );
          }
        } else {
          Get.snackbar('Error', response.data['msg'] ?? 'Submission failed');
        }
      } else {
        Get.snackbar('Error', 'Submission failed. Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred during submission: $e');
    }
  }
}



