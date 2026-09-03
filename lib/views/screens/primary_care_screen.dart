import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'dart:io';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_teal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/primary_care_controller.dart';

class PrimaryCareScreen extends GetView<PrimaryCareController> {
  const PrimaryCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final symptomOptions = [
      'Fever',
      'Chest Pain',
      'Dyspnea',
      'Giddiness',
      'Headache',
      'Abdominal Pain',
      'Vomitting',
      'Bodyache',
      'Loose Motions',
      'Leg Pain',
      'Cough',
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          AppSnackbars.showWarning('action_required'.tr, 'submit_form_to_proceed'.tr);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.teal,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Obx(() {
            final loggedIn = controller.loggedInUserName.value;
            final patient = controller.patientName;
            final subtitle = (loggedIn.isNotEmpty && patient.isNotEmpty)
                ? 'Dr. $loggedIn ($patient)'
                : loggedIn.isNotEmpty ? 'Dr. $loggedIn' : patient;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'primary_care'.tr,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            );
          }),
        ),
        body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Blood Pressure Section ---
                  Text(
                    'blood_pressure'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: !controller.haveBPApparatus.value,
                        onChanged: (val) => controller.toggleBPApparatus(!(val ?? false)),
                        activeColor: AppColors.teal,
                      ),
                      Text(
                        'no_bp_apparatus'.tr,
                        style: TextStyle(fontSize: 14, color: AppColors.navy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (controller.haveBPApparatus.value) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.systolicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'systolic_bp'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: controller.diastolicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'diastolic_bp'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: controller.pulseRateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'pulse_rate'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppTealIconButton(
                          assetPath: 'assets/icons/svg/ic_power_button.svg',
                          onTap: () {},
                          size: 48,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // --- Blood Sugar Section ---
                  Text(
                    'blood_sugar_level'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: !controller.haveGlucometer.value,
                        onChanged: (val) => controller.toggleGlucometer(!(val ?? false)),
                        activeColor: AppColors.teal,
                      ),
                      Expanded(
                        child: Text(
                          'no_glucometer'.tr,
                          style: TextStyle(fontSize: 14, color: AppColors.navy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (controller.haveGlucometer.value) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.fastingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'fasting'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: controller.afterFoodController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'after_food'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: controller.randomController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'random'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppTealIconButton(
                          assetPath: 'assets/icons/svg/ic_power_button.svg',
                          onTap: () {},
                          size: 48,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // --- Stethoscope Recording ---
                  Text(
                    'stethoscope_recording'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text('heart'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text('lungs'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text('baby'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Explain problem in brief Checklist ---
                  Text(
                    'explain_problem_brief'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                    ),
                    itemCount: symptomOptions.length,
                    itemBuilder: (context, index) {
                      final symptom = symptomOptions[index];
                      final isSelected = controller.selectedQuickSymptoms.contains(symptom);
                      return Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (selected) {
                              if (selected == true) {
                                controller.selectedQuickSymptoms.add(symptom);
                              } else {
                                controller.selectedQuickSymptoms.remove(symptom);
                              }
                              controller.toggleSymptom(symptom, selected ?? false);
                            },
                            activeColor: AppColors.teal,
                          ),
                          Expanded(
                            child: Text(
                              symptom.replaceAll(' ', '_').toLowerCase().tr,
                              style: TextStyle(fontSize: 13, color: AppColors.navy),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Language Dropdown & Speech Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: 'English',
                        items: [
                          DropdownMenuItem(
                            value: 'English',
                            child: Text('english'.tr),
                          ),
                        ],
                        onChanged: (val) {},
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.mic, color: AppColors.white, size: 20),
                          onPressed: () {
                            // Speech to text trigger
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Enter Problem Text Field
                  TextField(
                    controller: controller.symptomsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'enter_problem'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Image Upload Section ---
                  Text(
                    'upload_prescription_images'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showImageSourceDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: AppColors.white,
                        ),
                        icon: const Icon(Icons.add_a_photo),
                        label: Text('add_photo'.tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Previews of selected images
                  if (controller.selectedImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.selectedImages.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final img = controller.selectedImages[index];
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.medicalGray),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.file(
                                  File(img.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => controller.removeImage(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.coolGray,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 40),

                  // --- Submit Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => controller.submitForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'submit_primary_care_form'.tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            AppLoadingOverlay(isLoading: controller.isLoading.value),
          ],
        );
      }),
    ),
  );
}

  void _showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_image_source'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.teal),
              title: Text('gallery'.tr),
              onTap: () {
                Get.back();
                controller.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.teal),
              title: Text('camera'.tr),
              onTap: () {
                Get.back();
                controller.captureImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}


