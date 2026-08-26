import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/response/patients/appointment_slots_response.dart';
import '../models/response/patients/book_appointment_response.dart';
import '../services/api/api_client.dart';
import '../views/widgets/choose_form_option_dialog.dart';

class TakeAppointmentController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Route arguments
  String doctorId = '';
  String doctorName = '';
  String patientId = '';
  String userName = '';
  String age = '';
  String gender = '';
  bool isFromDoctorHomeService = false;
  String doctorHsReqId = '';
  String initialProblem = '';
  String userType = '';
  String speciality = '';

  // UI state
  final RxBool isLoading = false.obs;
  final RxString selectedPlace = ''.obs;
  final RxString loggedInUserName = ''.obs;
  final problemController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      doctorId = args['doctorId']?.toString() ?? '';
      doctorName = args['doctorName']?.toString() ?? '';
      patientId = args['patientId']?.toString() ?? '';
      userName = args['userName']?.toString() ?? '';
      age = args['userAge']?.toString() ?? '';
      gender = args['userGender']?.toString() ?? '';
      isFromDoctorHomeService = args['isFromDoctorHomeService'] as bool? ?? false;
      doctorHsReqId = args['doctor_hs_req_id']?.toString() ?? '';
      initialProblem = args['problem']?.toString() ?? '';
      userType = args['type']?.toString() ?? '';
      speciality = args['speciality']?.toString() ?? '';

      problemController.text = initialProblem;
      if (isFromDoctorHomeService) {
        selectedPlace.value = 'Clinic'; // default Clinic for home service visit
      }
    }
  }

  void selectPlace(String place) {
    selectedPlace.value = place;
  }

  Future<void> bookAppointment() async {
    if (selectedPlace.value.isEmpty) {
      Get.snackbar('Error', 'Please select a location');
      return;
    }

    if (speciality.isNotEmpty && problemController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please describe the purpose of visit');
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      loggedInUserName.value = prefs.getString(AppConstants.prefUserName) ?? '';

      final now = DateTime.now();
      final dayName = DateFormat('EEEE').format(now);
      final dateStr = DateFormat('yyyy-MM-dd').format(now);
      final timeStr = DateFormat('HH:mm:ss').format(now);

      // 1. Fetch Slots for today
      final slotsResponse = await apiClient.post(
        ApiEndpoints.getTimeSlotNew,
        data: {
          'doctor_id': doctorId,
          'day': dayName,
          'date': dateStr,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (slotsResponse.statusCode != 200 || slotsResponse.data == null) {
        Get.snackbar('Error', 'Failed to retrieve slots');
        return;
      }

      final slotsData = AppointmentSlotsResponse.fromJson(slotsResponse.data);
      if (slotsData.status != 'success' || slotsData.data.isEmpty) {
        Get.snackbar('Doctor Unavailable', 'Doctor has no active slots today');
        return;
      }

      final matchedSlot = slotsData.data.last;

      // 3. Book the slot
      final String appointmentBy = (userType == 'Patient') ? 'self' : userType;
      final bookingPayload = {
        'place': selectedPlace.value,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'time_slot_id': matchedSlot.id,
        'time_slot': matchedSlot.timeSlot,
        'booking_date': dateStr,
        'booking_time': timeStr,
        'appointment_by': appointmentBy,
        'appointment_by_id': doctorId,
        'speciality': speciality,
        'problem': problemController.text.trim(),
        'home_service_id': doctorHsReqId,
        'platform': 'App',
        'appointment_type': 'Free',
        'amount': 0,
      };

      final bookResponse = await apiClient.post(
        ApiEndpoints.bookAppointment,
        data: bookingPayload,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (bookResponse.statusCode == 200 && bookResponse.data != null) {
        final res = BookAppointmentResponse.fromJson(bookResponse.data);
        if (res.status == 'success') {
          Get.snackbar(
            'Success',
            'Appointment booked successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: AppColors.white,
          );

          if (res.defaultFormType.isNotEmpty) {
            Get.dialog(
              ChooseFormOptionDialog(
                formTypesString: res.defaultFormType,
                onSelect: (selectedForm) {
                  if (selectedForm == 'Blood Pressure and Sugar Care') {
                    Get.toNamed('/clinical-form', arguments: {
                      'doctorId': doctorId,
                      'patientId': patientId,
                      'doctorName': doctorName,
                      'appointmentId': res.appointmentId,
                      'place': selectedPlace.value,
                      'age': age,
                      'patientName': userName,
                      'isFromDoctorHomeService': isFromDoctorHomeService,
                      'speciality': speciality,
                    });
                  } else {
                    // Primary Care
                    Get.toNamed('/primary-care', arguments: {
                      'doctorId': doctorId,
                      'patientId': patientId,
                      'doctorName': doctorName,
                      'appointmentId': res.appointmentId,
                      'place': selectedPlace.value,
                      'age': age,
                      'patientName': userName,
                      'isFromDoctorHomeService': isFromDoctorHomeService,
                      'speciality': speciality,
                    });
                  }
                },
              ),
              barrierDismissible: false,
            );
          } else {
            // Fallback to /primary-care
            Get.toNamed('/primary-care', arguments: {
              'doctorId': doctorId,
              'patientId': patientId,
              'doctorName': doctorName,
              'appointmentId': res.appointmentId,
              'place': selectedPlace.value,
              'age': age,
              'patientName': userName,
              'isFromDoctorHomeService': isFromDoctorHomeService,
              'speciality': speciality,
            });
          }
        } else {
          Get.snackbar('Booking Failed', res.msg);
        }
      } else {
        Get.snackbar('Error', 'Booking API failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong during booking');
    } finally {
      isLoading.value = false;
    }
  }
}


