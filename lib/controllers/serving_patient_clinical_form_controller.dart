import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/response/patients/clinical_form_details_model.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';

class ServingPatientClinicalFormController extends GetxController {
  final ApiClient _apiClient = Get.isRegistered<ApiClient>()
      ? Get.find<ApiClient>()
      : ApiClient();

  // Navigation & Arguments
  String patientId = '';
  String patientName = '';
  String doctorId = '';
  String doctorName = '';
  String formId = '';
  String formType = 'Clinical Form';

  final isChange = true.obs;
  final isPatientMode = false.obs;
  final isLoading = false.obs;

  // Section 1: Place & Vitals
  final place = ''.obs; // Home, Office, Clinic, Outdoor
  final haveBPApparatus = true.obs;

  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final pulseRateController = TextEditingController();

  final spo2Choice = 'No'.obs; // Yes, No
  final spo2Controller = TextEditingController();

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // Section 2: Laboratory & Investigations
  final checkSugarVal = false.obs;
  final fastingController = TextEditingController();
  final afterFoodController = TextEditingController();
  final randomController = TextEditingController();

  final cbCreatinine = false.obs;
  final creatinineController = TextEditingController();

  final cbHba1c = false.obs;
  final hba1cController = TextEditingController();
  final hba1cDateChoice = 'Today'.obs; // Today, Yesterday, or formatted date

  final cbCholesterol = false.obs;
  final totalCholesterolController = TextEditingController();
  final hdlController = TextEditingController();
  final ldlController = TextEditingController();
  final vldlController = TextEditingController();

  final cbUricAcid = false.obs;
  final uricAcidController = TextEditingController();

  final cbUrineAlbumin = false.obs;
  final urineAlbuminType = 'Numeric'.obs; // Numeric, Value
  final urineAlbuminNumericController = TextEditingController();
  final urineAlbuminValueSelected =
      'Select'.obs; // Select, Negative, Trace, Positive

  final cbEcg = false.obs;
  final ecgReportImages = <XFile>[].obs;

  final cbThyroid = false.obs;
  final t3Controller = TextEditingController();
  final t4Controller = TextEditingController();
  final tshController = TextEditingController();

  // Section 3: Symptoms State
  final feelingCompared =
      'Good'.obs; // Good, Better, Same, More Suffering, First Consultation
  final chestPain = 'No'.obs; // Yes, No
  final chestPainSweating = 'No'.obs; // Yes, No
  final difficultyBreathing = 'No'.obs; // Yes, No
  final breathingWhile = 'Walking'.obs; // Walking, At Rest
  final palpitations = 'No'.obs; // Yes, No
  final giddiness = 'No'.obs; // Yes, No
  final headache = 'No'.obs; // Yes, No
  final feelDizziness = 'No'.obs; // Yes, No
  final dizzinessSystolicController = TextEditingController();
  final dizzinessDiastolicController = TextEditingController();
  final bleedingEpisode = 'No'.obs; // Yes, No
  final otherSymptomsRadio = 'None'.obs; // Yes, None
  final otherSymptomsController = TextEditingController();

  // Section 4: About Habits State
  final stopSmoking = 'No'.obs; // Yes, No, Need Help
  final stopAlcohol = 'No'.obs; // Yes, No, Need Help
  final reduceSaltIntake = 'No'.obs; // Yes, No
  final morningWalk = 'No'.obs; // Yes, No, Sometimes Missing
  final areYouInStress = 'No'.obs; // Yes, No
  final missMedicine = 'No'.obs; // Yes, No
  final lastHospitalization = 'No'.obs; // Yes, No
  final hospitalizationReasonSelected = 'Select'.obs;
  final otherHospitalizationReasonController = TextEditingController();

  // Repeat BP Readings (Sections 3 & 4)
  final systolic2Controller = TextEditingController();
  final diastolic2Controller = TextEditingController();
  final pulseRate2Controller = TextEditingController();

