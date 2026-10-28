import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/lab/common_lab_req.dart';
import 'package:digi_icu_flutter/models/request/leader/change_patient_bed_request.dart';
import 'package:digi_icu_flutter/models/request/user/admit_patient_request_model.dart';
import 'package:digi_icu_flutter/models/response/leader/place_bed_info_response.dart';
import 'package:digi_icu_flutter/models/response/patient/admit_request_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/change_bed_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/ipd_admit_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/ipd_admit_flow_delegate.dart';
import 'package:digi_icu_flutter/views/widgets/pre_admit_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';

class AdmitPatientRequestController extends GetxController implements IPDAdmitFlowDelegate {
  final ApiClient apiClient = Get.find<ApiClient>();
  late final SharedPreferences _prefs;

  @override
  late final String instituteId;

  // Selected Status Tab: 'Admit Requested' or 'Admitted'
  final RxString currentStatus = 'Admit Requested'.obs;

  // Search Query
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSubmittingAdmission = false.obs;
  final RxBool isSubmittingBedChange = false.obs;

  // List of patients
  final RxList<AdmitRequestPatientItem> allPatients = <AdmitRequestPatientItem>[].obs;
  final RxList<AdmitRequestPatientItem> filteredPatients = <AdmitRequestPatientItem>[].obs;

  // Currently focused patient for Admission / Bed Change flow
  final Rxn<AdmitRequestPatientItem> currentSelectedPatient = Rxn<AdmitRequestPatientItem>();

  // ==========================================
  // Pre-Admit & IPD Admit Dialog State (implements IPDAdmitFlowDelegate)
  // ==========================================
  @override
  String get patientId => currentSelectedPatient.value?.patientId ?? '';

  @override
  String get bookingId => currentSelectedPatient.value?.lastAppointmentId ?? '';

  @override
  String get fullName => currentSelectedPatient.value?.patientName ?? '';

  @override
  String get age => currentSelectedPatient.value?.age ?? '';

  @override
  String get gender => currentSelectedPatient.value?.gender ?? '';

  @override
  String get doctorId => currentSelectedPatient.value?.doctorId ?? '';

  @override
  final RxString userType = 'Doctor'.obs;

  @override
  final RxString loggedInDoctorName = ''.obs;

  @override
  final RxString selectedInstituteId = ''.obs;

  @override
  final RxString selectedInstituteName = ''.obs;

  @override
  final RxString selectedInstituteLogo = ''.obs;

  @override
  final RxString selectedInstituteAddress = ''.obs;

  @override
  final RxString selectedInstituteMobile = ''.obs;

  @override
  final RxBool isDayCare = false.obs;

  @override
  final RxBool isDayCareAvailable = false.obs;

  @override
  final RxString dayCareOption = 'others'.obs;

  final RxString selectedAdmitDoctorId = ''.obs;
  final RxString selectedAdmitDoctor = ''.obs;

  @override
  final RxString selectedConsultantDoctorId = ''.obs;

  @override
  final RxString selectedConsultantDoctorName = ''.obs;

  @override
  final RxList<dynamic> admitDoctors = <dynamic>[].obs;

  @override
  final RxString selectedReferralDoctorId = ''.obs;

  @override
  final RxList<dynamic> referralDoctors = <dynamic>[].obs;

  @override
  final RxBool isAdmitPrescription = false.obs;

  @override
  final RxString selectedAdmitPlace = ''.obs;

  @override
  final RxString selectedAdmitWard = ''.obs;

  @override
  final RxString selectedAdmitBed = ''.obs;

  @override
  final RxList<dynamic> admitWardOptions = <dynamic>[].obs;

  @override
  final RxList<dynamic> admitBedOptions = <dynamic>[].obs;

  @override
  final RxString approxCost = ''.obs;

  @override
  final RxString approxDays = ''.obs;

  @override
  final RxString admissionAmount = ''.obs;

  @override
  final RxString admissionDate = ''.obs;

  @override
  final RxString admissionTime = ''.obs;

  @override
  final RxString dischargeDate = ''.obs;

  @override
  final RxString dischargeTime = ''.obs;

  @override
  final RxString advanceAmount = ''.obs;

  @override
  final RxString admissionPaymentStatus = 'Due'.obs;

  @override
  final RxString admissionPaymentMode = 'Cash'.obs;

  @override
  final RxString advancePaymentStatus = 'Due'.obs;

  @override
  final RxString advancePaymentMode = 'Cash'.obs;

