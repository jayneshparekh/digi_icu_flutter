import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/api_endpoints.dart';
import '../services/api/api_client.dart';
import '../views/widgets/app_snackbars.dart';

class MedicineRowData {
  final TextEditingController nameController;
  final TextEditingController doseController;
  final TextEditingController daysController;
  String doseUnit;
  String frequency;
  String category;
  String group;

  MedicineRowData({
    TextEditingController? nameController,
    TextEditingController? doseController,
    TextEditingController? daysController,
    this.doseUnit = 'Mg',
    this.frequency = '1-0-1',
    this.category = '',
    this.group = '',
  })  : nameController = nameController ?? TextEditingController(),
        doseController = doseController ?? TextEditingController(),
        daysController = daysController ?? TextEditingController();

  void dispose() {
    nameController.dispose();
    doseController.dispose();
    daysController.dispose();
  }
}

class AddPrescriptionController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Route arguments
  String patientId = '';
  String bookingId = '';
  String patientName = '';
  String lastAppointmentId = '';
  bool isServed = false;
  String admitId = '0';
  String openFrom = '';

  // Options & Toggles
  var isBranded = false.obs;
  var isAutoRxOn = true.obs;
  var isUploadPrescriptionOn = false.obs;
  var showDefaults = false.obs;
  var activeTab = 'Add Rx'.obs; // 'Add Rx', 'TLS', 'Writepad'

  // Diagnosis & Personalised TT
  var diagnosisText = ''.obs;
  var isLoadingDiagnosis = false.obs;
  var personalisedTTData = <String, String>{}.obs;
  var isLoadingPersonalisedTT = false.obs;

  // Speech Input / TLS controller
  final TextEditingController tlsController = TextEditingController();

  // Dynamic Medicine Rows
  var medicineRows = <MedicineRowData>[].obs;

  // Ongoing Medicines Section
  var ongoingMedicines = <Map<String, dynamic>>[].obs;
  var ongoingImageUrls = <String>[].obs;
  var ongoingPresMsg = ''.obs;
  var ongoingTls = ''.obs;
  var isExistingPrescription = false.obs;
  var isLoadingOngoingMedicines = false.obs;

  // Selected Images (up to 3)
  var imageFiles = <File>[].obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      patientId = args['patientId']?.toString() ?? '';
      bookingId = args['bookingId']?.toString() ?? '';
      patientName = args['patientName']?.toString() ?? '';
      lastAppointmentId = args['lastAppointmentId']?.toString() ?? '';
      isServed = args['isServed'] == true;
      admitId = args['admitId']?.toString() ?? '0';
      openFrom = args['openFrom']?.toString() ?? '';
    }
    
    // Add default initial medicine row
    addMedicineRow();
    fetchDiagnosis();
    fetchOngoingMedicines();
  }

  Future<void> fetchOngoingMedicines() async {
    if (bookingId.isEmpty && lastAppointmentId.isEmpty) return;
    isLoadingOngoingMedicines.value = true;
    try {
      // First try bookingId
      bool success = await _loadOngoingMedicinesForId(bookingId);
      
      // Fallback to lastAppointmentId if bookingId failed or returned empty
      if (!success && lastAppointmentId.isNotEmpty && lastAppointmentId != bookingId) {
        await _loadOngoingMedicinesForId(lastAppointmentId);
      }
    } catch (_) {
    } finally {
      isLoadingOngoingMedicines.value = false;
    }
  }

  Future<bool> _loadOngoingMedicinesForId(String id) async {
    if (id.isEmpty) return false;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.getMedicines,
        data: {
          'appointment_id': id,
          'type': openFrom,
        },
      );
      
      if (response.data != null && response.data['status'] == 'success') {
        final resMap = response.data as Map<String, dynamic>;
        isExistingPrescription.value = true;

        // Extract prescribed_images if available
        final imagesObj = resMap['prescribed_images'] as Map<String, dynamic>?;
        final imgList = <String>[];
        if (imagesObj != null) {
          if (imagesObj['pres_image_1'] != null && imagesObj['pres_image_1'].toString().isNotEmpty) {
            imgList.add(imagesObj['pres_image_1'].toString());
          }
          if (imagesObj['pres_image_2'] != null && imagesObj['pres_image_2'].toString().isNotEmpty) {
            imgList.add(imagesObj['pres_image_2'].toString());
          }
          if (imagesObj['pres_image_3'] != null && imagesObj['pres_image_3'].toString().isNotEmpty) {
            imgList.add(imagesObj['pres_image_3'].toString());
          }
        }
        ongoingImageUrls.value = imgList;

        final rawList = resMap['data'] as List<dynamic>? ?? [];
        final parsedList = rawList.map((item) => item as Map<String, dynamic>).toList();

        if (parsedList.isNotEmpty) {
          ongoingPresMsg.value = parsedList[0]['pres_msg']?.toString() ?? '';
          ongoingTls.value = parsedList[0]['tls']?.toString() ?? '';
          ongoingMedicines.value = parsedList;
          return true;
        } else if (imgList.isNotEmpty) {
          ongoingMedicines.clear();
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  void removeOngoingMedicine(int index) {
    if (index >= 0 && index < ongoingMedicines.length) {
      ongoingMedicines.removeAt(index);
      if (ongoingMedicines.isEmpty && ongoingImageUrls.isEmpty) {
        isExistingPrescription.value = false;
      }
    }
  }

  void continueOngoingMedicines() {
    if (ongoingTls.value.isNotEmpty) {
      activeTab.value = 'TLS';
      tlsController.text = ongoingTls.value;
    } else if (ongoingMedicines.isNotEmpty) {
      activeTab.value = 'Add Rx';
      // Populate medicine rows from ongoingMedicines
      medicineRows.clear();
      for (var item in ongoingMedicines) {
        final subMeds = item['medicines'] as List<dynamic>? ?? [];
        final medName = subMeds.map((m) => m['medicine_name']?.toString() ?? '').where((n) => n.isNotEmpty).join(', ');
        final dose = subMeds.map((m) => m['dose']?.toString() ?? '').where((n) => n.isNotEmpty).join(', ');
        final days = item['days']?.toString() ?? '';
        final freq = item['frequency']?.toString() ?? '1-0-1';

        final row = MedicineRowData(
          frequency: freq.isNotEmpty ? freq : '1-0-1',
          category: item['category_name']?.toString() ?? '',
          group: item['group_name']?.toString() ?? '',
        );
        row.nameController.text = medName;
        row.doseController.text = dose;
        row.daysController.text = days;
        medicineRows.add(row);
      }
      if (medicineRows.isEmpty) {
        addMedicineRow();
      }
    }
  }

  Future<void> fetchDiagnosis() async {
    if (patientId.isEmpty) return;
    isLoadingDiagnosis.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.getPatientDiagnosis,
        data: {'patient_id': patientId},
      );
      if (response.data != null && response.data['status'] == 'success') {
        final data = response.data['data'];
        if (data != null && data['short_diagnosis'] != null) {
          diagnosisText.value = data['short_diagnosis'].toString();
        }
      }
    } catch (_) {
    } finally {
      isLoadingDiagnosis.value = false;
    }
  }

  Future<Map<String, String>?> fetchPersonalisedTT() async {
    if (patientId.isEmpty || bookingId.isEmpty) return null;
    isLoadingPersonalisedTT.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.getPersonalisedTT,
        data: {
          'patient_id': patientId,
          'appointment_id': bookingId,
        },
      );
      if (response.data != null && response.data['status'] == 'success') {
        final Map<String, dynamic> rawMap = response.data;
        final Map<String, String> resultMap = {};
        rawMap.forEach((key, val) {
          if (key != 'status' &&
              key != 'msg' &&
              val != null &&
              val.toString().trim().isNotEmpty &&
              val.toString() != 'null') {
            resultMap[key] = val.toString();
          }
        });
        personalisedTTData.value = resultMap;
        return resultMap;
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'Failed to load Personalised TT: $e');
    } finally {
      isLoadingPersonalisedTT.value = false;
    }
    return null;
  }

  void addMedicineRow() {
    if (medicineRows.length < 5) {
      medicineRows.add(MedicineRowData());
    } else {
      AppSnackbars.showWarning('Limit Reached', 'Maximum 5 medicine entries allowed at once.');
    }
  }

  void removeMedicineRow(int index) {
    if (medicineRows.length > 1) {
      final item = medicineRows.removeAt(index);
      item.dispose();
    }
  }

  void toggleBranded(bool val) {
    isBranded.value = val;
  }

  void toggleAutoRx(bool val) {
    isAutoRxOn.value = val;
  }

  void addCapturedImage(File file) {
    if (imageFiles.length < 3) {
      imageFiles.add(file);
    } else {
      AppSnackbars.showWarning('Limit Reached', 'Maximum 3 prescription images allowed.');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < imageFiles.length) {
      imageFiles.removeAt(index);
    }
  }

  Future<void> submitPrescription({Uint8List? canvasBytes}) async {
    if (isSubmitting.value) return;

    // Validate at least some data is present
    bool hasMedicines = medicineRows.any((row) => row.nameController.text.trim().isNotEmpty);
    bool hasTls = tlsController.text.trim().isNotEmpty;
    bool hasImages = imageFiles.isNotEmpty || canvasBytes != null;

    if (!hasMedicines && !hasTls && !hasImages) {
      AppSnackbars.showWarning('Empty Prescription', 'Please add medicines, TLS notes, or an image/drawing before submitting.');
      return;
    }

    isSubmitting.value = true;

    try {
      final Map<String, dynamic> formMap = {
        'patient_id': patientId,
        'appointment_id': bookingId,
        'tls': tlsController.text.trim(),
        'default_medicine_type': isBranded.value ? 'Branded' : 'Generic',
        'prescribed_by': 'Doctor',
      };

      // Add Medicine Arrays
      int validIndex = 0;
      for (var row in medicineRows) {
        if (row.nameController.text.trim().isNotEmpty) {
          formMap['category[$validIndex]'] = row.category;
          formMap['group[$validIndex]'] = row.group;
          formMap['medicine_name[$validIndex]'] = row.nameController.text.trim();
          formMap['dose[$validIndex]'] = '${row.doseController.text.trim()} ${row.doseUnit}';
          formMap['frequency[$validIndex]'] = row.frequency;
          formMap['days[$validIndex]'] = row.daysController.text.trim();
          validIndex++;
        }
      }

      for (int i = 0; i < imageFiles.length; i++) {
        formMap['pres_file_${i + 1}'] = await dio.MultipartFile.fromFile(
          imageFiles[i].path,
          filename: 'pres_image_${i + 1}.jpg',
        );
      }

      // If canvas drawing provided, save to temp file and attach if less than 3
      if (canvasBytes != null && imageFiles.length < 3) {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/canvas_pres_${DateTime.now().millisecondsSinceEpoch}.png');
        await tempFile.writeAsBytes(canvasBytes);
        formMap['pres_file_${imageFiles.length + 1}'] = await dio.MultipartFile.fromFile(
          tempFile.path,
          filename: 'canvas_drawing.png',
        );
      }

      final formData = dio.FormData.fromMap(formMap);
      final response = await _apiClient.post(
        ApiEndpoints.addPatientPrescription,
        data: formData,
      );

      final data = response.data;
      if (data != null && data['status'] == 'success') {
        AppSnackbars.showSuccess('Success', data['msg']?.toString() ?? 'Prescription added successfully.');
        Get.back(result: true);
      } else {
        AppSnackbars.showError('Error', data?['msg']?.toString() ?? 'Failed to submit prescription.');
      }
    } catch (e) {
      AppSnackbars.showError('Error', 'An error occurred while submitting: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    tlsController.dispose();
    for (var row in medicineRows) {
      row.dispose();
    }
    super.onClose();
  }
}
