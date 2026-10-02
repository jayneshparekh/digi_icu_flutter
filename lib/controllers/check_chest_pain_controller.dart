import 'dart:io';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/patients/add_chest_pain_request.dart';
import 'package:digi_icu_flutter/models/request/patients/download_chest_pain_pdf_request.dart';
import 'package:digi_icu_flutter/models/response/patients/chest_pain_response.dart';
import 'package:digi_icu_flutter/models/response/patients/common_pdf_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/services/razorpay_service.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/chest_pain_score_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/medical_form_chest_pain_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckChestPainController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final RazorpayService _razorpayService = RazorpayService();

  // Patient extras received via route arguments
  String patientId = '';
  String patientName = '';
  String patientAge = '';
  String patientGender = '';
  String pastHistory = '';
  String pastSurgery = '';
  String familyHTK = '';

  // Location details
  String latitude = '';
  String longitude = '';
  String patientLocation = '';

  // Reactive Form State
  final RxBool isLoading = false.obs;
  final RxString forWhom = 'Self'.obs; // 'Self' or 'Other'
  final RxBool dontKnowName = false.obs;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final RxString gender = ''.obs;
  final RxString pastHistoryHTNDM = ''.obs;

  // Pain Assessment Checkboxes & Radios
  final RxBool painPressure = false.obs;
  final RxBool painFullness = false.obs;
  final RxBool painTightness = false.obs;
  final RxBool painBurning = false.obs;

  final RxString locationCentral = ''.obs; // 'Yes' or 'No'
  final RxString painGoing = ''.obs; // 'Yes' or 'No'
  final RxString durationMoreThan5 = ''.obs; // 'Yes' or 'No'

  // Symptoms
  final RxBool symptomNausea = false.obs;
  final RxBool symptomFatigue = false.obs;
  final RxBool symptomDifficultyBreathing = false.obs;
  final RxBool symptomSweating = false.obs;
  final RxBool symptomsNone = false.obs;

  final RxString painAfterExertion = ''.obs; // 'Yes' or 'No'

  int currentChestPainId = 0;

  @override
  void onInit() {
    super.onInit();
    _initDataFromArgs();
    _fetchLocation();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    ageController.dispose();
    super.onClose();
  }

  void _initDataFromArgs() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      patientId =
          (args['patient_id'] ?? args['patientId'])?.toString() ?? '';
      patientName =
          (args['patientName'] ?? args['userName'])?.toString() ?? '';
      patientAge =
          (args['patientAge'] ?? args['userAge'])?.toString() ?? '';
      patientGender =
          (args['patientGender'] ?? args['userGender'])?.toString() ?? '';
      pastHistory = args['hypertension']?.toString() ?? '';
      pastSurgery = args['heartAttack']?.toString() ?? '';
      familyHTK = args['thyroid']?.toString() ?? '';

      final passedLat = args['regLatitude']?.toString() ?? '';
      final passedLong = args['regLongitude']?.toString() ?? '';
      final passedAddr = args['regAddress']?.toString() ?? '';
      if (passedLat.isNotEmpty && passedLat != 'null') {
        latitude = passedLat;
      }
      if (passedLong.isNotEmpty && passedLong != 'null') {
        longitude = passedLong;
      }
      if (passedAddr.isNotEmpty && passedAddr != 'null') {
        patientLocation = passedAddr;
      }
    }

    _ensurePatientId();
  }

  Future<void> _ensurePatientId() async {
    final prefs = await SharedPreferences.getInstance();
    if (patientId.isEmpty) {
      final selectedId =
          prefs.getString(AppConstants.prefSelectedPatientId) ?? '';
      if (selectedId.isNotEmpty) {
        patientId = selectedId;
      } else {
        final loginType = prefs.getString(AppConstants.prefLoginType) ?? '';
        if (loginType.toLowerCase() == 'patient') {
          patientId = prefs.getString(AppConstants.prefUserId) ?? '';
        }
      }
    }

    if (patientName.isEmpty) {
      patientName =
          prefs.getString(AppConstants.prefSelectedPatientName) ??
          prefs.getString(AppConstants.prefUserName) ??
          '';
    }
    if (patientAge.isEmpty) {
      patientAge =
          prefs.getString(AppConstants.prefSelectedPatientAge) ??
          prefs.getString(AppConstants.prefUserAge) ??
          '';
    }
    if (patientGender.isEmpty) {
      patientGender =
          prefs.getString(AppConstants.prefSelectedPatientGender) ??
          prefs.getString(AppConstants.prefUserGender) ??
          '';
    }
  }

  Future<bool> _fetchLocation({bool promptUserIfDisabled = false}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (promptUserIfDisabled) {
          AppSnackbars.showError(
            'location_required'.tr,
            'please_enable_gps'.tr,
          );
        }
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (promptUserIfDisabled) {
            AppSnackbars.showError(
              'location_permission_required'.tr,
              'please_grant_location_permission'.tr,
            );
          }
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (promptUserIfDisabled) {
          AppSnackbars.showError(
            'location_permission_denied'.tr,
            'please_enable_location_in_settings'.tr,
          );
        }
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final addressParts = [
          p.name,
          p.street,
          p.subLocality,
          p.locality,
          p.postalCode,
          p.administrativeArea,
          p.country,
        ].where((e) => e != null && e.trim().isNotEmpty).toSet().toList();

        patientLocation = addressParts.join(', ');
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void onSymptomsNoneChanged(bool? value) {
    symptomsNone.value = value ?? false;
    if (symptomsNone.value) {
      symptomNausea.value = false;
      symptomFatigue.value = false;
      symptomDifficultyBreathing.value = false;
      symptomSweating.value = false;
    }
  }

  String _buildKindOfPain() {
    List<String> items = [];
    if (painPressure.value) {
      items.add('pain_pressure'.tr);
    }
    if (painFullness.value) {
      items.add('pain_fullness'.tr);
    }
    if (painTightness.value) {
      items.add('pain_tightness'.tr);
    }
    if (painBurning.value) {
      items.add('pain_burning'.tr);
    }
    return items.join(', ');
  }

  String _buildSymptoms() {
    if (symptomsNone.value) {
      return 'symptoms_none'.tr;
    }
    List<String> items = [];
    if (symptomNausea.value) {
      items.add('symptom_nausea_vomiting'.tr);
    }
    if (symptomFatigue.value) {
      items.add('symptom_fatigue_syncope'.tr);
    }
    if (symptomDifficultyBreathing.value) {
      items.add('symptom_difficulty_breathing'.tr);
    }
    if (symptomSweating.value) {
      items.add('symptom_sweating'.tr);
    }
    return items.join(', ');
  }

  bool _validateForm() {
    final kindOfPain = _buildKindOfPain();
    final symptoms = _buildSymptoms();

    if (forWhom.value.isEmpty ||
        locationCentral.value.isEmpty ||
        painGoing.value.isEmpty ||
        durationMoreThan5.value.isEmpty ||
        painAfterExertion.value.isEmpty ||
        kindOfPain.isEmpty ||
        symptoms.isEmpty) {
      AppSnackbars.showError(
        'validation_error'.tr,
        'please_answer_all_questions'.tr,
      );
      return false;
    }

    if (forWhom.value == 'Other') {
      if (!dontKnowName.value && fullNameController.text.trim().isEmpty) {
        AppSnackbars.showError(
          'validation_error'.tr,
          'please_enter_full_name'.tr,
        );
        return false;
      }
      final ageText = ageController.text.trim();
      if (ageText.isEmpty) {
        AppSnackbars.showError('validation_error'.tr, 'please_enter_age'.tr);
        return false;
      }
      final ageNum = int.tryParse(ageText);
      if (ageNum == null || ageNum <= 0 || ageNum > 100) {
        AppSnackbars.showError('validation_error'.tr, 'enter_valid_age'.tr);
        return false;
      }
      if (gender.value.isEmpty) {
        AppSnackbars.showError(
          'validation_error'.tr,
          'please_select_gender'.tr,
        );
        return false;
      }
      if (pastHistoryHTNDM.value.isEmpty) {
        AppSnackbars.showError(
          'validation_error'.tr,
          'please_answer_all_questions'.tr,
        );
        return false;
      }
    }

    return true;
  }

  Future<void> submitAssessment() async {
    if (!_validateForm()) {
      return;
    }

    await _ensurePatientId();

    if (latitude.isEmpty || longitude.isEmpty || patientLocation.isEmpty) {
      isLoading.value = true;
      await _fetchLocation(promptUserIfDisabled: true);
      isLoading.value = false;
    }

    final name = forWhom.value == 'Self'
        ? patientName
        : (dontKnowName.value ? 'Unknown' : fullNameController.text.trim());
    final age = forWhom.value == 'Self'
        ? patientAge
        : ageController.text.trim();
    final gen = forWhom.value == 'Self' ? patientGender : gender.value;
    final past = forWhom.value == 'Self' ? pastHistory : pastHistoryHTNDM.value;

    final req = AddChestPainRequest(
      patientId: patientId,
      forWhom: forWhom.value,
      fullName: name,
      age: age,
      gender: gen,
      pastHistory: past,
      kindOfPain: _buildKindOfPain(),
      location: locationCentral.value,
      painGoing: painGoing.value,
      duration: durationMoreThan5.value,
      symptoms: _buildSymptoms(),
      exertion: painAfterExertion.value,
      startedPain: '',
      latitude: latitude,
      longitude: longitude,
      patientLocation: patientLocation,
    );

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.addChestPain,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      final chestPainRes = ChestPainResponse.fromJson(response.data);

      if (chestPainRes.status == 'success') {
        currentChestPainId = chestPainRes.chestPainId;

        if (chestPainRes.score < 4) {
          Get.toNamed(
            '/chest-pain-other-questions',
            arguments: {
              'patient_id': patientId,
              'chest_pain_id': currentChestPainId.toString(),
              'score': chestPainRes.score,
              'forWhom': forWhom.value,
              'pastSurgery': pastSurgery,
              'familyHTK': familyHTK,
            },
          );
        } else {
          ChestPainScoreDialog.show(
            score: chestPainRes.score,
            onEmergencyConsultation: handleEmergencyConsultation,
            onSharePdf: sharePdfReport,
            onOk: () => Get.until(
              (route) => route.settings.name == '/patient-dashboard',
            ),
          );
        }
      } else {
        if (chestPainRes.msg == 'Medical form not found') {
          MedicalFormChestPainDialog.show(
            onSubmit: (history, surgery, family) {
              pastHistory = history;
              pastSurgery = surgery;
              familyHTK = family;
              submitAssessment();
            },
          );
        } else {
          AppSnackbars.showError('error'.tr, chestPainRes.msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('error'.tr, 'failed_to_load_data'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void handleEmergencyConsultation() {
    _razorpayService.openPayment(
      amountInPaise: 30000, // ₹300.00
      description: 'Emergency Doctor Consultation',
      onSuccess: (res) {
        AppSnackbars.showSuccess('success'.tr, 'Emergency consultation booked');
        Get.until((route) => route.settings.name == '/patient-dashboard');
      },
      onFailure: (err) {
        AppSnackbars.showError('error'.tr, err.message ?? 'Payment failed');
        Get.until((route) => route.settings.name == '/patient-dashboard');
      },
    );
  }

  Future<void> sharePdfReport() async {
    if (currentChestPainId == 0) return;

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.chestPainPdf,
        data: DownloadChestPainPdfRequest(
          chestPainId: currentChestPainId.toString(),
        ).toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      final pdfRes = CommonPdfResponse.fromJson(response.data);
      if (pdfRes.status == 'success' && pdfRes.url.isNotEmpty) {
        final pdfBytesRes = await dio.Dio().get<List<int>>(
          pdfRes.url,
          options: dio.Options(responseType: dio.ResponseType.bytes),
        );

        if (pdfBytesRes.data != null) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/chest_pain_report.pdf');
          await file.writeAsBytes(pdfBytesRes.data!);
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path)],
              subject: 'Chest Pain Evaluation Report',
            ),
          );
        }
      } else {
        AppSnackbars.showError(
          'error'.tr,
          pdfRes.msg.isNotEmpty ? pdfRes.msg : 'Error generating PDF',
        );
      }
    } catch (e) {
      AppSnackbars.showError('error'.tr, 'Error generating PDF');
    } finally {
      isLoading.value = false;
    }
  }

  void openDisclaimerUrl() async {
    final uri = Uri.parse('https://doi.org/10.1590/1516-3180.2018.0238101218');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
