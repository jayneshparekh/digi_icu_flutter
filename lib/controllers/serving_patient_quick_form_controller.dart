import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_quick_form_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/get_quick_form_req.dart';
import 'package:digi_icu_flutter/models/response/doctor/quick_form_detail_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

class ServingPatientQuickFormController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // Parameters & Form Mode
  final RxString patientId = ''.obs;
  final RxString formId = ''.obs;
  final RxString formType = 'Quick Form'.obs;
  final RxBool isEditMode = false.obs;
  final RxBool isLoading = false.obs;

  // 1. Blood Pressure Controls
  final systolicCtrl = TextEditingController();
  final diastolicCtrl = TextEditingController();
  final lyingDownSystolicCtrl = TextEditingController();
  final lyingDownDiastolicCtrl = TextEditingController();
  final standingSystolicCtrl = TextEditingController();
  final standingDiastolicCtrl = TextEditingController();

  // 2. Blood Sugar Controls
  final fastingCtrl = TextEditingController();
  final afterFoodCtrl = TextEditingController();
  final randomCtrl = TextEditingController();

  // 3. Weight Controls
  final weightCtrl = TextEditingController();
  final weightError = ''.obs;

  // 4. Episode Symptoms (10 PNG Buttons matching Android source)
  final isBreathlessness = false.obs;
  final isChestPain = false.obs;
  final isChestPainSweating = false.obs;
  final isLowBp = false.obs;
  final isPalpitations = false.obs;
  final isHeadache = false.obs;
  final isGiddiness = false.obs;
  final isLowSugar = false.obs;
  final isHighSugar = false.obs;
  final isHighBp = false.obs;

  // 5. Hospitalization Checkboxes & Text
  final cbHeartAttack = false.obs;
  final cbStroke = false.obs;
  final cbKidneyFailure = false.obs;
  final cbHighBP = false.obs;
  final cbHighSugar = false.obs;
  final cbLowSugar = false.obs;
  final cbOther = false.obs;
  final otherHospitalizationCtrl = TextEditingController();

  // 6. TMT Section Controls
  final tmtResult = ''.obs; // 'Positive', 'Negative', 'Inconclusive'
  final metCtrl = TextEditingController();
  final tmtOtherCtrl = TextEditingController();

  // 7. Blood Tests Checklist & Inputs
  final cbCreatinine = false.obs;
  final cbHbA1c = false.obs;
  final cbTotalCholesterol = false.obs;

  final creatinineCtrl = TextEditingController();
  final hba1cCtrl = TextEditingController();
  final hba1cDateStr = ''.obs;
  final totalCholesterolCtrl = TextEditingController();

  // 8. 2D Echo Section Controls
  final coa = ''.obs;
  final ras = ''.obs;
  final rwma = ''.obs;
  final cbAnterior = false.obs;
  final cbLateral = false.obs;
  final cbInferior = false.obs;
  final cbPosterior = false.obs;

  final lvh = ''.obs;
  final lviddCtrl = TextEditingController();
  final lvpwdCtrl = TextEditingController();

  final efCtrl = TextEditingController();
  final eCtrl = TextEditingController();
  final aCtrl = TextEditingController();

  final lvdd = ''.obs;
  final rvDysfunction = ''.obs;
  final pah = ''.obs;
  final paspCtrl = TextEditingController();

  final regularization = ''.obs;
  final cbMR = false.obs;
  final cbTR = false.obs;
  final cbAR = false.obs;

  final echoOtherCtrl = TextEditingController();

  // 9. 2 Days MYBSL Controls
  final selectedDay = 'select_day'.tr.obs;
  final daysList = ['Select Day', 'Day 1', 'Day 2', 'Day 3'];

  final morningFastingCtrl = TextEditingController();
  final morningMedTaken = ''.obs;
  final morningDoseCtrl = TextEditingController();

  final postLunchCtrl = TextEditingController();
  final postLunchMedTaken = ''.obs;
  final postLunchDoseCtrl = TextEditingController();

  final atNightCtrl = TextEditingController();
  final atNightMedTaken = ''.obs;
  final atNightDoseCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    weightCtrl.addListener(() {
      final valStr = weightCtrl.text;
      if (valStr.isNotEmpty) {
        final val = int.tryParse(valStr);
        if (val != null && (val < 10 || val > 150)) {
          weightError.value = 'enter_valid_value'.tr;
        } else {
          weightError.value = '';
        }
      } else {
        weightError.value = '';
      }
    });

    if (Get.isRegistered<ServingPatientController>()) {
      patientId.value = Get.find<ServingPatientController>().patientId;
    }

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('patientId') && args['patientId'] != null) {
        patientId.value = args['patientId'].toString();
      }
      if (args.containsKey('formId') && args['formId'] != null) {
        formId.value = args['formId'].toString();
        isEditMode.value = true;
        fetchQuickFormData(formId.value);
      }
    }
  }

  Future<void> fetchQuickFormData(String id) async {
    isLoading.value = true;
    try {
      final Response response = await _apiClient.post(
        ApiEndpoints.getQuickForm,
        data: GetQuickFormReq(formId: id).toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        final detailRes = QuickFormDetailResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (detailRes.status == 'success' && detailRes.data != null) {
          final data = detailRes.data!;
          if (data.patientId.isNotEmpty) patientId.value = data.patientId;
          systolicCtrl.text = data.bpSystolic;
          diastolicCtrl.text = data.bpDiastolic;
          lyingDownSystolicCtrl.text = data.sittingBpSystolic;
          lyingDownDiastolicCtrl.text = data.sittingBpDiastolic;
          standingSystolicCtrl.text = data.standingBpSystolic;
          standingDiastolicCtrl.text = data.standingBpDiastolic;
          fastingCtrl.text = data.fasting;
          afterFoodCtrl.text = data.afterFood;
          randomCtrl.text = data.random;
          weightCtrl.text = data.weight;

          // Episodes
          if (data.episode.isNotEmpty) {
            final episodes = data.episode.split(', ');
            isBreathlessness.value = episodes.contains('Breathlessness');
            isChestPain.value = episodes.contains('Chest Pain');
            isChestPainSweating.value = episodes.contains('Chest Pain Sweating');
            isLowBp.value = episodes.contains('Low BP');
            isPalpitations.value = episodes.contains('Palpitations');
            isHeadache.value = episodes.contains('Headache');
            isGiddiness.value = episodes.contains('Giddiness');
            isLowSugar.value = episodes.contains('Low Sugar');
            isHighSugar.value = episodes.contains('High Sugar');
            isHighBp.value = episodes.contains('High BP');
          }

          // Hospitalization
          if (data.hospitalization.isNotEmpty) {
            final hospList = data.hospitalization.split(', ');
            cbHeartAttack.value = hospList.contains('Heart Attack');
            cbStroke.value = hospList.contains('Stroke');
            cbKidneyFailure.value = hospList.contains('Kidney Failure');
            cbHighBP.value = hospList.contains('High BP');
            cbHighSugar.value = hospList.contains('High Sugar');
            cbLowSugar.value = hospList.contains('Low Sugar');
            for (var item in hospList) {
              if (!['Heart Attack', 'Stroke', 'Kidney Failure', 'High BP', 'High Sugar', 'Low Sugar'].contains(item)) {
                cbOther.value = true;
                otherHospitalizationCtrl.text = item;
              }
            }
          }

          // TMT
          tmtResult.value = data.tmtResult;
          metCtrl.text = data.mets;
          tmtOtherCtrl.text = data.others;

          // Blood tests
          if (data.creatinine.isNotEmpty) {
            cbCreatinine.value = true;
            creatinineCtrl.text = data.creatinine;
          }
          if (data.hba1c.isNotEmpty) {
            cbHbA1c.value = true;
            hba1cCtrl.text = data.hba1c;
          }
          if (data.hba1cDate.isNotEmpty) {
            hba1cDateStr.value = data.hba1cDate;
          }
          if (data.totalCholesterol.isNotEmpty) {
            cbTotalCholesterol.value = true;
            totalCholesterolCtrl.text = data.totalCholesterol;
          }

          // MYBSL
          if (data.myBsl.isNotEmpty) {
            selectedDay.value = data.myBsl;
            morningFastingCtrl.text = data.morningFasting;
            morningMedTaken.value = data.morningMedicine;
            morningDoseCtrl.text = data.morningMedName;
            postLunchCtrl.text = data.postLunch;
            postLunchMedTaken.value = data.lunchMedicine;
            postLunchDoseCtrl.text = data.lunchMedName;
            atNightCtrl.text = data.night;
            atNightMedTaken.value = data.nightMedicine;
            atNightDoseCtrl.text = data.nightMedName;
          }

          // 2D Echo
          coa.value = data.coa;
          ras.value = data.ras;
          rwma.value = data.rwma;
          if (data.rwmaDetails.isNotEmpty) {
            final rwmaList = data.rwmaDetails.split(', ');
            cbAnterior.value = rwmaList.contains('Auterior') || rwmaList.contains('Anterior');
            cbLateral.value = rwmaList.contains('Lateral');
            cbInferior.value = rwmaList.contains('Inferior');
            cbPosterior.value = rwmaList.contains('Posterior');
          }
          lvh.value = data.lvh;
          lviddCtrl.text = data.lvidd;
          lvpwdCtrl.text = data.lvpwd;
          efCtrl.text = data.ef;
          eCtrl.text = data.eoa1;
          aCtrl.text = data.eoa2;
          lvdd.value = data.lvdd;
          rvDysfunction.value = data.rvDysfunction;
          pah.value = data.pah;
          paspCtrl.text = data.pasp;
          regularization.value = data.regularization;
          if (data.regularizationDetails.isNotEmpty) {
            final regList = data.regularizationDetails.split(', ');
            cbMR.value = regList.contains('MR');
            cbTR.value = regList.contains('TR');
            cbAR.value = regList.contains('AR');
          }
          echoOtherCtrl.text = data.echoOtherDetails;
        }
      }
    } catch (_) {
      // Handle error gracefully
    } finally {
      isLoading.value = false;
    }
  }

  void selectHbA1cDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      hba1cDateStr.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> submitQuickForm() async {
    isLoading.value = true;
    try {
      final String endpoint = isEditMode.value ? ApiEndpoints.updateQuickForm : ApiEndpoints.quickForm;

      // Construct episode string
      final episodeList = <String>[];
      if (isBreathlessness.value) episodeList.add('Breathlessness');
      if (isChestPain.value) episodeList.add('Chest Pain');
      if (isChestPainSweating.value) episodeList.add('Chest Pain Sweating');
      if (isLowBp.value) episodeList.add('Low BP');
      if (isPalpitations.value) episodeList.add('Palpitations');
      if (isHeadache.value) episodeList.add('Headache');
      if (isGiddiness.value) episodeList.add('Giddiness');
      if (isLowSugar.value) episodeList.add('Low Sugar');
      if (isHighSugar.value) episodeList.add('High Sugar');
      if (isHighBp.value) episodeList.add('High BP');

      // Construct hospitalization string
      final hospList = <String>[];
      if (cbHeartAttack.value) hospList.add('Heart Attack');
      if (cbStroke.value) hospList.add('Stroke');
      if (cbKidneyFailure.value) hospList.add('Kidney Failure');
      if (cbHighBP.value) hospList.add('High BP');
      if (cbHighSugar.value) hospList.add('High Sugar');
      if (cbLowSugar.value) hospList.add('Low Sugar');
      if (cbOther.value && otherHospitalizationCtrl.text.isNotEmpty) {
        hospList.add(otherHospitalizationCtrl.text);
      }

      // RWMA details
      final rwmaDetailsList = <String>[];
      if (cbAnterior.value) rwmaDetailsList.add('Anterior');
      if (cbLateral.value) rwmaDetailsList.add('Lateral');
      if (cbInferior.value) rwmaDetailsList.add('Inferior');
      if (cbPosterior.value) rwmaDetailsList.add('Posterior');

      // Regularization details
      final regList = <String>[];
      if (cbMR.value) regList.add('MR');
      if (cbTR.value) regList.add('TR');
      if (cbAR.value) regList.add('AR');

      final req = AddQuickFormReq(
        patientId: patientId.value,
        formId: formId.value,
        bpSystolic: systolicCtrl.text,
        bpDiastolic: diastolicCtrl.text,
        sittingBpSystolic: lyingDownSystolicCtrl.text,
        sittingBpDiastolic: lyingDownDiastolicCtrl.text,
        standingBpSystolic: standingSystolicCtrl.text,
        standingBpDiastolic: standingDiastolicCtrl.text,
        fasting: fastingCtrl.text,
        afterFood: afterFoodCtrl.text,
        random: randomCtrl.text,
        weight: weightCtrl.text,
        episode: episodeList.join(', '),
        hospitalization: hospList.join(', '),
        tmtResult: tmtResult.value,
        mets: metCtrl.text,
        others: tmtOtherCtrl.text,
        creatinine: cbCreatinine.value ? creatinineCtrl.text : '',
        hba1c: cbHbA1c.value ? hba1cCtrl.text : '',
        hba1cDate: cbHbA1c.value ? hba1cDateStr.value : '',
        totalCholesterol: cbTotalCholesterol.value ? totalCholesterolCtrl.text : '',
        otherInvestigation: '',
        myBsl: selectedDay.value != 'Select Day' && selectedDay.value != 'select_day'.tr ? selectedDay.value : '',
        morningFasting: morningFastingCtrl.text,
        morningMedicine: morningMedTaken.value,
        morningMedName: morningDoseCtrl.text,
        postLunch: postLunchCtrl.text,
        lunchMedicine: postLunchMedTaken.value,
        lunchMedName: postLunchDoseCtrl.text,
        night: atNightCtrl.text,
        nightMedicine: atNightMedTaken.value,
        nightMedName: atNightDoseCtrl.text,
        coa: coa.value,
        ras: ras.value,
        rwma: rwma.value,
        rwmaDetails: rwmaDetailsList.join(', '),
        lvh: lvh.value,
        lvidd: lviddCtrl.text,
        lvpwd: lvpwdCtrl.text,
        ef: efCtrl.text,
        eoa1: eCtrl.text,
        eoa2: aCtrl.text,
        lvdd: lvdd.value,
        rvDysfunction: rvDysfunction.value,
        pah: pah.value,
        pasp: paspCtrl.text,
        regularization: regularization.value,
        regularizationDetails: regList.join(', '),
        echoOtherDetails: echoOtherCtrl.text,
      );

      final Response response = await _apiClient.post(endpoint, data: req.toJson());
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar(
          'success'.tr,
          'form_submitted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          response.data?['msg']?.toString() ?? 'Error submitting form',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    systolicCtrl.dispose();
    diastolicCtrl.dispose();
    lyingDownSystolicCtrl.dispose();
    lyingDownDiastolicCtrl.dispose();
    standingSystolicCtrl.dispose();
    standingDiastolicCtrl.dispose();
    fastingCtrl.dispose();
    afterFoodCtrl.dispose();
    randomCtrl.dispose();
    weightCtrl.dispose();
    otherHospitalizationCtrl.dispose();
    metCtrl.dispose();
    tmtOtherCtrl.dispose();
    creatinineCtrl.dispose();
    hba1cCtrl.dispose();
    totalCholesterolCtrl.dispose();
    lviddCtrl.dispose();
    lvpwdCtrl.dispose();
    efCtrl.dispose();
    eCtrl.dispose();
    aCtrl.dispose();
    paspCtrl.dispose();
    echoOtherCtrl.dispose();
    morningFastingCtrl.dispose();
    morningDoseCtrl.dispose();
    postLunchCtrl.dispose();
    postLunchDoseCtrl.dispose();
    atNightCtrl.dispose();
    atNightDoseCtrl.dispose();
    super.onClose();
  }
}
