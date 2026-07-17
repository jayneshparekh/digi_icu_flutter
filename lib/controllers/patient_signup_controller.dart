import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../services/api/api_client.dart';

class PatientSignUpController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final firstNameController = TextEditingController();
  final midNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();

  // Observable States
  final RxString selectedGender = 'Male'.obs;
  final RxList<String> selectedPastHistory = <String>[].obs;
  final RxBool acceptTerms = false.obs;
  final RxBool isLoading = false.obs;

  // Selected Profile Picture State
  final RxString pickedImagePath = ''.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    midNameController.dispose();
    lastNameController.dispose();
    mobileNoController.dispose();
    ageController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Toggle past history selection
  void togglePastHistory(String item, bool isChecked) {
    if (item == 'None') {
      if (isChecked) {
        selectedPastHistory.value = ['None'];
      } else {
        selectedPastHistory.remove('None');
      }
    } else {
      selectedPastHistory.remove('None');
      if (isChecked) {
        if (!selectedPastHistory.contains(item)) {
          selectedPastHistory.add(item);
        }
      } else {
        selectedPastHistory.remove(item);
      }
    }
  }

  // Image Picker Logic
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (file != null) {
        pickedImagePath.value = file.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Registration Submission Logic
  Future<void> registerPatient() async {
    if (firstNameController.text.trim().isEmpty ||
        midNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        mobileNoController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'First name, Middle name, Last name, Mobile no and Age are required fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPastHistory.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one past history option.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 1. Resolve Location & Geocode Address
      double? latitude;
      double? longitude;
      String country = '';
      String state = '';
      String district = '';
      String taluka = '';
      String village = '';
      String pinCode = '';
      String homeAddress = '';

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5),
          );
          latitude = position.latitude;
          longitude = position.longitude;

          final List<Placemark> placemarks = await placemarkFromCoordinates(
            latitude,
            longitude,
          );
          if (placemarks.isNotEmpty) {
            final pm = placemarks.first;
            country = pm.country ?? '';
            state = pm.administrativeArea ?? '';
            district = pm.subAdministrativeArea ?? pm.locality ?? '';
            taluka = pm.subLocality ?? pm.thoroughfare ?? '';
            village = pm.locality ?? pm.subLocality ?? '';
            pinCode = pm.postalCode ?? '';
            homeAddress =
                '${pm.street ?? ''}, ${pm.subLocality ?? ''}, ${pm.locality ?? ''}, ${pm.postalCode ?? ''}';
          }
        }
      } catch (locationErr) {
        // Location failed (e.g. emulator, disabled GPS, timeout) - proceed with empty location fields
        Get.log(
          'Location fetch failed, proceeding without location details: $locationErr',
        );
      }

      // 2. Load preferences for auth token, doctor id, etc.
      final prefs = await SharedPreferences.getInstance();
      final String token =
          prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final String doctorId = prefs.getString(AppConstants.prefUserId) ?? '';
      final String instituteId = prefs.getString('institute_id') ?? '';
      final String loginUserType =
          prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';

      // 3. Construct past history string
      final String pastHistoryStr = selectedPastHistory.join(', ');

      // 4. Create FormData Map
      final Map<String, dynamic> formDataMap = {
        'first_name': firstNameController.text.trim(),
        'mid_name': midNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'mobile_no': mobileNoController.text.trim(),
        'age': ageController.text.trim(),
        'gender': selectedGender.value,
        'email_id': emailController.text.trim(),
        'prefer_languages': '',
        'past_history': pastHistoryStr,
        'registration_from': loginUserType,
        'registration_from_id': doctorId,
        'institute_id': instituteId,
        'is_family_member': '0',
        'parent_id': '0',
        'latitude': latitude?.toString() ?? '',
        'longitude': longitude?.toString() ?? '',
        'country': country,
        'state': state,
        'district': district,
        'taluka': taluka,
        'village': village,
        'pin_code': pinCode,
        'home_address': homeAddress,
      };

      if (pickedImagePath.value.isNotEmpty) {
        formDataMap['image'] = await dio.MultipartFile.fromFile(
          pickedImagePath.value,
          filename: pickedImagePath.value.split('/').last,
        );
      }

      final dio.FormData formData = dio.FormData.fromMap(formDataMap);

      // 5. Send POST request to patient signup
      final response = await apiClient.post(
        ApiEndpoints.patientSignup,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = response.data;
        if (res['status'] == 'success') {
          Get.snackbar(
            'Success',
            res['msg'] ?? 'Patient registered successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Go back to list and refresh
          Get.back(result: true);
        } else {
          Get.snackbar(
            'Registration Error',
            res['msg'] ?? 'Could not register patient.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to connect to the server.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}