  @override
  final RxString admissionTransactionId = ''.obs;

  @override
  final RxString advanceTransactionId = ''.obs;

  @override
  final RxString admissionNotes = ''.obs;

  @override
  final RxString referralDoctor = ''.obs;

  @override
  final Rxn<Uint8List> canvasDrawingBytes = Rxn<Uint8List>();

  @override
  final RxString noteImagePath = ''.obs;

  final RxBool hasReferralDoctor = false.obs;

  // ==========================================
  // Change Place & Bed State
  // ==========================================
  final RxList<PlaceBedInfoItem> placeList = <PlaceBedInfoItem>[].obs;
  final RxString changeSelectedPlace = ''.obs;
  final RxString changeSelectedName = ''.obs;
  final RxString changeSelectedBedNo = ''.obs;
  final RxList<String> changeAvailableBeds = <String>[].obs;
  final RxBool isLoadingBedsHierarchy = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.isRegistered<SharedPreferences>()
        ? Get.find<SharedPreferences>()
        : Get.find<StorageService>().prefs;
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    instituteId = args['institute_id']?.toString() ?? args['instituteId']?.toString() ?? '';

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
      _applyFilter();
    });

    loadAdmitRequests();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void switchTab(String status) {
    if (currentStatus.value != status) {
      currentStatus.value = status;
      loadAdmitRequests();
    }
  }

  /// Loads admit requests from API by status: 'Admit Requested' or 'Admitted'
  Future<void> loadAdmitRequests() async {
    try {
      isLoading.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userId = prefs.getString(AppConstants.prefUserId) ?? '';
      final currentInstId = instituteId.isNotEmpty
          ? instituteId
          : (prefs.getString('institute_id') ?? '');

      final formDataMap = <String, dynamic>{
        'status': currentStatus.value,
        'leader_id': userId,
      };
      if (currentInstId.isNotEmpty) {
        formDataMap['institute_id'] = currentInstId;
      }

      final response = await apiClient.post(
        ApiEndpoints.getAdmitRequestsByStatus,
        data: dio.FormData.fromMap(formDataMap),
        options: dio.Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          try {
            rawData = jsonDecode(rawData);
          } catch (_) {}
        }
        if (rawData is Map<String, dynamic>) {
          final res = AdmitRequestResponse.fromJson(rawData);
          if (res.status == 'success') {
            allPatients.assignAll(res.data);
            _applyFilter();
          } else {
            allPatients.clear();
            filteredPatients.clear();
          }
        } else {
          allPatients.clear();
          filteredPatients.clear();
        }
      } else {
        allPatients.clear();
        filteredPatients.clear();
        AppSnackbars.showError('error'.tr, 'failed_to_load_admit_requests'.tr);
      }
    } catch (e) {
      debugPrint('Error loading admit requests: $e');
      allPatients.clear();
      filteredPatients.clear();
      AppSnackbars.showError('error'.tr, 'failed_to_load_admit_requests'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredPatients.assignAll(allPatients);
    } else {
      filteredPatients.assignAll(
        allPatients.where((item) {
          final pName = (item.patientName ?? '').toLowerCase();
          final mhc = (item.mhcId ?? '').toLowerCase();
          final mob = (item.mobileNo ?? '').toLowerCase();
          final doc = (item.doctorName ?? '').toLowerCase();
          return pName.contains(query) ||
              mhc.contains(query) ||
              mob.contains(query) ||
              doc.contains(query);
        }),
      );
    }
  }

  // =========================================================================
  // Admission Flow: check diagnosis -> confirmation -> pre-admit -> admit dialog
  // =========================================================================

  Future<void> onAdmitPatientClick(AdmitRequestPatientItem patient) async {
    currentSelectedPatient.value = patient;
    await _checkDiagnosisAndProceed(patient);
  }

  Future<void> _checkDiagnosisAndProceed(AdmitRequestPatientItem patient) async {
    try {
      isLoading.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getPatientDiagnosis,
        data: {'patient_id': patient.patientId ?? ''},
        options: dio.Options(headers: {'Authorization': token}),
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          _showAdmitConfirmationDialog(patient);
        } else {
          final msg = response.data['msg']?.toString() ?? 'record_diagnosis_prompt'.tr;
          AppSnackbars.showError('error'.tr, msg);
          final result = await Get.toNamed(
            '/diagnosis',
            arguments: {
              'patient_id': patient.patientId ?? '',
              'bookingId': patient.lastAppointmentId ?? '',
            },
          );
          if (result == true) {
            _checkDiagnosisAndProceed(patient);
          }
        }
      } else {
        AppSnackbars.showError('error'.tr, 'failed_to_check_diagnosis'.tr);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error checking diagnosis: $e');
      AppSnackbars.showError('error'.tr, 'failed_to_check_diagnosis'.tr);
    }
  }

  void _showAdmitConfirmationDialog(AdmitRequestPatientItem patient) {
    final String name = patient.patientName ?? 'this patient';
    AppDialog.show(
      title: 'admit_confirm_title'.tr,
      body: Text('admit_confirm_msg'.tr.replaceAll('@name', name)),
      cancelLabel: 'no'.tr,
      confirmLabel: 'yes'.tr,
      onConfirm: () => _openPreAdmitDialog(patient),
    );
  }

  Future<void> _openPreAdmitDialog(AdmitRequestPatientItem patient) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userId = prefs.getString(AppConstants.prefUserId) ?? '';
      var role = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
      if (role == 'Digi Icu Nurse' || role == 'Duty Doctor') {
        role = 'Nurse';
      }

      final resp = await apiClient.post(
        ApiEndpoints.getInstitute,
        data: {
          'user_id': userId,
          'user_type': role.isNotEmpty ? role : 'Doctor',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      List<dynamic> instituteList = [];
      if (resp.statusCode == 200 && resp.data != null && resp.data['status'] == 'success') {
        instituteList = resp.data['data'] ?? [];
      }

      final fallbackInstId = patient.instituteId?.isNotEmpty == true ? patient.instituteId! : instituteId;
      if (instituteList.isEmpty && fallbackInstId.isNotEmpty) {
        instituteList = [
          {
            'institute_id': fallbackInstId,
            'id': fallbackInstId,
            'institute_name': patient.instituteName ?? 'Default Institute',
          },
        ];
      }

      // Pre-select institute
      if (patient.instituteId != null && patient.instituteId!.isNotEmpty) {
        selectedInstituteId.value = patient.instituteId!;
        selectedInstituteName.value = patient.instituteName ?? '';
      } else if (instituteList.isNotEmpty) {
        final first = instituteList.first;
        selectedInstituteId.value = (first['id'] ?? first['institute_id'])?.toString() ?? '';
        selectedInstituteName.value = first['institute_name']?.toString() ?? '';
      }

      await checkDayCareAvailability(selectedInstituteId.value);

      Get.dialog(
        PreAdmitDialog(
          institutes: instituteList,
          delegate: this,
          onSubmit: () async {
            Get.back();
            await _openIpdAdmitDialog(patient);
          },
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint('Error opening pre-admit dialog: $e');
      AppSnackbars.showError('error'.tr, 'failed_to_check_diagnosis'.tr);
    }
  }

  @override
  Future<void> checkDayCareAvailability(String instId) async {
    if (instId.isEmpty) return;
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final resp = await apiClient.post(
        ApiEndpoints.getInstituteAmenities,
        data: {'institute_id': instId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (resp.statusCode == 200 && resp.data != null && resp.data['status'] == 'success') {
        final dayCareVal = resp.data['day_care']?.toString() ??
            resp.data['data']?[0]?['day_care']?.toString() ??
            '0';
        final available = dayCareVal != '0';
        isDayCareAvailable.value = available;
        if (available) {
          isDayCare.value = true;
          dayCareOption.value = 'day_care';
        } else {
          isDayCare.value = false;
          dayCareOption.value = 'others';
        }
      } else {
        isDayCareAvailable.value = false;
        isDayCare.value = false;
        dayCareOption.value = 'others';
      }
    } catch (e) {
      isDayCareAvailable.value = false;
      isDayCare.value = false;
      dayCareOption.value = 'others';
    }
  }

  Future<void> _openIpdAdmitDialog(AdmitRequestPatientItem patient) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstituteId = selectedInstituteId.value;

      selectedAdmitPlace.value = '';
      selectedAdmitWard.value = '';
      selectedAdmitBed.value = '';
      admitWardOptions.clear();
      admitBedOptions.clear();

      final now = DateTime.now();
      admissionDate.value =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      admissionTime.value =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Pre-fill doctor info from patient request
      selectedConsultantDoctorId.value = patient.doctorId ?? '';
      selectedConsultantDoctorName.value = patient.doctorName ?? '';

      await _fetchInstituteDetails(targetInstituteId);
      await _fetchDoctorsForInstitute(targetInstituteId);
      await _fetchLabIdAndLoadReferralDoctors(targetInstituteId);
      await _checkAdmitPrescription();

      // Fetch amenities
      final amenitiesResp = await apiClient.post(
        ApiEndpoints.getInstituteAmenities,
        data: {'institute_id': targetInstituteId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (amenitiesResp.statusCode == 200 && amenitiesResp.data != null) {
        final Map<String, dynamic> data = amenitiesResp.data['data'] is Map<String, dynamic>
            ? amenitiesResp.data['data']
            : amenitiesResp.data;

        Get.dialog(
          IpdAdmitDialog(
            instituteAmenities: [data],
            delegate: this,
          ),
          barrierDismissible: false,
        );
      } else {
        AppSnackbars.showError('error'.tr, 'admission_failed'.tr);
      }
    } catch (e) {
      debugPrint('Error opening IPD Admit Dialog: $e');
      AppSnackbars.showError('error'.tr, 'admission_failed'.tr);
    }
  }

  Future<void> _fetchInstituteDetails(String instId) async {
    if (instId.isEmpty) return;
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final userId = prefs.getString(AppConstants.prefUserId) ?? '';
      final userTypeVal = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';

      final resp = await apiClient.post(
        ApiEndpoints.getInstitute,
        data: {'user_id': userId, 'user_type': userTypeVal},
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null && resp.data['status'] == 'success') {
        final List<dynamic> list = resp.data['data'] ?? [];
        final match = list.firstWhere(
          (item) => item['id']?.toString() == instId || item['institute_id']?.toString() == instId,
          orElse: () => null,
        );
        if (match != null) {
          selectedInstituteName.value = match['institute_name']?.toString() ?? '';
          selectedInstituteLogo.value = match['institute_logo']?.toString() ?? '';
          selectedInstituteAddress.value = match['institute_adress']?.toString() ?? '';
          selectedInstituteMobile.value = match['institute_mobile_no']?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching institute details: $e');
    }
  }

  Future<void> _fetchDoctorsForInstitute(String instId) async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final resp = await apiClient.post(
        ApiEndpoints.getDoctorList,
        data: {'institute_id': instId},
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null && resp.data['status'] == 'success') {
        admitDoctors.assignAll(resp.data['data'] ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching doctors for institute: $e');
    }
  }

  Future<void> _fetchLabIdAndLoadReferralDoctors(String instId) async {
    if (instId.isEmpty || instId == '0') {
      referralDoctors.clear();
      return;
    }
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final url = '${ApiEndpoints.getLabIdApiPrefix}$instId';

      final resp = await apiClient.get(
        url,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        var resData = resp.data;
        if (resData is String) {
          try {
            resData = jsonDecode(resData);
          } catch (_) {}
        }
        if (resData is Map && resData['status']?.toString().toLowerCase() == 'success') {
          final labId = resData['lab_id']?.toString();
          if (labId != null && labId.isNotEmpty && labId != '0') {
            await _fetchReferralDoctors(labId);
            return;
          }
        }
      }
      referralDoctors.clear();
    } catch (e) {
      debugPrint('Error fetching lab ID: $e');
      referralDoctors.clear();
    }
  }

  Future<void> _fetchReferralDoctors(String labId) async {
    if (labId.isEmpty || labId == '0') {
      referralDoctors.clear();
      return;
    }
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final req = CommonLabReq(labId: labId);
      final resp = await apiClient.post(
        ApiEndpoints.getLabOwnDoctors,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        var resData = resp.data;
        if (resData is String) {
          try {
            resData = jsonDecode(resData);
          } catch (_) {}
        }
        if (resData is Map && resData['status'] == 'success') {
          referralDoctors.value = resData['data'] ?? [];
        } else {
          referralDoctors.clear();
        }
      } else {
        referralDoctors.clear();
      }
    } catch (e) {
      debugPrint('Error fetching referral doctors: $e');
      referralDoctors.clear();
    }
  }

  Future<void> _checkAdmitPrescription() async {
    try {
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final resp = await apiClient.post(
        ApiEndpoints.checkAdmitPrescription,
        data: {'appointment_id': bookingId, 'type': 'ipd'},
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null && resp.data['status'] == 'success') {
        isAdmitPrescription.value = (resp.data['msg']?.toString() != '0');
      }
    } catch (e) {
      debugPrint('Error checking admit prescription: $e');
    }
  }

  @override
  Future<void> showImagePickerForNotes() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        noteImagePath.value = picked.path;
      }
    } catch (e) {
      debugPrint('Error picking note image: $e');
    }
  }

  @override
  void validateAndConfirmAdmit() {
    final targetInstId = selectedInstituteId.value.isNotEmpty
        ? selectedInstituteId.value
        : instituteId;
    if (targetInstId.isEmpty || targetInstId == '0') {
      AppSnackbars.showError('error'.tr, 'please_select_institute'.tr);
      return;
    }

    final docId = selectedConsultantDoctorId.value.isNotEmpty
        ? selectedConsultantDoctorId.value
        : doctorId;
    if (docId.isEmpty || docId == '0') {
      AppSnackbars.showError('error'.tr, 'please_select_doctor'.tr);
      return;
    }

    if (selectedAdmitPlace.value.isEmpty) {
      AppSnackbars.showError('error'.tr, 'please_select'.tr);
      return;
    }

    final bool isPaidAmount =
        (admissionAmount.value.isNotEmpty && admissionPaymentStatus.value == 'Paid') ||
        (advanceAmount.value.isNotEmpty && advancePaymentStatus.value == 'Paid');

    final String confirmMsg = isPaidAmount
        ? 'confirm_payment_admit_msg'.tr
        : 'confirm_admit_msg'.tr;

    Get.back(); // Dismiss IpdAdmitDialog safely after validation passes

    final patient = currentSelectedPatient.value;
    if (patient == null) {
      AppSnackbars.showError('error'.tr, 'failed_to_check_diagnosis'.tr);
      return;
    }

    AppDialog.show(
      title: 'admit_confirm_title'.tr,
      body: Text(confirmMsg),
      cancelLabel: 'cancel'.tr,
      confirmLabel: 'submit'.tr,
      onConfirm: () => _submitAdmission(patient),
    );
  }

  Future<void> _submitAdmission(AdmitRequestPatientItem patient) async {
    if (selectedAdmitPlace.value.isEmpty) {
      AppSnackbars.showWarning('warning'.tr, 'please_select_place'.tr);
      return;
    }
    // if (selectedAdmitBed.value.isEmpty) {
    //   AppSnackbars.showWarning('warning'.tr, 'please_select_bed'.tr);
    //   return;
    // }

    try {
      isSubmittingAdmission.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final currentUserId = prefs.getString(AppConstants.prefUserId) ?? '';
      final currentUserType = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';

      final logoUrl = selectedInstituteLogo.value.isNotEmpty
          ? 'https://www.mhclinic.net/MHC/theme/images/institute/${selectedInstituteLogo.value}'
          : 'https://www.mhclinic.net/MHC/theme/images/no_image_found.jpg';

      final req = AdmitPatientRequestModel(
        instituteId: selectedInstituteId.value,
        patientId: patient.patientId ?? '',
        appointmentId: patient.lastAppointmentId ?? '',
        doctorId: selectedConsultantDoctorId.value.isNotEmpty ? selectedConsultantDoctorId.value : (patient.doctorId ?? ''),
        referralDoctor: referralDoctor.value,
        admitDate: admissionDate.value,
        admitTime: admissionTime.value,
        dischargeDate: dischargeDate.value,
        dischargeTime: dischargeTime.value,
        approxCost: approxCost.value,
        approxDays: approxDays.value,
        admissionAmount: admissionAmount.value,
        admissionChargesStatus: admissionPaymentStatus.value,
        admissionChargesMode: admissionPaymentMode.value,
        admissionTransactionId: admissionTransactionId.value,
        advanceAmount: advanceAmount.value,
        advancePaymentStatus: advancePaymentStatus.value,
        advancePaymentMode: advancePaymentMode.value,
        advanceTransactionId: advanceTransactionId.value,
        place: selectedAdmitPlace.value,
        bedNo: selectedAdmitBed.value,
        admitBy: currentUserType,
        admitById: currentUserId,
        admitRequest: '',
        admissionNotes: admissionNotes.value,
        instituteLogo: logoUrl,
        instituteName: selectedInstituteName.value,
        instituteAddress: selectedInstituteAddress.value,
        instituteMobile: selectedInstituteMobile.value,
      );

      final response = await apiClient.post(
        ApiEndpoints.admitPatientFromWeb,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'success') {
          Get.back(); // close dialog
          AppSnackbars.showSuccess('success'.tr, 'admission_completed_success'.tr);
          loadAdmitRequests();
        } else {
          AppSnackbars.showError('error'.tr, resData['msg']?.toString() ?? 'admission_failed'.tr);
        }
      } else {
        AppSnackbars.showError('error'.tr, 'admission_failed'.tr);
      }
    } catch (e) {
      debugPrint('Error submitting admission: $e');
      AppSnackbars.showError('error'.tr, 'admission_failed'.tr);
    } finally {
      isSubmittingAdmission.value = false;
    }
  }

  // =========================================================================
  // Change Place & Bed Flow
  // =========================================================================

  Future<void> onChangeBedClick(AdmitRequestPatientItem patient) async {
    currentSelectedPatient.value = patient;
    changeSelectedPlace.value = patient.currentPlace ?? '';
    changeSelectedName.value = patient.currentName ?? '';
    changeSelectedBedNo.value = patient.currentBedNo ?? '';
    changeAvailableBeds.clear();

    await _loadBedsHierarchy(patient);
    _showChangeBedDialog(patient);
  }

  Future<void> _loadBedsHierarchy(AdmitRequestPatientItem patient) async {
    try {
      isLoadingBedsHierarchy.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstId = patient.instituteId?.isNotEmpty == true ? patient.instituteId! : instituteId;

      final resp = await apiClient.post(
        ApiEndpoints.getAllBedsInfo,
        data: {'institute_id': targetInstId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final res = GetAllBedsInfoResponse.fromJson(resp.data);
        if (res.status == 'success') {
          placeList.assignAll(res.data);
          if (changeSelectedPlace.value.isNotEmpty) {
            updateChangeBeds(changeSelectedPlace.value, changeSelectedName.value, patient.currentBedNo);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading beds hierarchy: $e');
    } finally {
      isLoadingBedsHierarchy.value = false;
    }
  }

  void updateChangeBeds(String place, String name, String? curBed) {
    final placeObj = placeList.firstWhereOrNull((p) => p.place == place);
    final nameObj = placeObj?.names.firstWhereOrNull((n) => n.name == name);
    final beds = List<String>.from(nameObj?.emptyBeds ?? []);

    if (curBed != null && curBed.isNotEmpty && !beds.contains(curBed)) {
      beds.add(curBed);
      beds.sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));
    }
    changeAvailableBeds.assignAll(beds);
  }

  void _showChangeBedDialog(AdmitRequestPatientItem patient) {
    Get.dialog(
      ChangeBedDialog(patient: patient, controller: this),
      barrierDismissible: false,
    );
  }

  Future<void> submitBedChange(AdmitRequestPatientItem patient) async {
    if (changeSelectedPlace.value.isEmpty) {
      AppSnackbars.showWarning('warning'.tr, 'please_select_place'.tr);
      return;
    }
    if (changeSelectedName.value.isEmpty) {
      AppSnackbars.showWarning('warning'.tr, 'please_select_section'.tr);
      return;
    }
    if (changeSelectedBedNo.value.isEmpty) {
      AppSnackbars.showWarning('warning'.tr, 'please_select_bed'.tr);
      return;
    }

    try {
      isSubmittingBedChange.value = true;
      final prefs = _prefs;
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstId = patient.instituteId?.isNotEmpty == true ? patient.instituteId! : instituteId;

      final req = ChangePatientBedRequest(
        instituteId: targetInstId,
        admitId: patient.requestId ?? '',
        patientId: patient.patientId ?? '',
        admitIn: changeSelectedPlace.value,
        name: changeSelectedName.value,
        bedNo: changeSelectedBedNo.value,
        oldPlace: patient.currentPlace ?? '',
        oldName: patient.currentName ?? '',
        oldBedNo: patient.currentBedNo ?? '',
      );

      final resp = await apiClient.post(
        ApiEndpoints.changePatientBed,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final resData = resp.data;
        if (resData['status'] == 'success') {
          Get.back(); // close dialog
          AppSnackbars.showSuccess('success'.tr, 'bed_and_place_changed_success'.tr);
          loadAdmitRequests();
        } else {
          AppSnackbars.showError('error'.tr, resData['msg']?.toString() ?? 'failed_to_change_bed'.tr);
        }
      } else {
        AppSnackbars.showError('error'.tr, 'failed_to_change_bed'.tr);
      }
    } catch (e) {
      debugPrint('Error submitting change bed: $e');
      AppSnackbars.showError('error'.tr, 'failed_to_change_bed'.tr);
    } finally {
      isSubmittingBedChange.value = false;
    }
  }
}