  final systolic3Controller = TextEditingController();
  final diastolic3Controller = TextEditingController();
  final pulseRate3Controller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final calculatedBmi = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    _initListeners();
    if (formId.isNotEmpty) {
      fetchClinicalFormData();
    }
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map) {
      patientId = args['patientId']?.toString() ?? '';
      patientName = args['patientName']?.toString() ?? '';
      doctorId = args['doctorId']?.toString() ?? '';
      doctorName = args['doctorName']?.toString() ?? '';
      formId = args['formId']?.toString() ?? '';
      formType = args['formType']?.toString() ?? 'Clinical Form';
      if (args.containsKey('isChange')) {
        isChange.value = args['isChange'] == true;
      }
      if (args.containsKey('isPatientMode')) {
        isPatientMode.value = args['isPatientMode'] == true;
      }
      if (args.containsKey('formData') &&
          args['formData'] is ClinicalFormDetailsModel) {
        populateFromModel(args['formData'] as ClinicalFormDetailsModel);
      }
    }
  }

  void _initListeners() {
    heightController.addListener(calculateBmi);
    weightController.addListener(calculateBmi);
  }

  void calculateBmi() {
    final hStr = heightController.text.trim();
    final wStr = weightController.text.trim();
    final h = double.tryParse(hStr);
    final w = double.tryParse(wStr);
    if (h != null && w != null && h > 0 && w > 0) {
      final hInM = h / 100.0;
      final bmi = w / (hInM * hInM);
      calculatedBmi.value = bmi.toStringAsFixed(1);
    } else {
      calculatedBmi.value = '';
    }
  }

  Future<void> fetchClinicalFormData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await _apiClient.post(
        ApiEndpoints.getClinicalForm,
        data: {'form_id': formId},
        options: dio.Options(
          headers: token.isNotEmpty ? {'Authorization': token} : null,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> rawMap =
            response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);

        final dataMap = rawMap['data'] is Map<String, dynamic>
            ? rawMap['data'] as Map<String, dynamic>
            : (rawMap['data'] is Map
                  ? Map<String, dynamic>.from(rawMap['data'] as Map)
                  : rawMap);

        final model = ClinicalFormDetailsModel.fromJson(dataMap);
        populateFromModel(model);
      }
    } catch (e) {
      debugPrint('Error fetching clinical form data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void populateFromModel(ClinicalFormDetailsModel model) {
    place.value = model.place;
    haveBPApparatus.value =
        model.bpApparatus.isEmpty || model.bpApparatus != 'No';

    systolicController.text = model.systolic1;
    diastolicController.text = model.diastolic1;
    pulseRateController.text = model.heartRate1;

    spo2Choice.value = model.spo2 == 'Yes' ? 'Yes' : 'No';
    spo2Controller.text = model.spo2 == 'Yes' ? model.spo2Details : '0';

    heightController.text = model.height;
    weightController.text = model.weight;
    calculateBmi();

    checkSugarVal.value =
        model.checkSugar == 'Yes' ||
        model.fasting.isNotEmpty ||
        model.afterFood.isNotEmpty ||
        model.random.isNotEmpty;
    fastingController.text = model.fasting;
    afterFoodController.text = model.afterFood;
    randomController.text = model.random;

    cbCreatinine.value = model.creatinine.isNotEmpty;
    creatinineController.text = model.creatinine;

    cbHba1c.value = model.hba1c.isNotEmpty;
    hba1cController.text = model.hba1c;
    hba1cDateChoice.value = model.hba1cDate.isEmpty ? 'Today' : model.hba1cDate;

    cbCholesterol.value =
        model.totalCholesterol.isNotEmpty ||
        model.hdl.isNotEmpty ||
        model.ldl.isNotEmpty ||
        model.vldl.isNotEmpty;
    totalCholesterolController.text = model.totalCholesterol;
    hdlController.text = model.hdl;
    ldlController.text = model.ldl;
    vldlController.text = model.vldl;

    cbUricAcid.value = model.uricAcid.isNotEmpty;
    uricAcidController.text = model.uricAcid;

    cbUrineAlbumin.value =
        model.urineAlbumin.isNotEmpty || model.urineAlbuminReport.isNotEmpty;
    urineAlbuminType.value =
        (model.urineAlbumin == 'Value' ||
            model.urineAlbuminReport == 'Negative' ||
            model.urineAlbuminReport == 'Trace' ||
            model.urineAlbuminReport == 'Positive')
        ? 'Value'
        : 'Numeric';
    if (urineAlbuminType.value == 'Numeric') {
      urineAlbuminNumericController.text = model.urineAlbuminReport;
    } else {
      urineAlbuminValueSelected.value = model.urineAlbuminReport.isEmpty
          ? 'Select'
          : model.urineAlbuminReport;
    }

    cbEcg.value =
        model.ecg == 'Yes' ||
        model.ecgImage1.isNotEmpty ||
        model.ecgPdf.isNotEmpty;
    cbThyroid.value =
        model.thyroid == 'Yes' ||
        model.t3.isNotEmpty ||
        model.t4.isNotEmpty ||
        model.tsh.isNotEmpty;
    t3Controller.text = model.t3;
    t4Controller.text = model.t4;
    tshController.text = model.tsh;

    feelingCompared.value = model.improvement.isEmpty
        ? 'Good'
        : model.improvement;
    chestPain.value = model.chestPain.isEmpty ? 'No' : model.chestPain;
    chestPainSweating.value = model.chestPainSweating.isEmpty
        ? 'No'
        : model.chestPainSweating;
    difficultyBreathing.value = model.breathlessness.isEmpty
        ? 'No'
        : model.breathlessness;
    breathingWhile.value = model.breathlessWhile.isEmpty
        ? 'Walking'
        : model.breathlessWhile;
    palpitations.value = model.palpitations.isEmpty ? 'No' : model.palpitations;
    giddiness.value = model.giddiness.isEmpty ? 'No' : model.giddiness;
    headache.value = model.headache.isEmpty ? 'No' : model.headache;
    feelDizziness.value = model.dizziness.isEmpty ? 'No' : model.dizziness;
    dizzinessSystolicController.text = model.dizzinessSystolic;
    dizzinessDiastolicController.text = model.dizzinessDiaStolic;
    bleedingEpisode.value = model.bleedingEpisode.isEmpty
        ? 'No'
        : model.bleedingEpisode;
    otherSymptomsRadio.value =
        model.otherSymptomsDetails.isNotEmpty || model.otherSymptoms == 'Yes'
        ? 'Yes'
        : 'None';
    otherSymptomsController.text = model.otherSymptomsDetails.isNotEmpty
        ? model.otherSymptomsDetails
        : model.otherSymptoms;

    systolic2Controller.text = model.systolic2;
    diastolic2Controller.text = model.diastolic2;
    pulseRate2Controller.text = model.heartRate2;

    stopSmoking.value = model.smoking.isEmpty ? 'No' : model.smoking;
    stopAlcohol.value = model.alcohol.isEmpty ? 'No' : model.alcohol;
    reduceSaltIntake.value = model.reduceSalt.isEmpty ? 'No' : model.reduceSalt;
    morningWalk.value = model.exercise.isEmpty ? 'No' : model.exercise;
    areYouInStress.value = model.inStress.isEmpty ? 'No' : model.inStress;
    missMedicine.value = model.missMedicine.isEmpty ? 'No' : model.missMedicine;
    lastHospitalization.value = model.lastHospitalization == 'Yes'
        ? 'Yes'
        : 'No';
    hospitalizationReasonSelected.value = model.lastHospitalization == 'Yes'
        ? (model.hospitalizationReason.isEmpty
              ? 'Select'
              : model.hospitalizationReason)
        : 'Select';

    systolic3Controller.text = model.systolic3;
    diastolic3Controller.text = model.diastolic3;
    pulseRate3Controller.text = model.heartRate3;
  }

  void selectPlace(String selectedPlace) {
    if (place.value == selectedPlace) {
      place.value = '';
    } else {
      place.value = selectedPlace;
    }
  }

  void toggleBPApparatus(bool value) {
    haveBPApparatus.value = value;
  }

  Future<void> pickEcgImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        ecgReportImages.add(image);
      }
    } catch (e) {
      AppSnackbars.showError('error'.tr, 'Failed to pick image');
    }
  }

  void removeEcgImage(int index) {
    if (index >= 0 && index < ecgReportImages.length) {
      ecgReportImages.removeAt(index);
    }
  }

  Future<void> selectHba1cDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      hba1cDateChoice.value = formatted;
    }
  }

  bool validateForm() {
    if (spo2Choice.value == 'Yes') {
      final val = int.tryParse(spo2Controller.text.trim());
      if (val == null || val < 50 || val > 100) {
        AppSnackbars.showError(
          'error'.tr,
          'Please enter valid SPO2 level (50-100%).',
        );
        return false;
      }
    }
    return true;
  }

  ClinicalFormDetailsModel buildFormDetailsModel() {
    final otherDetails = otherSymptomsController.text.trim();
    return ClinicalFormDetailsModel(
      place: place.value,
      systolic1: systolicController.text.trim(),
      diastolic1: diastolicController.text.trim(),
      heartRate1: pulseRateController.text.trim(),
      height: heightController.text.trim(),
      weight: weightController.text.trim(),
      spo2: spo2Choice.value,
      spo2Details: spo2Choice.value == 'Yes' ? spo2Controller.text.trim() : '0',
      bmi: calculatedBmi.value,
      bpApparatus: haveBPApparatus.value ? 'Yes' : 'No',
      checkSugar: checkSugarVal.value ? 'Yes' : 'No',
      fasting: fastingController.text.trim(),
      afterFood: afterFoodController.text.trim(),
      random: randomController.text.trim(),
      creatinine: creatinineController.text.trim(),
      totalCholesterol: totalCholesterolController.text.trim(),
      hdl: hdlController.text.trim(),
      ldl: ldlController.text.trim(),
      vldl: vldlController.text.trim(),
      hba1c: hba1cController.text.trim(),
      hba1cDate: hba1cDateChoice.value,
      urineAlbumin: cbUrineAlbumin.value ? urineAlbuminType.value : '',
      urineAlbuminReport: urineAlbuminType.value == 'Numeric'
          ? urineAlbuminNumericController.text.trim()
          : urineAlbuminValueSelected.value,
      ecg: cbEcg.value ? 'Yes' : 'No',
      thyroid: cbThyroid.value ? 'Yes' : 'No',
      t3: t3Controller.text.trim(),
      t4: t4Controller.text.trim(),
      tsh: tshController.text.trim(),
      uricAcid: uricAcidController.text.trim(),
      improvement: feelingCompared.value,
      chestPain: chestPain.value,
      chestPainSweating: chestPainSweating.value,
      breathlessness: difficultyBreathing.value,
      breathlessWhile: breathingWhile.value,
      palpitations: palpitations.value,
      giddiness: giddiness.value,
      headache: headache.value,
      dizziness: feelDizziness.value,
      dizzinessSystolic: dizzinessSystolicController.text.trim(),
      dizzinessDiaStolic: dizzinessDiastolicController.text.trim(),
      otherSymptoms: otherDetails.isNotEmpty ? 'Yes' : '',
      otherSymptomsDetails: otherDetails,
      systolic2: systolic2Controller.text.trim(),
      diastolic2: diastolic2Controller.text.trim(),
      heartRate2: pulseRate2Controller.text.trim(),
      bleedingEpisode: bleedingEpisode.value,
      smoking: stopSmoking.value,
      alcohol: stopAlcohol.value,
      reduceSalt: reduceSaltIntake.value,
      exercise: morningWalk.value,
      inStress: areYouInStress.value,
      missMedicine: missMedicine.value,
      lastHospitalization: lastHospitalization.value,
      hospitalizationReason: hospitalizationReasonSelected.value == 'other'
          ? otherHospitalizationReasonController.text.trim()
          : hospitalizationReasonSelected.value,
      systolic3: systolic3Controller.text.trim(),
      diastolic3: diastolic3Controller.text.trim(),
      heartRate3: pulseRate3Controller.text.trim(),
    );
  }

  Future<void> submitForm() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final docId = doctorId.isNotEmpty
          ? doctorId
          : (prefs.getString(AppConstants.prefUserId) ?? '');
      final otherDetails = otherSymptomsController.text.trim();

      final map = <String, dynamic>{
        'patient_id': patientId,
        'doctor_id': docId,
        'form_id': formId,
        'form_type': formType,
        'place': place.value,
        'have_bp_apparatus': haveBPApparatus.value ? 'Yes' : 'No',
        'systolic_1': systolicController.text.trim(),
        'diastolic_1': diastolicController.text.trim(),
        'heart_rate_1': pulseRateController.text.trim(),
        'spo2': spo2Choice.value,
        'spo2_value': spo2Choice.value == 'Yes'
            ? spo2Controller.text.trim()
            : '0',
        'height': heightController.text.trim(),
        'weight': weightController.text.trim(),
        'bmi': calculatedBmi.value,
        'check_sugar': checkSugarVal.value ? 'Yes' : 'No',
        'fasting': fastingController.text.trim(),
        'after_food': afterFoodController.text.trim(),
        'random': randomController.text.trim(),
        'creatinine': creatinineController.text.trim(),
        'total_cholesterol': totalCholesterolController.text.trim(),
        'hdl': hdlController.text.trim(),
        'ldl': ldlController.text.trim(),
        'vldl': vldlController.text.trim(),
        'hba1c': hba1cController.text.trim(),
        'hba1c_date': hba1cDateChoice.value,
        'urine_albumin': cbUrineAlbumin.value ? urineAlbuminType.value : '',
        'urine_albumin_report': urineAlbuminType.value == 'Numeric'
            ? urineAlbuminNumericController.text.trim()
            : (urineAlbuminValueSelected.value == 'Select'
                  ? ''
                  : urineAlbuminValueSelected.value),
        'ecg': cbEcg.value ? 'Yes' : 'No',
        'thyroid': cbThyroid.value ? 'Yes' : 'No',
        't3': t3Controller.text.trim(),
        't4': t4Controller.text.trim(),
        'tsh': tshController.text.trim(),
        'uric_acid': uricAcidController.text.trim(),
        'improvement': feelingCompared.value,
        'chest_pain': chestPain.value,
        'chest_pain_sweating': chestPainSweating.value,
        'breathlessness': difficultyBreathing.value,
        'breathless_while': breathingWhile.value,
        'palpitations': palpitations.value,
        'giddiness': giddiness.value,
        'headache': headache.value,
        'dizziness': feelDizziness.value,
        'dizziness_systolic': dizzinessSystolicController.text.trim(),
        'dizziness_diastolic': dizzinessDiastolicController.text.trim(),
        'other_symptoms': otherDetails.isNotEmpty ? 'Yes' : '',
        'other_symptom_details': otherDetails,
        'systolic_2': systolic2Controller.text.trim(),
        'diastolic_2': diastolic2Controller.text.trim(),
        'heart_rate_2': pulseRate2Controller.text.trim(),
        'bleeding_episode': bleedingEpisode.value,
        'smoking': stopSmoking.value,
        'alcohol': stopAlcohol.value,
        'reduce_salt': reduceSaltIntake.value,
        'exercise': morningWalk.value,
        'in_stress': areYouInStress.value,
        'miss_medicine': missMedicine.value,
        'last_hospitalization': lastHospitalization.value,
        'hospitalization_reason': hospitalizationReasonSelected.value == 'other'
            ? otherHospitalizationReasonController.text.trim()
            : (hospitalizationReasonSelected.value == 'Select'
                  ? ''
                  : hospitalizationReasonSelected.value),
        'systolic_3': systolic3Controller.text.trim(),
        'diastolic_3': diastolic3Controller.text.trim(),
        'heart_rate_3': pulseRate3Controller.text.trim(),
      };

      for (int i = 0; i < ecgReportImages.length && i < 5; i++) {
        map['ecg_image_${i + 1}'] = await dio.MultipartFile.fromFile(
          ecgReportImages[i].path,
          filename: 'ecg_image_${i + 1}.jpg',
        );
      }

      final formData = dio.FormData.fromMap(map);

      final response = await _apiClient.post(
        ApiEndpoints.updateClinicalForm,
        data: formData,
        options: dio.Options(
          headers: token.isNotEmpty ? {'Authorization': token} : null,
        ),
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
            body['status'] == true;
        final msg =
            body['msg']?.toString() ??
            body['message']?.toString() ??
            'form_submitted'.tr;

        if (isSuccess) {
          final resultModel = buildFormDetailsModel();
          Get.back(result: resultModel);
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
      debugPrint('Error updating clinical form: $e');
      AppSnackbars.showError('error'.tr, 'something_went_wrong'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    heightController.removeListener(calculateBmi);
    weightController.removeListener(calculateBmi);
    systolicController.dispose();
    diastolicController.dispose();
    pulseRateController.dispose();
    spo2Controller.dispose();
    heightController.dispose();
    weightController.dispose();
    fastingController.dispose();
    afterFoodController.dispose();
    randomController.dispose();
    creatinineController.dispose();
    hba1cController.dispose();
    totalCholesterolController.dispose();
    hdlController.dispose();
    ldlController.dispose();
    vldlController.dispose();
    uricAcidController.dispose();
    urineAlbuminNumericController.dispose();
    t3Controller.dispose();
    t4Controller.dispose();
    tshController.dispose();
    dizzinessSystolicController.dispose();
    dizzinessDiastolicController.dispose();
    otherSymptomsController.dispose();
    otherHospitalizationReasonController.dispose();
    systolic2Controller.dispose();
    diastolic2Controller.dispose();
    pulseRate2Controller.dispose();
    systolic3Controller.dispose();
    diastolic3Controller.dispose();
    pulseRate3Controller.dispose();
    super.onClose();
  }
}
