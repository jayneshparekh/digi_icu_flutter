import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_teal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/clinical_form_controller.dart';

class ClinicalFormSec1Screen extends GetView<ClinicalFormController> {
  const ClinicalFormSec1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.snackbar(
            'action_required'.tr,
            'cannot_go_back'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    controller.isFrom == 'Doctor'
                        ? controller.patientName
                        : controller.patientName.isNotEmpty
                            ? controller.patientName
                            : 'patient_name_default'.tr,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              if (controller.doctorName.isNotEmpty)
                Text(
                  controller.doctorName,
                  style: TextStyle(
                    color: AppColors.medicalGray,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec1'.tr,
                      title: 'bp_oxygen_weight'.tr,
                    ),
                    const SizedBox(height: 24),

                    // --- SECTION 2: 1st BP ?* ---
                    _buildSectionHeader('first_bp_question'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_bp.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: !controller.haveBPApparatus.value,
                                    onChanged: (val) => controller.toggleBPApparatus(!(val ?? false)),
                                    activeColor: AppColors.teal,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'no_bp_apparatus'.tr,
                                      style: TextStyle(fontSize: 13, color: AppColors.navy),
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.haveBPApparatus.value) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.systolicController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'systolic_bp'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.diastolicController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'diastolic_bp'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.pulseRateController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'pulse_rate'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    AppTealIconButton(
                                      assetPath: 'assets/icons/svg/ic_power_button.svg',
                                      onTap: () {},
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- SECTION 3: Oxygen Level ---
                    _buildSectionHeader('oxygen_level_question'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/ic_spo2.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioGroup<String>(
                                groupValue: controller.spo2Choice.value,
                                onChanged: (val) => controller.selectSpo2Choice(val ?? ''),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Yes',
                                      activeColor: AppColors.teal,
                                    ),
                                    Text('yes'.tr),
                                    const SizedBox(width: 16),
                                    Radio<String>(
                                      value: 'No',
                                      activeColor: AppColors.teal,
                                    ),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                              if (controller.spo2Choice.value == 'Yes') ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.spo2Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'spo2'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AppTealIconButton(
                                      assetPath: 'assets/icons/svg/ic_power_button.svg',
                                      onTap: () {},
                                      size: 44,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- SECTION 4: Height & Weight ---
                    _buildSectionHeader('height_weight'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_height.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'height_cm'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: controller.weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'weight_kg'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Next Button
                    AppPrimaryButton(
                      label: 'next'.tr,
                      onPressed: () => controller.submit(),
                      backgroundColor: AppColors.success,
                      width: 150,
                      height: 44,
                      borderRadius: 6,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
      ),
    );
  }
}