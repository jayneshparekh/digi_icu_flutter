import 'dart:io';
import 'package:digi_icu_flutter/controllers/add_prescription_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_drawing_canvas.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPrescriptionScreen extends GetView<AddPrescriptionController> {
  const AddPrescriptionScreen({super.key});

  void _showPersonalisedTTDialog(BuildContext context, Map<String, String> data) {
    AppDialog.show(
      title: 'Personalised TT',
      showCloseButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: data.entries.map((entry) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.medicalGray.withValues(alpha: 0.5)),
            ),
            child: Text(
              entry.value,
              style: const TextStyle(fontSize: 13, color: AppColors.navy, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      controller.addCapturedImage(File(pickedFile.path));
    }
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.teal),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.blue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedicineRow(BuildContext context, MedicineRowData row, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'medicine_number'.trParams({'number': (index + 1).toString()}),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
              ),
              if (controller.medicineRows.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                  onPressed: () => controller.removeMedicineRow(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Speech-To-Text integrated Medicine Name field
          AppSpeechInputWidget(
            controller: row.nameController,
            hintText: 'type_speak_notes_hint'.tr,
            height: 50,
            maxLines: 1,
          ),
          const SizedBox(height: 10),

          // Dosage, Frequency, Duration Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppLabeledTextField(
                  controller: row.doseController,
                  label: 'dose_label'.tr,
                  hint: 'e.g. 500',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: AppLabeledTextField(
                  controller: row.daysController,
                  label: 'days_label'.tr,
                  hint: 'e.g. 5',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AppDrawingCanvasState> canvasKey = GlobalKey<AppDrawingCanvasState>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'add_prescription_title'.tr,
              style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (controller.patientName.isNotEmpty)
              Text(
                controller.patientName,
                style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Buttons: Add Diagnosis, Personalised TT, Defaults
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Get.toNamed('/diagnosis', arguments: {
                        'patientId': controller.patientId,
                        'bookingId': controller.bookingId,
                      });
                      controller.fetchDiagnosis();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('add_diagnosis_btn'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final ttData = await controller.fetchPersonalisedTT();
                      if (ttData != null && context.mounted) {
                        _showPersonalisedTTDialog(context, ttData);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('personalised_tt_btn'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: () => controller.showDefaults.value = !controller.showDefaults.value,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.showDefaults.value ? const Color(0xFFFF5722) : AppColors.teal,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text('defaults_btn'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Selected Diagnosis Text Banner
            Obx(() {
              if (controller.diagnosisText.value.isEmpty) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.medicalGray),
                ),
                child: Text(
                  'diagnosis_banner'.trParams({'diagnosis': controller.diagnosisText.value}),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 12),
                ),
              );
            }),

            // Ongoing Prescriptions Section
            Obx(() {
              if (controller.isLoadingOngoingMedicines.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator(color: AppColors.teal)),
                );
              }

              final hasMedicines = controller.ongoingMedicines.isNotEmpty;
              final hasImages = controller.ongoingImageUrls.isNotEmpty;
              final hasMsg = controller.ongoingPresMsg.value.isNotEmpty;
              final hasData = hasMedicines || hasImages || hasMsg;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.medicalGray),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ongoing_prescriptions'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                        if (!controller.isServed && (hasMedicines || controller.ongoingTls.value.isNotEmpty))
                          ElevatedButton(
                            onPressed: () => controller.continueOngoingMedicines(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: const Size(0, 32),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text('continue_btn'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (!hasData)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'no_data_available'.tr,
                          style: const TextStyle(color: AppColors.coolGray, fontSize: 12),
                        ),
                      ),

                    // Prescription Message Banner (if present)
                    if (hasMsg) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFFD54F)),
                        ),
                        child: Text(
                          controller.ongoingPresMsg.value,
                          style: const TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],

                    // Ongoing Prescribed Images Carousel/Thumbnails (if present)
                    if (hasImages) ...[
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.ongoingImageUrls.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final url = controller.ongoingImageUrls[index];
                            return GestureDetector(
                              onTap: () => FullScreenImageViewer.show(context, url),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.medicalGray),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(child: Icon(Icons.broken_image, color: AppColors.coolGray)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Ongoing Medicine Rows List
                    if (hasMedicines)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.ongoingMedicines.length,
                        separatorBuilder: (context, index) => const Divider(height: 12, color: AppColors.lightGray),
                        itemBuilder: (context, index) {
                          final item = controller.ongoingMedicines[index];
                          final subMeds = item['medicines'] as List<dynamic>? ?? [];
                          final medNames = subMeds.map((m) => m['medicine_name']?.toString() ?? '').where((n) => n.isNotEmpty).join(', ');
                          final category = item['category_name']?.toString() ?? '';
                          final frequency = item['frequency']?.toString() ?? '';
                          final days = item['days']?.toString() ?? '';
                          final prescribedBy = item['prescribed_by']?.toString() ?? '';

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      medNames.isNotEmpty
                                          ? medNames
                                          : (category.isNotEmpty ? category : 'medicine_item_fallback'.trParams({'number': (index + 1).toString()})),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        if (frequency.isNotEmpty)
                                          Expanded(
                                            child: Text(
                                              '${'dosage_colon'.tr} $frequency',
                                              style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                                            ),
                                          ),
                                        if (days.isNotEmpty)
                                          Text(
                                            '${'duration_colon'.tr} $days Days',
                                            style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                                          ),
                                      ],
                                    ),
                                    if (prescribedBy.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '${'prescribed_by_colon'.tr} $prescribedBy',
                                        style: const TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                onPressed: () => controller.removeOngoingMedicine(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              );
            }),

            // Collapsible Defaults Toggle Bar (Generic vs Branded, Auto RX, Upload Prescription)
            Obx(() {
              if (!controller.showDefaults.value) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.medicalGray.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: controller.isBranded.value,
                              activeThumbColor: AppColors.teal,
                              onChanged: controller.toggleBranded,
                            ),
                            Text(
                              controller.isBranded.value ? 'branded'.tr : 'generic'.tr,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('auto_rx'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                            Switch(
                              value: controller.isAutoRxOn.value,
                              activeThumbColor: AppColors.teal,
                              onChanged: controller.toggleAutoRx,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: AppColors.lightGray),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('upload_prescription_label'.tr, style: const TextStyle(fontSize: 13, color: AppColors.navy, fontWeight: FontWeight.w500)),
                        Switch(
                          value: controller.isUploadPrescriptionOn.value,
                          activeThumbColor: AppColors.teal,
                          onChanged: (val) => controller.isUploadPrescriptionOn.value = val,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 4),

            // Upload / Captured Images Roster Section (Moved above tab buttons, controlled by isUploadPrescriptionOn)
            Obx(() {
              if (!controller.isUploadPrescriptionOn.value) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.medicalGray),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'prescription_images_max3'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showImagePickerModal(context),
                          icon: const Icon(Icons.upload_file, size: 16),
                          label: Text('upload_btn'.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (controller.imageFiles.isEmpty)
                      Text(
                        'no_images_attached'.tr,
                        style: const TextStyle(color: AppColors.coolGray, fontSize: 12),
                      )
                    else
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.imageFiles.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final file = controller.imageFiles[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => controller.removeImage(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: AppColors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),

            // Tab Buttons Roster
            Obx(() {
              final active = controller.activeTab.value;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('add_rx_tab'.tr),
                      selected: active == 'Add Rx',
                      selectedColor: AppColors.teal,
                      labelStyle: TextStyle(color: active == 'Add Rx' ? AppColors.white : AppColors.navy),
                      onSelected: (_) => controller.activeTab.value = 'Add Rx',
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('tls_note_tab'.tr),
                      selected: active == 'TLS',
                      selectedColor: AppColors.teal,
                      labelStyle: TextStyle(color: active == 'TLS' ? AppColors.white : AppColors.navy),
                      onSelected: (_) => controller.activeTab.value = 'TLS',
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('writepad_tab'.tr),
                      selected: active == 'Writepad',
                      selectedColor: AppColors.teal,
                      labelStyle: TextStyle(color: active == 'Writepad' ? AppColors.white : AppColors.navy),
                      onSelected: (_) => controller.activeTab.value = 'Writepad',
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),

            // Tab Content
            Obx(() {
              final active = controller.activeTab.value;

              if (active == 'Writepad') {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.medicalGray),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'writepad_notes_title'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      AppDrawingCanvas(
                        key: canvasKey,
                        height: 320,
                        backgroundColor: AppColors.white,
                      ),
                    ],
                  ),
                );
              }

              if (active == 'TLS') {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.medicalGray),
                  ),
                  child: AppSpeechInputWidget(
                    controller: controller.tlsController,
                    label: 'tls_prescribed_note'.tr,
                    hintText: 'tls_hint'.tr,
                    height: 140,
                  ),
                );
              }

              // Default: 'Add Rx' Form
              return Column(
                children: [
                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.medicineRows.length,
                        itemBuilder: (context, index) => _buildMedicineRow(context, controller.medicineRows[index], index),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: controller.addMedicineRow,
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.teal),
                      label: Text('add_another_medicine'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Submit Button
            Obx(() => AppPrimaryButton(
                  label: 'submit_prescription_btn'.tr,
                  isLoading: controller.isSubmitting.value,
                  onPressed: () async {
                    if (controller.activeTab.value == 'Writepad') {
                      final canvasBytes = await canvasKey.currentState?.exportToPngImage();
                      controller.submitPrescription(canvasBytes: canvasBytes);
                    } else {
                      controller.submitPrescription();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
