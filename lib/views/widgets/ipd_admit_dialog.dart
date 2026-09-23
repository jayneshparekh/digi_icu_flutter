import 'dart:io';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_drawing_canvas.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpdAdmitDialog extends StatelessWidget {
  final List<dynamic> instituteAmenities;
  final List<dynamic> beds;
  final VoidCallback? onSubmit;

  final GlobalKey<AppDrawingCanvasState> canvasKey =
      GlobalKey<AppDrawingCanvasState>();

  IpdAdmitDialog({
    super.key,
    required this.instituteAmenities,
    this.beds = const [],
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServingPatientController>();
    final ApiClient apiClient = Get.find<ApiClient>();

    final TextEditingController admissionNotesEditingController =
        TextEditingController(text: controller.admissionNotes.value);

    final String instituteName = instituteAmenities.isNotEmpty
        ? instituteAmenities[0]['institute_name']?.toString() ?? ''
        : '';

    // Auto-fill doctor info for Doctor role
    if (controller.userType.value == 'Doctor' &&
        controller.selectedConsultantDoctorId.value.isEmpty) {
      controller.selectedConsultantDoctorId.value = controller.doctorId;
      controller.selectedConsultantDoctorName.value = controller.fullName;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'admit'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.error),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Care Info Header Widget
                    Obx(() {
                      final docText =
                          controller
                              .selectedConsultantDoctorName
                              .value
                              .isNotEmpty
                          ? controller.selectedConsultantDoctorName.value
                          : controller.fullName;
                      final instText =
                          controller.selectedInstituteName.value.isNotEmpty
                          ? controller.selectedInstituteName.value
                          : instituteName;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.medicalGray,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'care_info_text'.tr
                              .replaceAll(
                                '@doctor',
                                docText.isNotEmpty ? docText : 'Doctor',
                              )
                              .replaceAll(
                                '@institute',
                                instText.isNotEmpty ? instText : 'Institute',
                              ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // Consultant Doctor
                    Obx(() {
                      if (controller.userType.value == 'Doctor') {
                        return TextFormField(
                          initialValue: controller.fullName.isNotEmpty
                              ? controller.fullName
                              : 'Doctor',
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'doctor'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        );
                      } else {
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'doctor'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          initialValue:
                              controller
                                      .selectedConsultantDoctorId
                                      .value
                                      .isNotEmpty &&
                                  controller.admitDoctors.any(
                                    (d) =>
                                        d['doctor_id']?.toString() ==
                                        controller
                                            .selectedConsultantDoctorId
                                            .value,
                                  )
                              ? controller.selectedConsultantDoctorId.value
                              : null,
                          hint: Text('please_select_doctor'.tr),
                          items: controller.admitDoctors.map((doc) {
                            return DropdownMenuItem<String>(
                              value: doc['doctor_id']?.toString(),
                              child: Text(doc['doctor_name']?.toString() ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final index = controller.admitDoctors.indexWhere(
                              (d) => d['doctor_id']?.toString() == value,
                            );
                            if (index >= 0) {
                              controller.selectedConsultantDoctorId.value =
                                  controller.admitDoctors[index]['doctor_id']
                                      ?.toString() ??
                                  '';
                              controller.selectedConsultantDoctorName.value =
                                  controller.admitDoctors[index]['doctor_name']
                                      ?.toString() ??
                                  '';
                            }
                          },
                        );
                      }
                    }),
                    const SizedBox(height: 12),

                    // Referral Doctor (conditional)
                    Obx(
                      () => controller.hasReferralDoctor.value
                          ? Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'referral_doctor'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  initialValue:
                                      controller.referralDoctor.value.isNotEmpty
                                      ? controller.referralDoctor.value
                                      : null,
                                  hint: Text('please_select_doctor'.tr),
                                  items: controller.admitDoctors.map((doc) {
                                    return DropdownMenuItem<String>(
                                      value: doc['doctor_id']?.toString(),
                                      child: Text(
                                        doc['doctor_name']?.toString() ?? '',
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      controller.referralDoctor.value =
                                          value ?? '',
                                ),
                                const SizedBox(height: 12),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Approx Cost & Days
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.approxCost.value,
                            decoration: InputDecoration(
                              labelText: 'approx_cost'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.approxCost.value = value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.approxDays.value,
                            decoration: InputDecoration(
                              labelText: 'approx_days'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.approxDays.value = value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Admission Amount & Payment Status
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.admissionAmount.value,
                            decoration: InputDecoration(
                              labelText: 'admission_amount'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.admissionAmount.value = value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'admission_amount_payment_status'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              initialValue:
                                  controller.admissionPaymentStatus.value,
                              items: ['Due', 'Paid']
                                  .map(
                                    (status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.admissionPaymentStatus.value =
                                    value ?? 'Due';
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Admission Payment Mode & Transaction ID
                    Obx(() {
                      if (controller.admissionPaymentStatus.value == 'Paid') {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText:
                                          'admission_amount_payment_mode'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                    ),
                                    initialValue:
                                        controller.admissionPaymentMode.value,
                                    items: ['Cash', 'Online']
                                        .map(
                                          (mode) => DropdownMenuItem<String>(
                                            value: mode,
                                            child: Text(mode),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      controller.admissionPaymentMode.value =
                                          value ?? 'Cash';
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (controller.admissionPaymentMode.value ==
                                'Online') ...[
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue:
                                    controller.admissionTransactionId.value,
                                decoration: InputDecoration(
                                  labelText: 'admission_transaction_id'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (value) =>
                                    controller.admissionTransactionId.value =
                                        value,
                              ),
                            ],
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // Date & Time Pickers
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.admissionDate.value =
                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                              }
                            },
                            child: Obx(
                              () => IgnorePointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'admission_date'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: controller.admissionDate.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                controller.admissionTime.value =
                                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                              }
                            },
                            child: Obx(
                              () => IgnorePointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'admission_time'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: controller.admissionTime.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Discharge Date & Time (optional)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.dischargeDate.value =
                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                              }
                            },
                            child: Obx(
                              () => IgnorePointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'discharge_date'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: controller.dischargeDate.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                controller.dischargeTime.value =
                                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                              }
                            },
                            child: Obx(
                              () => IgnorePointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'discharge_time'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: controller.dischargeTime.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Advance Amount & Payment Status
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: controller.advanceAmount.value,
                            decoration: InputDecoration(
                              labelText: 'advance_amount'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.advanceAmount.value = value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'advance_payment_status'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              initialValue:
                                  controller.advancePaymentStatus.value,
                              items: ['Due', 'Paid']
                                  .map(
                                    (status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.advancePaymentStatus.value =
                                    value ?? 'Due';
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Advance Payment Mode & Transaction ID
                    Obx(() {
                      if (controller.advancePaymentStatus.value == 'Paid') {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'advance_payment_mode'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                    ),
                                    initialValue:
                                        controller.advancePaymentMode.value,
                                    items: ['Cash', 'Online']
                                        .map(
                                          (mode) => DropdownMenuItem<String>(
                                            value: mode,
                                            child: Text(mode),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      controller.advancePaymentMode.value =
                                          value ?? 'Cash';
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (controller.advancePaymentMode.value ==
                                'Online') ...[
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue:
                                    controller.advanceTransactionId.value,
                                decoration: InputDecoration(
                                  labelText: 'advance_transaction_id'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (value) =>
                                    controller.advanceTransactionId.value =
                                        value,
                              ),
                            ],
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // Place / Ward / Bed Selection
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'place'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            initialValue:
                                controller.selectedAdmitPlace.value.isNotEmpty
                                ? controller.selectedAdmitPlace.value
                                : null,
                            hint: Text('please_select'.tr),
                            items: (_getUniquePlaces(instituteAmenities))
                                .map(
                                  (place) => DropdownMenuItem<String>(
                                    value: place,
                                    child: Text(place),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              controller.selectedAdmitPlace.value = value ?? '';
                              controller.selectedAdmitWard.value = '';
                              controller.selectedAdmitBed.value = '';
                              _fetchWardsForPlace(
                                controller,
                                apiClient,
                                value ?? '',
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            final String? wardVal =
                                controller.selectedAdmitWard.value.isNotEmpty &&
                                    controller.admitWardOptions.contains(
                                      controller.selectedAdmitWard.value,
                                    )
                                ? controller.selectedAdmitWard.value
                                : null;
                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'ward'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              initialValue: wardVal,
                              hint: Text('please_select'.tr),
                              items: controller.admitWardOptions
                                  .map(
                                    (ward) => DropdownMenuItem<String>(
                                      value: ward,
                                      child: Text(ward),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedAdmitWard.value =
                                    value ?? '';
                                controller.selectedAdmitBed.value = '';
                                _fetchBedsForWard(
                                  controller,
                                  apiClient,
                                  controller.selectedAdmitPlace.value,
                                  value ?? '',
                                );
                              },
                            );
                          }),
                          const SizedBox(height: 12),
                          Obx(() {
                            final String? bedVal =
                                controller.selectedAdmitBed.value.isNotEmpty &&
                                    controller.admitBedOptions.contains(
                                      controller.selectedAdmitBed.value,
                                    )
                                ? controller.selectedAdmitBed.value
                                : null;
                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'bed'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              initialValue: bedVal,
                              hint: Text('please_select'.tr),
                              items: controller.admitBedOptions
                                  .map(
                                    (bed) => DropdownMenuItem<String>(
                                      value: bed,
                                      child: Text(bed),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  controller.selectedAdmitBed.value =
                                      value ?? '',
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Admission Notes with Speech-to-Text
                    AppSpeechInputWidget(
                      controller: admissionNotesEditingController,
                      label: 'admission_notes'.tr,
                      hintText: 'enter_admission_notes'.tr,
                      maxLines: 4,
                      onChanged: (value) =>
                          controller.admissionNotes.value = value,
                    ),
                    const SizedBox(height: 16),

                    // Drawing Canvas (Doctor Role)
                    Obx(() {
                      if (controller.userType.value == 'Doctor') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'admit_notes_drawing_canvas'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 220,
                              child: AppDrawingCanvas(
                                key: canvasKey,
                                showToolbar: true,
                                initialPenColor: AppColors.pureBlack,
                                backgroundColor: AppColors.white,
                                canvasDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.medicalGray,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSave: (bytes) {
                                  controller.canvasDrawingBytes.value = bytes;
                                  AppSnackbars.showSuccess(
                                    'success'.tr,
                                    'drawing_canvas_saved'.tr,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // Photo Note Attachment (Nurse / Leader Roles)
                    Obx(() {
                      final role = controller.userType.value;
                      final isNurseOrLeader =
                          role == 'Nurse' ||
                          role == 'Digi Icu Nurse' ||
                          role == 'Duty Doctor' ||
                          role == 'Leader' ||
                          role == 'leader';
                      if (isNurseOrLeader) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'admit_notes_image'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (controller.noteImagePath.value.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(controller.noteImagePath.value),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  label: Text(
                                    'remove'.tr,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  onPressed: () =>
                                      controller.noteImagePath.value = '',
                                ),
                              ),
                            ],
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.teal,
                                side: const BorderSide(color: AppColors.teal),
                              ),
                              icon: const Icon(
                                Icons.camera_alt,
                                color: AppColors.teal,
                              ),
                              label: Text('upload_notes_image'.tr),
                              onPressed: () =>
                                  controller.showImagePickerForNotes(),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    const SizedBox(height: 12),

                    // Admit Prescription Action Button (Planted ABOVE Footer Section)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(
                          Icons.description,
                          color: AppColors.white,
                          size: 18,
                        ),
                        label: Text(
                          'admit_prescription'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            '/add-prescription',
                            arguments: {
                              'patient_id': controller.patientId,
                              'bookingId': controller.bookingId,
                              'admitId': '0',
                              'isFromAdmit': true,
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const Divider(),

            // Footer Section: Cancel & Submit Buttons ONLY
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: AppPrimaryButton(
                    label: 'submit'.tr,
                    height: 40,
                    onPressed: () async {
                      // Auto-export drawing canvas if Doctor role and canvas not manually saved
                      if (controller.userType.value == 'Doctor' &&
                          controller.canvasDrawingBytes.value == null) {
                        final bytes = await canvasKey.currentState
                            ?.exportToPngImage();
                        if (bytes != null) {
                          controller.canvasDrawingBytes.value = bytes;
                        }
                      }
                      Get.back();
                      if (onSubmit != null) {
                        onSubmit!();
                      } else {
                        controller.validateAndConfirmAdmit();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getUniquePlaces(List<dynamic> amenities) {
    final Set<String> places = {};
    for (var amenity in amenities) {
      final place = amenity['place']?.toString();
      if (place != null && place.isNotEmpty) {
        places.add(place);
      }
    }
    return places.toList();
  }

  void _fetchWardsForPlace(
    ServingPatientController controller,
    ApiClient apiClient,
    String? place,
  ) async {
    if (place == null || place.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstituteId = controller.selectedInstituteId.value.isNotEmpty
          ? controller.selectedInstituteId.value
          : controller.instituteId;
      final resp = await apiClient.post(
        ApiEndpoints.whereAdmit,
        data: {'institute_id': targetInstituteId, 'place': place},
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final wards = resp.data['data'] ?? [];
        controller.admitWardOptions.value = wards
            .map((w) => w['ward_name']?.toString() ?? '')
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching wards: $e');
    }
  }

  void _fetchBedsForWard(
    ServingPatientController controller,
    ApiClient apiClient,
    String? place,
    String? ward,
  ) async {
    if (place == null || place.isEmpty || ward == null || ward.isEmpty) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstituteId = controller.selectedInstituteId.value.isNotEmpty
          ? controller.selectedInstituteId.value
          : controller.instituteId;
      final resp = await apiClient.post(
        ApiEndpoints.getBeds,
        data: {
          'admit_in': place,
          'institute_id': targetInstituteId,
          'name': ward,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final beds = resp.data['data'] ?? [];
        controller.admitBedOptions.value = beds
            .map((b) => b['bed_no']?.toString() ?? '')
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching beds: $e');
    }
  }
}
