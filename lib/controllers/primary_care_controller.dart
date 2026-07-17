import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../services/api/api_client.dart';

class PrimaryCareController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();

  // Route arguments
  String patientId = '';
  String appointmentId = '';
  String doctorId = '';
  String doctorName = '';
  String place = '';
  String height = '';
  String weight = '';
  String formType = '';
  String patientName = '';
  String age = '';

  // UI state
  final RxBool isLoading = false.obs;
  final RxString loggedInUserName = ''.obs;

  // BP
  final RxBool haveBPApparatus = true.obs;
  final systolicController = TextEditingController(text: '130');
  final diastolicController = TextEditingController(text: '80');
  final pulseRateController = TextEditingController(text: '80');

  // Sugar
  final RxBool haveGlucometer = true.obs;
  final fastingController = TextEditingController();
  final afterFoodController = TextEditingController();
  final randomController = TextEditingController();

  // Symptoms
  final symptomsController = TextEditingController();
  final RxList<String> selectedQuickSymptoms = <String>[].obs;

  // Images
  final RxList<XFile> selectedImages = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      patientId = args['patientId']?.toString() ?? '';
      appointmentId = args['appointmentId']?.toString() ?? '';
      doctorId = args['doctorId']?.toString() ?? '';
      doctorName = args['doctorName']?.toString() ?? '';
      place = args['place']?.toString() ?? '';
      height = args['height']?.toString() ?? '';
      weight = args['weight']?.toString() ?? '';
      formType = args['formType']?.toString() ?? 'Primary Care';
      patientName = args['patientName']?.toString() ?? '';
      age = args['age']?.toString() ?? '';
    }
    _loadLoggedInName();
  }

  Future<void> _loadLoggedInName() async {
    final prefs = await SharedPreferences.getInstance();
    loggedInUserName.value = prefs.getString(AppConstants.prefUserName) ?? '';
  }

  void toggleBPApparatus(bool value) {
    haveBPApparatus.value = value;
  }

  void toggleGlucometer(bool value) {
    haveGlucometer.value = value;
  }

  void toggleSymptom(String symptom, bool isSelected) {
    final currentText = symptomsController.text.trim();
    List<String> parts = currentText.isNotEmpty
        ? currentText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : [];

    if (isSelected) {
      if (!parts.contains(symptom)) {
        parts.add(symptom);
      }
    } else {
      parts.remove(symptom);
    }

    symptomsController.text = parts.join(', ');
  }

  Future<void> pickImageFromGallery() async {
    if (selectedImages.length >= 5) {
      Get.snackbar('Limit Reached', 'You can upload up to 5 images only');
      return;
    }
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      final availableSlots = 5 - selectedImages.length;
      final toAdd = images.take(availableSlots);
      selectedImages.addAll(toAdd);
    }
  }

  Future<void> captureImageFromCamera() async {
    if (selectedImages.length >= 5) {
      Get.snackbar('Limit Reached', 'You can upload up to 5 images only');
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImages.add(image);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitForm() async {
    final symptoms = symptomsController.text.trim();
    if (symptoms.isEmpty) {
      Get.snackbar('Error', 'Please describe or select symptoms');
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final Map<String, dynamic> formMap = {
        'patient_id': patientId,
        'appointment_id': appointmentId,
        'place': place,
        'have_bp_apparatus': haveBPApparatus.value ? 'Yes' : 'No',
        'systolic_1': haveBPApparatus.value ? systolicController.text.trim() : '',
        'diastolic_1': haveBPApparatus.value ? diastolicController.text.trim() : '',
        'heart_rate_1': haveBPApparatus.value ? pulseRateController.text.trim() : '',
        'have_glucometer': haveGlucometer.value ? 'Yes' : 'No',
        'fasting': haveGlucometer.value ? fastingController.text.trim() : '',
        'after_food': haveGlucometer.value ? afterFoodController.text.trim() : '',
        'random': haveGlucometer.value ? randomController.text.trim() : '',
        'other_symptom_details': symptoms,
        'form_type': formType,
      };

      final formData = dio.FormData.fromMap(formMap);

      // Attach images sequentially matching requestBodyImageInvestigation1-5
      for (int i = 0; i < selectedImages.length; i++) {
        final file = await dio.MultipartFile.fromFile(
          selectedImages[i].path,
          filename: 'prescription_$i.jpg',
        );
        formData.files.add(MapEntry('investigation_img_${i + 1}', file));
      }

      final response = await apiClient.post(
        ApiEndpoints.primaryCareForm,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final status = response.data['status']?.toString();
        final msg = response.data['msg']?.toString() ?? 'Form submitted successfully';
        if (status == 'success') {
          Get.snackbar(
            'Success',
            msg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Go to manage patients
          Get.offAllNamed('/manage-patients');
        } else {
          Get.snackbar('Submission Failed', msg);
        }
      } else {
        Get.snackbar('Error', 'API submission failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong submitting form');
    } finally {
      isLoading.value = false;
    }
  }
}


