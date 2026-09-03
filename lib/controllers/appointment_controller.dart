import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/request/patients/doctor_list_patient_side_req.dart';
import '../models/response/patients/doctor_list_patient_side_response.dart';
import '../models/response/patients/check_payment_status_response.dart';
import '../services/api/api_client.dart';

class AppointmentController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Route arguments
  String patientId = '';
  String patientName = '';
  String age = '';
  String gender = '';
  bool isFromDoctorHomeService = false;
  String homeServiceDoctorId = '';
  String doctorHsReqId = '';
  String problem = '';
  String userType = '';
  String leaderId = '';
  String speciality = '';

  // Reactive states
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;
  final RxList<DoctorDataModel> doctors = <DoctorDataModel>[].obs;
  final RxList<DoctorDataModel> filteredDoctors = <DoctorDataModel>[].obs;
  final RxString medicalForm = '0'.obs;
  final RxString loggedInUserName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      patientId = args['patientId']?.toString() ?? '';
      patientName = args['patientName']?.toString() ?? args['userName']?.toString() ?? '';
      age = args['userAge']?.toString() ?? '';
      gender = args['userGender']?.toString() ?? '';
      isFromDoctorHomeService = args['isFromDoctorHomeService'] as bool? ?? false;
      homeServiceDoctorId = args['doctor_id']?.toString() ?? '';
      doctorHsReqId = args['doctor_hs_req_id']?.toString() ?? '';
      problem = args['problem']?.toString() ?? '';
      userType = args['type']?.toString() ?? '';
      leaderId = args['leaderId']?.toString() ?? '';
      speciality = args['speciality']?.toString() ?? '';
    }

    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      loggedInUserName.value = prefs.getString(AppConstants.prefUserName) ?? '';

      final dayName = DateFormat('EEEE').format(DateTime.now());
      final timeStr = DateFormat('HH:mm:ss').format(DateTime.now());

      final request = DoctorListPatientSideReq(
        page: 1,
        patientId: patientId,
        day: dayName,
        time: timeStr,
        speciality: speciality,
      );

      final response = await apiClient.post(
        ApiEndpoints.getDoctorList,
        data: request.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final docRes = DoctorListPatientSideResponse.fromJson(response.data);
        if (docRes.status == 'success') {
          medicalForm.value = docRes.medicalForm;
          doctors.assignAll(docRes.data);
          filteredDoctors.assignAll(docRes.data);
        } else {
          errorMsg.value = docRes.msg;
        }
      } else {
        errorMsg.value = 'Failed to load doctors';
      }
    } catch (e) {
      errorMsg.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(doctors);
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredDoctors.assignAll(doctors.where((doc) {
        final matchesFirstName = doc.firstName.toLowerCase().contains(lowercaseQuery);
        final matchesMidName = doc.midName.toLowerCase().contains(lowercaseQuery);
        final matchesLastName = doc.lastName.toLowerCase().contains(lowercaseQuery);
        return matchesFirstName || matchesMidName || matchesLastName;
      }).toList());
    }
  }

  Future<void> checkPaymentStatus(DoctorDataModel doctor) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.checkPaymentStatus,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final payRes = CheckPaymentStatusResponse.fromJson(response.data);
        if (payRes.status == 'success') {
          if (payRes.planStatus == '0') {
            if (medicalForm.value == '1') {
              Get.toNamed('/take-appointment', arguments: {
                'doctorId': doctor.id,
                'doctorName': 'Dr. ${doctor.firstName} ${doctor.lastName}',
                'patientId': patientId,
                'userName': patientName,
                'userAge': age,
                'userGender': gender,
                'isFromDoctorHomeService': isFromDoctorHomeService,
                'doctor_hs_req_id': doctorHsReqId,
                'problem': problem,
                'type': userType,
                'speciality': speciality,
              });
            } else {
              Get.toNamed('/medical-form', arguments: {
                'doctorId': doctor.id,
                'doctorName': 'Dr. ${doctor.firstName} ${doctor.lastName}',
                'patientId': patientId,
                'userAge': age,
                'userGender': gender,
                'isFromDoctorHomeService': isFromDoctorHomeService,
                'doctor_hs_req_id': doctorHsReqId,
                'problem': problem,
                'type': userType,
                'speciality': speciality,
              });
            }
          } else {
            Get.toNamed('/package-categories', arguments: {
              'patientId': patientId,
              'userName': patientName,
              'userAge': age,
              'userGender': gender,
              'medicalForm': medicalForm.value,
              'consultationCharge': doctor.consultingCharges,
              'packageType': 'General Consultation',
              'type': userType,
              'leaderId': leaderId,
              'mData': doctor,
            });
          }
        } else {
          AppSnackbars.showError('Error', payRes.msg);
        }
      } else {
        AppSnackbars.showError('Error', 'Failed to check payment status');
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Something went wrong checking payment');
    } finally {
      isLoading.value = false;
    }
  }
}


