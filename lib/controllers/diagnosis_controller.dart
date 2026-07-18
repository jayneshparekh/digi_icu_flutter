import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/response/doctors/diagnosis_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosisController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  late final String patientId;
  late final String bookingId;

  final RxBool isLoading = false.obs;

  // Predefined checkbox states
  final cbHypertension = false.obs;
  final cbHypertensionEssential = false.obs;
  final cbHypertensionSecondary = false.obs;
  final cbHypertensionWhiteCoat = false.obs;
  final cbBPHypertensionResistant = false.obs;
  final cbHypertensionPregnancy = false.obs;
  final cbHypertensionMalignant = false.obs;
  final cbHypertensionEmergency = false.obs;
  final cbHypertensionAccelarated = false.obs;

  final cbDiabetes = false.obs;
  final cbDMType1 = false.obs;
  final cbDmType2 = false.obs;
  final cbPreDiabetic = false.obs;
  final cbDMPregnancy = false.obs;
  final cbDiabeticFoot = false.obs;

  final cbStroke = false.obs;
  final cbStrokeAcute = false.obs;
  final cbStrokeRecent = false.obs;
  final cbStrokeOld = false.obs;

  final cbIschemic = false.obs;
  final cbIschemicAcute = false.obs;
  final cbIschemicRecent = false.obs;
  final cbIhdECG = false.obs;
  final cbIschemicOld = false.obs;
  final cbIschemicNSTEMI = false.obs;
  final cbUnstableAngina = false.obs;

  final cbCoronary = false.obs;
  final cbCoronaryPostCABG = false.obs;
  final cbCoronaryDVD = false.obs;
  final cbCoronarySVD = false.obs;
  final cbCoronaryTVD = false.obs;
  final cbCoronaryPostPCI = false.obs;

  final cbRhythm = false.obs;
  final cbRhythmBrady = false.obs;
  final cbRhythmAtrialFlutter = false.obs;
  final cbRhythmAtrialFibrillation = false.obs;
  final cbRhythmSinus = false.obs;
  final cbRhythmBrady2nd = false.obs;
  final cbRhythmBradyCHB = false.obs;
  final cbRhythmBrady1st = false.obs;
  final cbRhythmSVT = false.obs;

  final cbRetinopathy = false.obs;
  final cbRetinopathyHypertensive = false.obs;
  final cbRetinopathyDiabetic = false.obs;
  final cbRetinopathyOther = false.obs;

  final cbHtnCKD = false.obs;
  final cbHypothyroid = false.obs;
  final cbHyperThyroid = false.obs;
  final cbHyperuricemia = false.obs;
  final cbPeripheral = false.obs;

  // LVD / EF Section
  final cbLV = false.obs;
  final etEF = TextEditingController();

  // NYHA Section
  final cbNYHA = false.obs;
  final selectedNYHA = ''.obs; // I, II, III, IV

  // Treatment Options (Radio groups)
  final selectedHTNTreatment = ''.obs;
  final selectedDMTreatment = ''.obs;
  final selectedDLPTreatment = ''.obs;

  final cbDyslipidemia = false.obs; // Dyslipidemia master checkbox

  // Other Diagnosis (up to 5 slots)
  final cbOtherDiagnosis = true.obs;
  final otherControllers = List.generate(5, (_) => TextEditingController());
  final otherSlotsVisible = [true, false, false, false, false].obs;
  final otherSlotsAdded = [false, false, false, false, false].obs; // tracks if slot has been "submitted/added" to the summary list

  // Summary Text
  final rxDiagnosisText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    patientId = args['patient_id']?.toString() ?? '';
    bookingId = args['appointment_id']?.toString() ?? '';
    
    // Bind listeners to automatically update the compiled summary text
    _setupChangeListeners();
    fetchPatientDiagnosis();
  }

  void _setupChangeListeners() {
    // Whenever checkboxes change, re-compile diagnosis summary
    final allChecks = [
      cbHypertension, cbHypertensionEssential, cbHypertensionSecondary, cbHypertensionWhiteCoat,
      cbBPHypertensionResistant, cbHypertensionPregnancy, cbHypertensionMalignant,
      cbHypertensionEmergency, cbHypertensionAccelarated,
      cbDiabetes, cbDMType1, cbDmType2, cbPreDiabetic, cbDMPregnancy, cbDiabeticFoot,
      cbStroke, cbStrokeAcute, cbStrokeRecent, cbStrokeOld,
      cbIschemic, cbIschemicAcute, cbIschemicRecent, cbIhdECG, cbIschemicOld, cbIschemicNSTEMI, cbUnstableAngina,
      cbCoronary, cbCoronaryPostCABG, cbCoronaryDVD, cbCoronarySVD, cbCoronaryTVD, cbCoronaryPostPCI,
      cbRhythm, cbRhythmBrady, cbRhythmAtrialFlutter, cbRhythmAtrialFibrillation, cbRhythmSinus,
      cbRhythmBrady2nd, cbRhythmBradyCHB, cbRhythmBrady1st, cbRhythmSVT,
      cbRetinopathy, cbRetinopathyHypertensive, cbRetinopathyDiabetic, cbRetinopathyOther,
      cbHtnCKD, cbHypothyroid, cbHyperThyroid, cbHyperuricemia, cbPeripheral,
      cbLV, cbNYHA, selectedNYHA,
    ];

    for (var check in allChecks) {
      if (check is RxBool) {
        ever(check, (_) => compileDiagnosis());
      } else if (check is RxString) {
        ever(check, (_) => compileDiagnosis());
      }
    }

    // Handle Hypertension toggle auto-checking Essential
    ever(cbHypertension, (val) {
      if (val) {
        cbHypertensionEssential.value = true;
      } else {
        cbHypertensionEssential.value = false;
        cbHypertensionSecondary.value = false;
        cbHypertensionWhiteCoat.value = false;
        cbBPHypertensionResistant.value = false;
        cbHypertensionPregnancy.value = false;
        cbHypertensionMalignant.value = false;
        cbHypertensionEmergency.value = false;
        cbHypertensionAccelarated.value = false;
        selectedHTNTreatment.value = '';
      }
    });

    // Handle Diabetes toggle auto-checking Type II
    ever(cbDiabetes, (val) {
      if (val) {
        cbDmType2.value = true;
      } else {
        cbDMType1.value = false;
        cbDmType2.value = false;
        cbPreDiabetic.value = false;
        cbDMPregnancy.value = false;
        cbDiabeticFoot.value = false;
        selectedDMTreatment.value = '';
      }
    });

    // Handle Stroke section collapse
    ever(cbStroke, (val) {
      if (!val) {
        cbStrokeAcute.value = false;
        cbStrokeRecent.value = false;
        cbStrokeOld.value = false;
      }
    });

    // Handle Ischemic section collapse
    ever(cbIschemic, (val) {
      if (!val) {
        cbIschemicAcute.value = false;
        cbIschemicRecent.value = false;
        cbIhdECG.value = false;
        cbIschemicOld.value = false;
        cbIschemicNSTEMI.value = false;
        cbUnstableAngina.value = false;
      }
    });

    // Handle Coronary section collapse
    ever(cbCoronary, (val) {
      if (!val) {
        cbCoronaryPostCABG.value = false;
        cbCoronaryDVD.value = false;
        cbCoronarySVD.value = false;
        cbCoronaryTVD.value = false;
        cbCoronaryPostPCI.value = false;
      }
    });

    // Handle Rhythm section collapse
    ever(cbRhythm, (val) {
      if (!val) {
        cbRhythmBrady.value = false;
        cbRhythmAtrialFlutter.value = false;
        cbRhythmAtrialFibrillation.value = false;
        cbRhythmSinus.value = false;
        cbRhythmBrady2nd.value = false;
        cbRhythmBradyCHB.value = false;
        cbRhythmBrady1st.value = false;
        cbRhythmSVT.value = false;
      }
    });

    // Handle Retinopathy section collapse
    ever(cbRetinopathy, (val) {
      if (!val) {
        cbRetinopathyHypertensive.value = false;
        cbRetinopathyDiabetic.value = false;
        cbRetinopathyOther.value = false;
      }
    });

    // Handle NYHA collapse
    ever(cbNYHA, (val) {
      if (!val) {
        selectedNYHA.value = '';
      }
    });

    // Handle Dyslipidemia master checkbox collapse
    ever(cbDyslipidemia, (val) {
      if (!val) {
        selectedDLPTreatment.value = '';
      }
    });
  }

  void compileDiagnosis() {
    final list = <String>[];

    // HTN
    if (cbHypertension.value) {
      final sub = <String>[];
      if (cbHypertensionEssential.value) sub.add('Essential');
      if (cbHypertensionSecondary.value) sub.add('Secondary');
      if (cbHypertensionWhiteCoat.value) sub.add('White coat');
      if (cbBPHypertensionResistant.value) sub.add('Resistant');
      if (cbHypertensionPregnancy.value) sub.add('Pregnancy induced');
      if (cbHypertensionMalignant.value) sub.add('Malignant');
      if (cbHypertensionEmergency.value) sub.add('HTNsive Emergency');
      if (cbHypertensionAccelarated.value) sub.add('Accelarated');
      
      if (sub.isNotEmpty) {
        list.add('HTN-${sub.join(" ")}');
      }
    }

    // DM
    if (cbDiabetes.value) {
      final sub = <String>[];
      if (cbDMType1.value) sub.add('Type I');
      if (cbDmType2.value) sub.add('Type II');
      if (cbPreDiabetic.value) sub.add('PreDiabetic');
      if (cbDMPregnancy.value) sub.add('Pregnancy induced');
      if (cbDiabeticFoot.value) sub.add('Diabetic Foot');
      
      if (sub.isNotEmpty) {
        list.add('DM-${sub.join(" ")}');
      }
    }

    // Stroke
    if (cbStroke.value) {
      final sub = <String>[];
      if (cbStrokeAcute.value) sub.add('Acute');
      if (cbStrokeRecent.value) sub.add('Recent');
      if (cbStrokeOld.value) sub.add('Old');
      
      if (sub.isNotEmpty) {
        list.add('Stroke-${sub.join(" ")}');
      }
    }

    // Ischemic
    if (cbIschemic.value) {
      final sub = <String>[];
      if (cbIschemicAcute.value) sub.add('Acute');
      if (cbIschemicRecent.value) sub.add('Recent');
      if (cbIhdECG.value) sub.add('ECG changes');
      if (cbIschemicOld.value) sub.add('Old');
      if (cbIschemicNSTEMI.value) sub.add('NSTEMI');
      if (cbUnstableAngina.value) sub.add('Unstable Angina');
      
      if (sub.isNotEmpty) {
        list.add('IHD-${sub.join(" ")}');
      }
    }

    // CAD
    if (cbCoronary.value) {
      final sub = <String>[];
      if (cbCoronaryPostCABG.value) sub.add('Post CABG');
      if (cbCoronaryDVD.value) sub.add('DVD');
      if (cbCoronarySVD.value) sub.add('SVD');
      if (cbCoronaryTVD.value) sub.add('TVD');
      if (cbCoronaryPostPCI.value) sub.add('Post PCI');
      
      if (sub.isNotEmpty) {
        list.add('CAD-${sub.join(" ")}');
      }
    }

    // Rhythm
    if (cbRhythm.value) {
      final sub = <String>[];
      if (cbRhythmBrady.value) sub.add('Brady arrhythmia');
      if (cbRhythmAtrialFlutter.value) sub.add('Atrial flutter');
      if (cbRhythmAtrialFibrillation.value) sub.add('Atrial Fibrillation');
      if (cbRhythmSinus.value) sub.add('Sinus Tachycardia');
      if (cbRhythmBrady2nd.value) sub.add('2nd degree heart block');
      if (cbRhythmBradyCHB.value) sub.add('CHB');
      if (cbRhythmBrady1st.value) sub.add('1st degree heart block');
      if (cbRhythmSVT.value) sub.add('SVT');
      
      if (sub.isNotEmpty) {
        list.add('Rhythm-${sub.join(" ")}');
      }
    }

    // Retinopathy
    if (cbRetinopathy.value) {
      final sub = <String>[];
      if (cbRetinopathyHypertensive.value) sub.add('Hypertensive');
      if (cbRetinopathyDiabetic.value) sub.add('Diabetic');
      if (cbRetinopathyOther.value) sub.add('Other');
      
      if (sub.isNotEmpty) {
        list.add('Retinopathy-${sub.join(" ")}');
      }
    }

    // Simple single choices
    if (cbHtnCKD.value) list.add('CKD');
    if (cbHypothyroid.value) list.add('Hypothyroid');
    if (cbHyperThyroid.value) list.add('HyperThyroid');
    if (cbHyperuricemia.value) list.add('Hyperuricemia');
    if (cbPeripheral.value) list.add('PAD');

    // LVD / EF
    if (cbLV.value && etEF.text.trim().isNotEmpty) {
      list.add('EF-${etEF.text.trim()} %');
    }

    // NYHA
    if (cbNYHA.value && selectedNYHA.value.isNotEmpty) {
      list.add('NYHA-${selectedNYHA.value}');
    }

    // Other diagnosis custom values
    for (int i = 0; i < 5; i++) {
      if (otherSlotsAdded[i] && otherControllers[i].text.trim().isNotEmpty) {
        list.add(otherControllers[i].text.trim());
      }
    }

    rxDiagnosisText.value = list.isNotEmpty ? list.join(", ") : '';
  }

  void addLvdEf() {
    if (etEF.text.trim().isEmpty) return;
    cbLV.value = true;
    compileDiagnosis();
  }

  // Handle adding/submitting custom slots
  void toggleOtherSlot(int index) {
    if (otherSlotsAdded[index]) {
      // Delete custom slot
      otherControllers[index].clear();
      otherSlotsAdded[index] = false;
      // Note: We keep otherSlotsVisible[index] true to allow re-entry
      compileDiagnosis();
    } else {
      // Submit/Add custom slot
      if (otherControllers[index].text.trim().isEmpty) {
        Get.rawSnackbar(message: 'Please enter a diagnosis value.', backgroundColor: Colors.red);
        return;
      }
      otherSlotsAdded[index] = true;
      if (index < 4) {
        otherSlotsVisible[index + 1] = true;
      }
      compileDiagnosis();
    }
  }

  Future<void> fetchPatientDiagnosis() async {
    if (patientId.isEmpty) return;
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getPatientDiagnosis,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = DiagnosisResponse.fromJson(response.data);
        if (res.status == 'success' && res.data != null) {
          _populateExistingData(res.data!);
        }
      }
    } catch (e) {
      debugPrint('Error fetching diagnosis: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateExistingData(DiagnosisData data) {
    // 1. Set treatment options
    selectedHTNTreatment.value = data.htnTreatment;
    selectedDMTreatment.value = data.dmTreatment;
    selectedDLPTreatment.value = data.dlpTreatment;

    if (data.htnTreatment.isNotEmpty) cbHypertension.value = true;
    if (data.dmTreatment.isNotEmpty) cbDiabetes.value = true;
    if (data.dlpTreatment.isNotEmpty) cbDyslipidemia.value = true;

    // 2. Parse diagnosis strings
    final parts = data.diagnosis.split(',');
    int otherIndex = 0;

    for (var part in parts) {
      final clean = part.replaceFirst('[', '').replaceFirst(']', '').trim();
      if (clean.isEmpty) continue;

      if (clean.contains('HTN-')) {
        cbHypertension.value = true;
        final details = clean.replaceFirst('HTN-', '');
        if (details.contains('Essential')) cbHypertensionEssential.value = true;
        if (details.contains('Secondary')) cbHypertensionSecondary.value = true;
        if (details.contains('White coat')) cbHypertensionWhiteCoat.value = true;
        if (details.contains('Resistant')) cbBPHypertensionResistant.value = true;
        if (details.contains('Pregnancy induced')) cbHypertensionPregnancy.value = true;
        if (details.contains('Malignant')) cbHypertensionMalignant.value = true;
        if (details.contains('Emergency')) cbHypertensionEmergency.value = true;
        if (details.contains('Accelarated')) cbHypertensionAccelarated.value = true;
      } else if (clean.contains('DM-')) {
        cbDiabetes.value = true;
        final details = clean.replaceFirst('DM-', '');
        if (details.contains('Type I')) cbDMType1.value = true;
        if (details.contains('Type II')) cbDmType2.value = true;
        if (details.contains('PreDiabetic')) cbPreDiabetic.value = true;
        if (details.contains('Pregnancy induced')) cbDMPregnancy.value = true;
        if (details.contains('Diabetic Foot')) cbDiabeticFoot.value = true;
      } else if (clean.contains('Stroke-')) {
        cbStroke.value = true;
        final details = clean.replaceFirst('Stroke-', '');
        if (details.contains('Acute')) cbStrokeAcute.value = true;
        if (details.contains('Recent')) cbStrokeRecent.value = true;
        if (details.contains('Old')) cbStrokeOld.value = true;
      } else if (clean.contains('IHD-')) {
        cbIschemic.value = true;
        final details = clean.replaceFirst('IHD-', '');
        if (details.contains('Acute')) cbIschemicAcute.value = true;
        if (details.contains('Recent')) cbIschemicRecent.value = true;
        if (details.contains('ECG changes')) cbIhdECG.value = true;
        if (details.contains('Old')) cbIschemicOld.value = true;
        if (details.contains('NSTEMI')) cbIschemicNSTEMI.value = true;
        if (details.contains('Unstable Angina')) cbUnstableAngina.value = true;
      } else if (clean.contains('CAD-')) {
        cbCoronary.value = true;
        final details = clean.replaceFirst('CAD-', '');
        if (details.contains('Post CABG')) cbCoronaryPostCABG.value = true;
        if (details.contains('DVD')) cbCoronaryDVD.value = true;
        if (details.contains('SVD')) cbCoronarySVD.value = true;
        if (details.contains('TVD')) cbCoronaryTVD.value = true;
        if (details.contains('Post PCI')) cbCoronaryPostPCI.value = true;
      } else if (clean.contains('Rhythm-')) {
        cbRhythm.value = true;
        final details = clean.replaceFirst('Rhythm-', '');
        if (details.contains('Brady arrhythmia')) cbRhythmBrady.value = true;
        if (details.contains('Atrial flutter')) cbRhythmAtrialFlutter.value = true;
        if (details.contains('Atrial Fibrillation')) cbRhythmAtrialFibrillation.value = true;
        if (details.contains('Sinus Tachycardia')) cbRhythmSinus.value = true;
        if (details.contains('2nd degree heart block')) cbRhythmBrady2nd.value = true;
        if (details.contains('CHB')) cbRhythmBradyCHB.value = true;
        if (details.contains('1st degree heart block')) cbRhythmBrady1st.value = true;
        if (details.contains('SVT')) cbRhythmSVT.value = true;
      } else if (clean.contains('Retinopathy-')) {
        cbRetinopathy.value = true;
        final details = clean.replaceFirst('Retinopathy-', '');
        if (details.contains('Hypertensive')) cbRetinopathyHypertensive.value = true;
        if (details.contains('Diabetic')) cbRetinopathyDiabetic.value = true;
        if (details.contains('Other')) cbRetinopathyOther.value = true;
      } else if (clean == 'CKD') {
        cbHtnCKD.value = true;
      } else if (clean == 'Hypothyroid') {
        cbHypothyroid.value = true;
      } else if (clean == 'HyperThyroid') {
        cbHyperThyroid.value = true;
      } else if (clean == 'Hyperuricemia') {
        cbHyperuricemia.value = true;
      } else if (clean == 'PAD') {
        cbPeripheral.value = true;
      } else if (clean.contains('EF-')) {
        cbLV.value = true;
        final val = clean.replaceFirst('EF-', '').replaceFirst('%', '').trim();
        etEF.text = val;
      } else if (clean.contains('NYHA-')) {
        cbNYHA.value = true;
        selectedNYHA.value = clean.replaceFirst('NYHA-', '').trim();
      } else if (clean.startsWith('Other') && otherIndex < 5) {
        final customVal = clean.substring(clean.indexOf('-') + 1).trim();
        otherControllers[otherIndex].text = customVal;
        otherSlotsAdded[otherIndex] = true;
        otherSlotsVisible[otherIndex] = true;
        if (otherIndex < 4) {
          otherSlotsVisible[otherIndex + 1] = true;
        }
        otherIndex++;
      } else if (otherIndex < 5) {
        // clean raw custom texts
        otherControllers[otherIndex].text = clean;
        otherSlotsAdded[otherIndex] = true;
        otherSlotsVisible[otherIndex] = true;
        if (otherIndex < 4) {
          otherSlotsVisible[otherIndex + 1] = true;
        }
        otherIndex++;
      }
    }

    compileDiagnosis();
  }

  Future<void> submitDiagnosis() async {
    compileDiagnosis();
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final doctorId = prefs.getString(AppConstants.prefUserId) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.addPatientDiagnosis,
        data: {
          'patient_id': patientId,
          'doctor_id': doctorId,
          'appointment_id': bookingId,
          'diagnosis': rxDiagnosisText.value,
          'htn_treatment': cbHypertension.value ? selectedHTNTreatment.value : '',
          'dm_treatment': cbDiabetes.value ? selectedDMTreatment.value : '',
          'dlp_treatment': cbDyslipidemia.value ? selectedDLPTreatment.value : '',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final statusVal = response.data['status']?.toString() ?? '';
        final msgVal = response.data['msg']?.toString() ?? '';
        if (statusVal == 'success') {
          // Navigate back first to ensure the screen closes and triggers any then() callbacks
          Get.back();
          Get.rawSnackbar(
            message: msgVal.isNotEmpty ? msgVal : 'Diagnosis updated successfully.',
            backgroundColor: Colors.green,
          );
        } else {
          Get.rawSnackbar(
            message: msgVal.isNotEmpty ? msgVal : 'Failed to save diagnosis.',
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error saving diagnosis: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
