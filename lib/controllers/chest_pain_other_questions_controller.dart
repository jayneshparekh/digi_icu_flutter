import 'dart:io';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/models/request/patients/download_chest_pain_pdf_request.dart';
import 'package:digi_icu_flutter/models/request/patients/update_chest_pain_request.dart';
import 'package:digi_icu_flutter/models/response/patients/chest_pain_response.dart';
import 'package:digi_icu_flutter/models/response/patients/common_pdf_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/services/razorpay_service.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/chest_pain_score_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChestPainOtherQuestionsController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final RazorpayService _razorpayService = RazorpayService();

  String patientId = '';
  String chestPainId = '';
  int initialScore = 0;
  String forWhom = 'Self';
  String pastSurgery = '';
  String familyHTK = '';

  // Reactive State for Follow-up Questions
  final RxBool isLoading = false.obs;
  final RxString acidityPain = ''.obs; // 'Yes' or 'No'
  final RxString chestRegion = ''.obs; // 'Yes' or 'No'
  final RxString sufferedPainPast = ''.obs; // 'Yes' or 'No'
  final RxString heartPain =
      ''.obs; // 'Yes', 'No', or "I didn't go to the doctor"
  final RxString pastSurgeryInput = ''.obs; // 'Yes' or 'No' (for Other)
  final RxString familyHTKInput = ''.obs; // 'Yes' or 'No' (for Other)

  @override
  void onInit() {
    super.onInit();
    _initArgs();
  }

  void _initArgs() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      patientId =
          (args['patient_id'] ?? args['patientId'])?.toString() ?? '';
      chestPainId =
          (args['chest_pain_id'] ?? args['chestPainId'])?.toString() ?? '';
      initialScore = int.tryParse(args['score']?.toString() ?? '0') ?? 0;
      forWhom = args['forWhom']?.toString() ?? 'Self';
      pastSurgery = args['pastSurgery']?.toString() ?? '';
      familyHTK = args['familyHTK']?.toString() ?? '';
    }

    _ensurePatientId();
  }

  Future<void> _ensurePatientId() async {
    if (patientId.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
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
  }

  bool _validate() {
    if (acidityPain.value.isEmpty ||
        chestRegion.value.isEmpty ||
        sufferedPainPast.value.isEmpty) {
      AppSnackbars.showError(
        'validation_error'.tr,
        'please_answer_all_questions'.tr,
      );
      return false;
    }

    if (sufferedPainPast.value == 'Yes' && heartPain.value.isEmpty) {
      AppSnackbars.showError(
        'validation_error'.tr,
        'please_answer_all_questions'.tr,
      );
      return false;
    }

    if (forWhom == 'Other') {
      if (pastSurgeryInput.value.isEmpty || familyHTKInput.value.isEmpty) {
        AppSnackbars.showError(
          'validation_error'.tr,
          'please_answer_all_questions'.tr,
        );
        return false;
      }
    }

    return true;
  }

  Future<void> submitFollowUp() async {
    if (!_validate()) return;

    final surgeryVal = forWhom == 'Other'
        ? pastSurgeryInput.value
        : pastSurgery;
    final familyVal = forWhom == 'Other' ? familyHTKInput.value : familyHTK;

    final req = UpdateChestPainRequest(
      chestPainId: chestPainId,
      score: initialScore.toString(),
      acidityPain: acidityPain.value,
      chestRegion: chestRegion.value,
      sufferedPainPast: sufferedPainPast.value,
      heartPain: sufferedPainPast.value == 'Yes' ? heartPain.value : '',
      pastAttack: surgeryVal,
      familyAttack: familyVal,
    );

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.updateChestPain,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );

      final updateRes = ChestPainResponse.fromJson(response.data);
      if (updateRes.status == 'success') {
        ChestPainScoreDialog.show(
          score: updateRes.score,
          onEmergencyConsultation: handleEmergencyConsultation,
          onSharePdf: sharePdfReport,
          onOk: () => Get.until(
            (route) => route.settings.name == '/patient-dashboard',
          ),
        );
      } else {
        AppSnackbars.showError('error'.tr, updateRes.msg);
      }
    } catch (e) {
      AppSnackbars.showError('error'.tr, 'failed_to_load_data'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void handleEmergencyConsultation() {
    _razorpayService.openPayment(
      amountInPaise: 30000,
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
    if (chestPainId.isEmpty) return;

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';

      final response = await apiClient.post(
        ApiEndpoints.chestPainPdf,
        data: DownloadChestPainPdfRequest(chestPainId: chestPainId).toJson(),
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
