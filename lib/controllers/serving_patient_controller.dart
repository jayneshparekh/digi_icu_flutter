import 'dart:convert';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctor/bp_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/other_graph_response.dart';
import 'package:digi_icu_flutter/models/response/doctor/sugar_graph_response.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_patient_note_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_self_note_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_event_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_ecg_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_bp_req.dart';
import 'package:digi_icu_flutter/models/request/doctor/add_tmt_req.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServingPatientController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  // Navigation / screen arguments
  late final String patientId;
  late final String fullName;
  late final String age;
  late final String gender;
  late final String mhcId;
  late final String bookingId;
  late final String mobileNo;
  late final String note;
  late final String selectTab;
  late final String status;
  late final String leaderName;
  late final String leaderMobNo;
  late final String isRefer;
  late final String doctorHomeServiceId;
  late final String doctorId;
  late final String isAdmitted;
  late final String videoUrl;
  late final String clinicalFormStatus;
  late final String medicalFormStatus;
  late final String instituteId;
  late final String qrCode;
  late final bool fromPatient;
  late final String isFrom;

  // Active Center tab state
  final RxString currentTab = 'Dashboard'.obs;

  // Patient detail properties
  final RxString patientRating = '0'.obs;
  final RxBool isLoadingDetails = false.obs;
  final RxString userType = 'Doctor'.obs;

  // Graph tab state & data
  final RxBool isLoadingGraph = false.obs;
  final RxList<BPGraphData> bpGraphList = <BPGraphData>[].obs;
  final Rxn<TargetBp> targetBp = Rxn<TargetBp>();
  final RxList<SugarGraphData> sugarGraphList = <SugarGraphData>[].obs;
  final RxList<OtherGraphData> otherGraphList = <OtherGraphData>[].obs;

  // Prescription tab state & data
  final RxString prescriptionType = 'OPD'.obs;
  final RxBool isLoadingPrescriptions = false.obs;
  final RxBool isLoadingMedicines = false.obs;
  final RxList<dynamic> prescriptionList = <dynamic>[].obs;
  final RxString lastAppointmentId = ''.obs;

  // Doctor Interpretation (DI) tab state & data
  final RxString selectedTopDiTab = 'Notes'.obs; // Notes, Self Notes, Event
  final RxString selectedBottomDiTab = 'ECG'.obs; // ECG, Target BP, TMT
  final RxBool isLoadingDi = false.obs;
  final RxString diagnosisText = ''.obs;

  // DI - Notes & Self Notes
  final TextEditingController patientNoteController = TextEditingController();
  final TextEditingController selfNoteController = TextEditingController();

  // DI - Event State
  final RxString eventType = 'None'.obs; // None, Hospitalisation, Non-Hospitalisation, Death
  final RxString deathType = 'Sudden death noncardiac'.obs;
  final RxString medicinesEffect = 'Good'.obs;
  final RxString askedInvestigations = 'NA'.obs;
  final RxString saltReduction = 'Yes'.obs;
  final RxString exercise = 'Yes'.obs;

  // Hospitalisation Checkboxes
  final RxBool cbMI = false.obs;
  final RxBool cbCOA = false.obs;
  final RxBool cbStroke = false.obs;
  final RxBool cbRatinol = false.obs;
  final RxBool cbHypoglycemia = false.obs;
  final RxBool cbHypotension = false.obs;
  final RxBool cbDKA = false.obs;
  final RxBool cbRegurgitation = false.obs;
  final RxBool cbPIH = false.obs;
  final RxBool cbICH = false.obs;
  final RxBool cbAkI = false.obs;
  final RxBool cbHospitalizationOther = false.obs;
  final TextEditingController hospitalizationOtherController = TextEditingController();

  // Non-Hospitalisation Checkboxes
  final RxBool cbPostural = false.obs;
  final RxBool cbSVT = false.obs;
  final RxBool cbBleeding = false.obs;
  final RxBool cbNonHospOther = false.obs;
  final TextEditingController nonHospOtherController = TextEditingController();

  // DI - ECG State
  final RxString ecgRhythm = 'Sinus'.obs;
  final RxString stSegment = 'Normal'.obs;
  final RxString stSegmentLevel = 'Select…'.obs;
  final TextEditingController sv2Rv5Controller = TextEditingController();
  final RxString ecgImpression = 'Normal'.obs;
  final TextEditingController otherInterpretationController = TextEditingController();
  final RxString ecgReportImageUrl = ''.obs;

  // DI - Target BP State
  final TextEditingController systolicController = TextEditingController(text: '120');
  final TextEditingController diastolicController = TextEditingController(text: '80');

  // DI - TMT State
  final RxString tmtResult = 'Positive'.obs;
  final TextEditingController metsController = TextEditingController();
  final TextEditingController metOtherController = TextEditingController();

  @override
  void onInit() {

    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    patientId = args['patientId']?.toString() ?? '';
    fullName = args['fullName']?.toString() ?? '';
    age = args['age']?.toString() ?? '';
    gender = args['gender']?.toString() ?? '';
    mhcId = args['mhcId']?.toString() ?? '';
    bookingId = args['bookingId']?.toString() ?? '';
    mobileNo = args['mobileNo']?.toString() ?? '';
    note = args['note']?.toString() ?? '';
    selectTab = args['selectTab']?.toString() ?? '';
    status = args['status']?.toString() ?? '';
    leaderName = args['leaderName']?.toString() ?? '';
    leaderMobNo = args['leaderMobNo']?.toString() ?? '';
    isRefer = args['isRefer']?.toString() ?? '';
    doctorHomeServiceId = args['doctor_home_service_id']?.toString() ?? '';
    doctorId = args['doctorId']?.toString() ?? '';
    isAdmitted = args['isAdmitted']?.toString() ?? '';
    videoUrl = args['videoUrl']?.toString() ?? '';
    clinicalFormStatus = args['clinical_form_status']?.toString() ?? '';
    medicalFormStatus = args['medical_form_status']?.toString() ?? '';
    instituteId = args['instituteId']?.toString() ?? '';
    qrCode = args['qrCode']?.toString() ?? '';
    fromPatient = args['fromPatient'] as bool? ?? false;
    isFrom = args['isFrom']?.toString() ?? '';

    _loadUserType().then((_) {
      fetchPatientDetails();
    });
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString(AppConstants.prefLoginType) ?? 'Doctor';
  }

  Future<void> fetchPatientDetails() async {
    if (patientId.isEmpty || bookingId.isEmpty) return;
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.patientDetails,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          final ratingVal = response.data['data']?['rating']?.toString() ?? '0';
          patientRating.value = ratingVal;
        }
      }
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void changeTab(String tab) {
    currentTab.value = tab;
    if (tab == 'Graph' && bpGraphList.isEmpty && sugarGraphList.isEmpty && otherGraphList.isEmpty) {
      fetchGraphData();
    } else if (tab == 'Prescription' && prescriptionList.isEmpty) {
      fetchDoctorPrescription(prescriptionType.value);
    } else if (tab == 'DI') {
      fetchDiagnosisData();
      fetchEcgReport();
    }
  }

  Future<void> fetchDoctorPrescription(String type) async {
    if (patientId.isEmpty) return;
    prescriptionType.value = type;
    isLoadingPrescriptions.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.prescriptionList,
        data: {
          'patient_id': patientId,
          'type': type,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          prescriptionList.value = response.data['data'] as List<dynamic>? ?? [];
          lastAppointmentId.value = response.data['last_appointment_id']?.toString() ?? '';
        } else {
          prescriptionList.clear();
        }
      }
    } catch (e) {
      debugPrint('Error fetching prescriptions: $e');
      prescriptionList.clear();
    } finally {
      isLoadingPrescriptions.value = false;
    }
  }

  Future<Map<String, dynamic>?> fetchMedicineDetails(String id) async {
    isLoadingMedicines.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getMedicines,
        data: {
          'appointment_id': id,
          'type': '',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error fetching medicine details: $e');
    } finally {
      isLoadingMedicines.value = false;
    }
    return null;
  }

  Future<void> sharePrescriptionPdf(String createdDate, Map<String, dynamic> data) async {
    try {
      isLoadingDetails.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      // Format summary text
      final medicinesList = data['data'] as List<dynamic>? ?? [];
      String shareText = 'Prescription Date: $createdDate\nPatient: $fullName ($mhcId)\n';
      if (medicinesList.isNotEmpty) {
        shareText += '\nMedicines:';
        for (final med in medicinesList) {
          final subMeds = med['medicines'] as List<dynamic>? ?? [];
          final medNames = subMeds.map((m) => m['medicine_name']?.toString() ?? '').where((n) => n.isNotEmpty).join(', ');
          final freq = med['frequency']?.toString() ?? '';
          final days = med['days']?.toString() ?? '';
          shareText += '\n- $medNames (Freq: $freq, Days: $days)';
        }
      }

      // Fetch diagnosis if available
      String diagnosisText = '';
      try {
        final diagRes = await apiClient.post(
          ApiEndpoints.getPatientDiagnosis,
          data: {'patient_id': patientId},
          options: dio.Options(headers: {'Authorization': token}),
        );
        if (diagRes.statusCode == 200 && diagRes.data != null) {
          final diagObj = diagRes.data is String ? jsonDecode(diagRes.data) : diagRes.data;
          if (diagObj['status'] == 'success' && diagObj['data'] != null) {
            diagnosisText = diagObj['data']['diagnosis']?.toString() ?? '';
          }
        }
      } catch (_) {}

      final formData = dio.FormData.fromMap({
        'appointment_id': bookingId,
        'patient_id': patientId,
        'diagnosis': diagnosisText,
      });

      final response = await apiClient.post(
        ApiEndpoints.sharePrescription,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic resData = response.data;
        if (resData is String) {
          try {
            resData = jsonDecode(resData);
          } catch (_) {}
        }

        final Map<String, dynamic> resMap = resData is Map<String, dynamic>
            ? resData
            : (resData is Map ? Map<String, dynamic>.from(resData) : {});

        final status = resMap['status']?.toString() ?? '';
        if (status == 'success') {
          final message = resMap['message']?.toString() ?? '';
          final httpIndex = message.indexOf('http');
          if (httpIndex != -1) {
            final pdfUrl = message.substring(httpIndex).trim();
            await _downloadAndSharePdfFile(pdfUrl, shareText);
          } else {
            AppSnackbars.showError('Prescription', 'PDF link not found.');
          }
        } else {
          AppSnackbars.showError('Prescription', resMap['msg']?.toString() ?? resMap['message']?.toString() ?? 'Failed to share prescription.');
        }
      } else {
        AppSnackbars.showError('Prescription', 'Failed to generate prescription PDF.');
      }
    } catch (e) {
      debugPrint('Error sharing prescription PDF: $e');
      AppSnackbars.showError('Prescription', 'Failed to share prescription.');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> _downloadAndSharePdfFile(String pdfUrl, String shareText) async {
    try {
      final dioClient = dio.Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = 'prescription_${bookingId.isNotEmpty ? bookingId : 'file'}.pdf';
      final filePath = '${tempDir.path}/$fileName';

      await dioClient.download(pdfUrl, filePath);

      final xFile = XFile(filePath);
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: shareText,
          subject: 'Prescription PDF - $fullName',
        ),
      );
    } catch (e) {
      debugPrint('Error downloading or sharing PDF file: $e');
      final uri = Uri.parse(pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbars.showError('Prescription', 'Failed to share PDF file.');
      }
    }
  }



  Future<void> fetchGraphData() async {
    if (patientId.isEmpty) return;
    isLoadingGraph.value = true;
    try {
      await Future.wait([
        fetchBPGraph(),
        fetchSugarGraph(),
        fetchOtherGraph(),
      ]);
    } finally {
      isLoadingGraph.value = false;
    }
  }

  Future<void> fetchBPGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.bpGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = BPGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          bpGraphList.value = res.data ?? [];
          targetBp.value = res.targetBp;
        }
      }
    } catch (e) {
      debugPrint('Error fetching BP graph: $e');
    }
  }

  Future<void> fetchSugarGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.sugarGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = SugarGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          sugarGraphList.value = res.data ?? [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching Sugar graph: $e');
    }
  }

  Future<void> fetchOtherGraph() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.otherGraph,
        data: {'patient_id': patientId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final res = OtherGraphResponse.fromJson(response.data);
        if (res.status == 'success') {
          otherGraphList.value = res.data ?? [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching Other graph: $e');
    }
  }

  Future<void> addRating(String ratingValue) async {
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.addRating,
        data: {
          'patient_id': patientId,
          'rating': ratingValue,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          patientRating.value = ratingValue;
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Rating added successfully.',
            backgroundColor: AppColors.success,
          );
          _showFinishAppointmentDialog();
        } else {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Failed to add rating.',
            backgroundColor: AppColors.error,
          );
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error adding rating: $e', backgroundColor: AppColors.error);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void _showFinishAppointmentDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Finish'),
        content: const Text('Do you want to Finish this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.medicalGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              changeAppointmentStatus('', '1');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
            child: const Text('Yes', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> changeAppointmentStatus(String reason, String statusValue) async {
    isLoadingDetails.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.updateAppointmentStatus,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
          'status': statusValue,
          'hold_reason': reason,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success') {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Appointment status updated.',
            backgroundColor: AppColors.success,
          );
          Get.offAllNamed('/patient-list');
        } else {
          Get.rawSnackbar(
            message: response.data['msg']?.toString() ?? 'Failed to update appointment status.',
            backgroundColor: AppColors.error,
          );
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error updating status: $e', backgroundColor: AppColors.error);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // ==========================================
  // Doctor Interpretation (DI) API Operations
  // ==========================================

  Future<void> fetchDiagnosisData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getPatientDiagnosis,
        data: {'patient_id': patientId, 'appointment_id': bookingId},
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success' && response.data['data'] != null) {
          diagnosisText.value = response.data['data']['diagnosis']?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching diagnosis: $e');
    }
  }

  Future<void> fetchEcgReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getReport,
        data: {
          'patient_id': patientId,
          'report_name': 'ECG',
          'user_type': userType.value,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'success' && response.data['data'] != null && (response.data['data'] as List).isNotEmpty) {
          final lastReport = (response.data['data'] as List).last;
          ecgReportImageUrl.value = lastReport['report_img']?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching ECG report: $e');
    }
  }

  Future<void> submitPatientNote() async {
    final noteText = patientNoteController.text.trim();
    if (noteText.isEmpty) {
      AppSnackbars.showError('Error', 'Please enter patient note');
      return;
    }

    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddPatientNoteReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        patientNote: noteText,
      );

      final response = await apiClient.post(
        ApiEndpoints.addPatientNotes,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'Note added successfully';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
          patientNoteController.clear();
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to add note: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  Future<void> submitSelfNote() async {
    final noteText = selfNoteController.text.trim();
    if (noteText.isEmpty) {
      AppSnackbars.showError('Error', 'Please enter self note');
      return;
    }

    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddSelfNoteReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        selfNote: noteText,
      );

      final response = await apiClient.post(
        ApiEndpoints.addSelfNotes,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'Self note added successfully';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
          selfNoteController.clear();
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to add self note: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  Future<void> submitEvent() async {
    String eventDetailsStr = '';

    if (eventType.value == 'None') {
      eventDetailsStr = 'None';
    } else if (eventType.value == 'Hospitalisation') {
      final detailsList = <String>[];
      if (cbMI.value) detailsList.add('MI');
      if (cbCOA.value) detailsList.add('COA');
      if (cbStroke.value) detailsList.add('Stroke');
      if (cbRatinol.value) detailsList.add('Ratinol');
      if (cbHypoglycemia.value) detailsList.add('Hypoglycemia');
      if (cbHypotension.value) detailsList.add('Hypotension');
      if (cbDKA.value) detailsList.add('DKA');
      if (cbRegurgitation.value) detailsList.add('Acc. HTN');
      if (cbPIH.value) detailsList.add('PIH');
      if (cbICH.value) detailsList.add('ICH');
      if (cbAkI.value) detailsList.add('AkI');
      if (cbHospitalizationOther.value && hospitalizationOtherController.text.trim().isNotEmpty) {
        detailsList.add(hospitalizationOtherController.text.trim());
      }
      eventDetailsStr = detailsList.join(', ');
    } else if (eventType.value == 'Non-Hospitalisation') {
      final detailsList = <String>[];
      if (cbPostural.value) detailsList.add('Postural Hypotension');
      if (cbSVT.value) detailsList.add('SVT');
      if (cbBleeding.value) detailsList.add('Bleeding');
      if (cbNonHospOther.value && nonHospOtherController.text.trim().isNotEmpty) {
        detailsList.add(nonHospOtherController.text.trim());
      }
      eventDetailsStr = detailsList.join(', ');
    } else if (eventType.value == 'Death') {
      eventDetailsStr = deathType.value;
    }

    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddEventReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        event: eventType.value,
        eventDetails: eventDetailsStr,
        medicines: medicinesEffect.value,
        investigations: askedInvestigations.value,
        saltReduction: saltReduction.value,
        exercise: exercise.value,
      );

      final response = await apiClient.post(
        ApiEndpoints.addEvent,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'Event added successfully';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to add event: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  Future<void> submitEcg() async {
    final finalImpression = ecgImpression.value == 'Other'
        ? otherInterpretationController.text.trim()
        : ecgImpression.value;

    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddEcgReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        ecgRhythm: ecgRhythm.value,
        sv2Rv5: sv2Rv5Controller.text.trim(),
        stSegment: stSegment.value,
        stSegmentLevel: stSegment.value == 'Normal' ? '' : stSegmentLevel.value,
        ecgImpression: finalImpression,
      );

      final response = await apiClient.post(
        ApiEndpoints.addEcg,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'ECG assessment saved';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to add ECG: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  Future<void> submitTargetBp() async {
    final systolic = systolicController.text.trim();
    final diastolic = diastolicController.text.trim();

    if (systolic.isEmpty || diastolic.isEmpty) {
      AppSnackbars.showError('Error', 'Please enter both Systolic and Diastolic values');
      return;
    }

    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddBpReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        systolic: systolic,
        diastolic: diastolic,
      );

      final response = await apiClient.post(
        ApiEndpoints.addBp,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'Target BP saved';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to save Target BP: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  Future<void> submitTmt() async {
    isLoadingDi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final req = AddTmtReq(
        appointmentId: bookingId,
        doctorId: doctorId,
        patientId: patientId,
        tmtDetails: tmtResult.value,
        mets: metsController.text.trim(),
        metOthers: metOtherController.text.trim(),
      );

      final response = await apiClient.post(
        ApiEndpoints.addTmt,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final msg = response.data['msg']?.toString() ?? 'TMT saved successfully';
        if (response.data['status'] == 'success') {
          AppSnackbars.showSuccess('Success', msg);
        } else {
          AppSnackbars.showError('Error', msg);
        }
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to save TMT: $e');
    } finally {
      isLoadingDi.value = false;
    }
  }

  // ==========================================
  // Doctor Interpretation Dialog Operations
  // ==========================================

  Future<void> fetchNoteTemplates() async {
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getTemplates,
        data: {
          'doctor_id': doctorId,
          'type': 'Notes',
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final dataList = response.data['data'] as List<dynamic>? ?? [];
        _showTemplateListDialog('Notes', dataList);
      } else {
        AppSnackbars.showError('Templates', 'No templates found');
      }
    } catch (e) {
      debugPrint('Error fetching templates: $e');
      AppSnackbars.showError('Templates', 'Failed to fetch templates');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showTemplateListDialog(String title, List<dynamic> templates) {
    if (templates.isEmpty) {
      AppSnackbars.showInfo('Templates', 'No templates available');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = templates[index];
            final noteText = item['notes']?.toString() ?? item['patient_note']?.toString() ?? item['template']?.toString() ?? '';
            final displayText = '${index + 1}. $noteText';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(displayText, style: const TextStyle(fontSize: 14, color: AppColors.navy)),
              onTap: () {
                Get.back();
                final currentText = patientNoteController.text.trim();
                if (currentText.isNotEmpty) {
                  if (!currentText.split(', ').contains(noteText)) {
                    patientNoteController.text = '$currentText, $noteText';
                  }
                } else {
                  patientNoteController.text = noteText;
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> showRecentNotesDialog() async {
    if (patientId.isEmpty) return;
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final formData = dio.FormData.fromMap({
        'patient_id': patientId,
      });

      final response = await apiClient.post(
        ApiEndpoints.getPatientNotes,
        data: formData,
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final notesList = response.data['data'] as List<dynamic>? ?? [];
        _showRecentNotesListDialog('Recent Notes', notesList);
      } else {
        AppSnackbars.showInfo('Recent Notes', 'No recent notes found');
      }
    } catch (e) {
      debugPrint('Error fetching recent notes: $e');
      AppSnackbars.showError('Recent Notes', 'Failed to fetch recent notes');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showRecentNotesListDialog(String title, List<dynamic> notes) {
    if (notes.isEmpty) {
      AppSnackbars.showInfo('Recent Notes', 'No notes found');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1),
          itemBuilder: (context, index) {
            final item = notes[index];
            final visitNo = item['visit_no']?.toString() ?? '';
            final noteDetails = item['note_details'] as List<dynamic>?;

            if (noteDetails != null && noteDetails.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (visitNo.isNotEmpty) ...[
                    Text(
                      'Visit No : $visitNo',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ...noteDetails.map((subNote) {
                    final noteText = subNote['patient_note']?.toString() ?? subNote['notes']?.toString() ?? '';
                    final dateText = subNote['created']?.toString() ?? '';
                    return InkWell(
                      onTap: () {
                        Get.back();
                        patientNoteController.text = noteText;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dateText.isNotEmpty)
                              Text(dateText, style: const TextStyle(fontSize: 12, color: AppColors.coolGray)),
                            const SizedBox(height: 2),
                            Text(noteText, style: const TextStyle(fontSize: 14, color: AppColors.navy)),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            } else {
              final noteText = item['patient_note']?.toString() ?? item['notes']?.toString() ?? '';
              final dateText = item['created']?.toString() ?? '';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(noteText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                subtitle: dateText.isNotEmpty ? Text(dateText, style: const TextStyle(fontSize: 12, color: AppColors.coolGray)) : null,
                onTap: () {
                  Get.back();
                  patientNoteController.text = noteText;
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> showSelfNotesDialog() async {
    if (patientId.isEmpty) return;
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getSelfNotes,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final notesList = response.data['data'] as List<dynamic>? ?? [];
        _showSelfNotesListDialog('Self Notes', notesList);
      } else {
        AppSnackbars.showInfo('Self Notes', 'No self notes found');
      }
    } catch (e) {
      debugPrint('Error fetching self notes: $e');
      AppSnackbars.showError('Self Notes', 'Failed to fetch self notes');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showSelfNotesListDialog(String title, List<dynamic> notes) {
    if (notes.isEmpty) {
      AppSnackbars.showInfo('Self Notes', 'No self notes found');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = notes[index];
            final noteText = item['myself_note']?.toString() ?? item['self_note']?.toString() ?? item['notes']?.toString() ?? '';
            final dateText = item['created']?.toString() ?? '';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(noteText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
              subtitle: dateText.isNotEmpty ? Text(dateText, style: const TextStyle(fontSize: 12, color: AppColors.coolGray)) : null,
              onTap: () {
                Get.back();
                selfNoteController.text = noteText;
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> showEventsDetailDialog() async {
    if (patientId.isEmpty) return;
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getEventDetails,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final eventsList = response.data['data'] as List<dynamic>? ?? [];
        _showEventsListDialog('Event Detail', eventsList);
      } else {
        AppSnackbars.showInfo('Event Detail', 'No event details found');
      }
    } catch (e) {
      debugPrint('Error fetching event details: $e');
      AppSnackbars.showError('Event Detail', 'Failed to fetch event details');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showEventsListDialog(String title, List<dynamic> events) {
    if (events.isEmpty) {
      AppSnackbars.showInfo('Event Detail', 'No event details found');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1),
          itemBuilder: (context, index) {
            final item = events[index];
            final created = item['created']?.toString() ?? '';
            final eventStr = item['event']?.toString() ?? '';
            final eventDetailsStr = item['event_details']?.toString() ?? '';
            final medicinesStr = item['medicines']?.toString() ?? '';
            final investigationsStr = item['investigations']?.toString() ?? '';
            final saltReductionStr = item['salt_reduction']?.toString() ?? '';
            final exerciseStr = item['exercise']?.toString() ?? '';

            final hasCompliance = medicinesStr.isNotEmpty ||
                investigationsStr.isNotEmpty ||
                saltReductionStr.isNotEmpty ||
                exerciseStr.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (created.isNotEmpty) ...[
                  Text(
                    created,
                    style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  'Events: ${eventStr.isNotEmpty ? eventStr : '-'}',
                  style: const TextStyle(fontSize: 14, color: AppColors.navy),
                ),
                const SizedBox(height: 6),
                Text(
                  'Event Detail: ${eventDetailsStr.isNotEmpty ? eventDetailsStr : '-'}',
                  style: const TextStyle(fontSize: 14, color: AppColors.navy),
                ),
                if (hasCompliance) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Compliance to',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.navy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Medicines: ${medicinesStr.isNotEmpty ? medicinesStr : '-'}',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Investigations: ${investigationsStr.isNotEmpty ? investigationsStr : '-'}',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Salt Reduction: ${saltReductionStr.isNotEmpty ? saltReductionStr : '-'}',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Exercise: ${exerciseStr.isNotEmpty ? exerciseStr : '-'}',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                ],
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showEcgDialog() async {
    if (patientId.isEmpty) return;
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getEcg,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final ecgList = response.data['data'] as List<dynamic>? ?? [];
        _showEcgListDialog('ECG', ecgList);
      } else {
        AppSnackbars.showInfo('ECG', 'No ECG records found');
      }
    } catch (e) {
      debugPrint('Error fetching ECG list: $e');
      AppSnackbars.showError('ECG', 'Failed to fetch ECG records');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showEcgListDialog(String title, List<dynamic> list) {
    if (list.isEmpty) {
      AppSnackbars.showInfo('ECG', 'No ECG records found');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1),
          itemBuilder: (context, index) {
            final item = list[index];
            final created = item['created']?.toString() ?? '';
            final rhythm = item['ecg_rhythm']?.toString() ?? '';
            final stSeg = item['st_segment']?.toString() ?? '';
            final stLevel = item['st_segment_level']?.toString() ?? '';
            final sv2Rv5 = item['sv2_rv5']?.toString() ?? '';
            final impression = item['ecg_impression']?.toString() ?? '';

            final stText = stLevel.isNotEmpty ? '$stSeg , $stLevel' : stSeg;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (created.isNotEmpty) ...[
                  Text(
                    created,
                    style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                  ),
                  const SizedBox(height: 6),
                ],
                if (rhythm.isNotEmpty) ...[
                  Text(
                    'Rhythm : $rhythm',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                ],
                if (stSeg.isNotEmpty) ...[
                  Text(
                    'ST Segment : $stText',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                ],
                if (sv2Rv5.isNotEmpty) ...[
                  Text(
                    'SV2+RV5 : $sv2Rv5',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                ],
                if (impression.isNotEmpty) ...[
                  Text(
                    'ECG Expression : $impression',
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showBpDialog() async {
    if (patientId.isEmpty) return;
    try {
      isLoadingDi.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.getBp,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bpList = response.data['data'] as List<dynamic>? ?? [];
        _showBpListDialog('BP', bpList);
      } else {
        AppSnackbars.showInfo('BP', 'No Target BP records found');
      }
    } catch (e) {
      debugPrint('Error fetching BP list: $e');
      AppSnackbars.showError('BP', 'Failed to fetch Target BP records');
    } finally {
      isLoadingDi.value = false;
    }
  }

  void _showBpListDialog(String title, List<dynamic> list) {
    if (list.isEmpty) {
      AppSnackbars.showInfo('BP', 'No Target BP records found');
      return;
    }

    AppDialog.show(
      title: title,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1),
          itemBuilder: (context, index) {
            final item = list[index];
            final created = item['created']?.toString() ?? '';
            final systolic = item['bp_systolic']?.toString() ?? item['systolic']?.toString() ?? '';
            final diastolic = item['bp_diastolic']?.toString() ?? item['diastolic']?.toString() ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (created.isNotEmpty) ...[
                  Text(
                    created,
                    style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  'Target BP : $systolic / $diastolic',
                  style: const TextStyle(fontSize: 14, color: AppColors.navy),
                ),
                const SizedBox(height: 4),
              ],
            );
          },
        ),
      ),
    );
  }
}
