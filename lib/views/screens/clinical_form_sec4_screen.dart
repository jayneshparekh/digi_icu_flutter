import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/clinical_form_controller.dart';

class ClinicalFormSec4Screen extends GetView<ClinicalFormController> {
  const ClinicalFormSec4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.snackbar(
            'action_required'.tr,
            'cannot_go_back_form'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                            : 'patient_name'.tr,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              if (controller.doctorName.isNotEmpty)
                Text(
                  controller.doctorName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        body: Obx(() {
          final showSpecialityFields = controller.speciality.isEmpty;
          final showSmoking = controller.mClinicalFormData.smoking == 'Yes';
          final showAlcohol = controller.mClinicalFormData.alcohol == 'Yes';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec4'.tr,
                      title: 'about_habits'.tr,
                    ),
                    const SizedBox(height: 24),

                    // --- OPTIONAL: Smoking ---
                    if (showSmoking) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'did_you_stop_smoking'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.smoking.value,
                                   onChanged: (val) {
                                     controller.smoking.value = val ?? '';
                                     if (val == 'No') {
                                       _showHabitSuggestionDialog(
                                         'suggestion'.tr,
                                         'quitting_smoking_msg'.tr,
                                       );
                                     }
                                   },
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: ['Yes', 'No', 'I need help'].map((option) => Row(
                                       children: [
                                         Radio<String>(
                                           value: option,
                                           activeColor: AppColors.primary,
                                         ),
                                         Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'i_need_help'.tr),
                                       ],
                                     )).toList(),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- OPTIONAL: Alcohol ---
                    if (showAlcohol) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'did_you_stop_alcohol'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.alcohol.value,
                                   onChanged: (val) {
                                     controller.alcohol.value = val ?? '';
                                     if (val == 'No') {
                                       _showHabitSuggestionDialog(
                                         'suggestion'.tr,
                                         'limiting_alcohol_msg'.tr,
                                       );
                                     }
                                   },
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: ['Yes', 'No', 'I need help'].map((option) => Row(
                                       children: [
                                         Radio<String>(
                                           value: option,
                                           activeColor: AppColors.primary,
                                         ),
                                         Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'i_need_help'.tr),
                                       ],
                                     )).toList(),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- QUESTION 1: Reduce Salt Intake ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_salt_intake.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'reduce_salt_intake'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.reduceSalt.value,
                                   onChanged: (val) => controller.reduceSalt.value = val ?? '',
                                   child: Row(
                                     children: [
                                       Radio<String>(
                                         value: 'Yes',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('yes'.tr),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('no'.tr),
                                     ],
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- QUESTION 2: Morning Walk ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_morning_walk.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'morning_walk_daily'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.exercise.value,
                                   onChanged: (val) => controller.exercise.value = val ?? '',
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: ['Yes', 'No', 'sometimes missing'].map((option) => Row(
                                       children: [
                                         Radio<String>(
                                           value: option,
                                           activeColor: AppColors.primary,
                                         ),
                                         Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'sometimes_missing'.tr),
                                       ],
                                     )).toList(),
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- QUESTION 3: Stress ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_stress.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'are_you_in_stress'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.inStress.value,
                                   onChanged: (val) => controller.inStress.value = val ?? '',
                                   child: Row(
                                     children: [
                                       Radio<String>(
                                         value: 'Yes',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('yes'.tr),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('no'.tr),
                                     ],
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- QUESTION 4: Miss Medication ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_medicines.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'miss_medication_doses'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.missMedicine.value,
                                   onChanged: (val) {
                                     controller.missMedicine.value = val ?? '';
                                     if (val == 'Yes') {
                                       _showHabitSuggestionDialog(
                                         'medication_suggestion'.tr,
                                         'medication_suggestion_msg'.tr,
                                       );
                                     }
                                   },
                                   child: Row(
                                     children: [
                                       Radio<String>(
                                         value: 'Yes',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('yes'.tr),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('no'.tr),
                                     ],
                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- VITALS AGAIN SECTION ---
                    Text(
                      'vitals_again'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 2,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 24),

                    // --- QUESTION 6: Last Hospitalization ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  'last_hospitalization'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                   groupValue: controller.lastHospitalization.value,
                                   onChanged: (val) => controller.lastHospitalization.value = val ?? '',
                                   child: Row(
                                     children: [
                                       Radio<String>(
                                         value: 'Yes',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('yes'.tr),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       Text('no'.tr),
                                     ],
                                   ),
                                 ),
                              if (controller.lastHospitalization.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                Text('reason_for_hospitalization'.tr, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.hospitalizationReasonSelected.value,
                                      isExpanded: true,
                                      items: [
                                        'Select',
                                        'Heart attack',
                                        'Heart failure',
                                        'High blood pressure',
                                        'Stroke',
                                        'Diabetes complications',
                                        'other'
                                      ].map((v) => DropdownMenuItem(value: v, child: Text(v == 'Select' ? 'select'.tr : v == 'Heart attack' ? 'heart_attack'.tr : v == 'Heart failure' ? 'heart_failure'.tr : v == 'High blood pressure' ? 'high_blood_pressure'.tr : v == 'Stroke' ? 'stroke'.tr : v == 'Diabetes complications' ? 'diabetes_complications'.tr : 'other'.tr))).toList(),
                                      onChanged: (val) => controller.hospitalizationReasonSelected.value = val ?? 'Select',
                                    ),
                                  ),
                                ),
                                if (controller.hospitalizationReasonSelected.value == 'other') ...[
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: controller.hospitalizationReasonCustomController,
                                    decoration: InputDecoration(
                                      labelText: 'enter_other_hospitalization_reason'.tr,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- BP MEASUREMENT VITALS AGAIN ---
                    if (controller.haveBPApparatus.value) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_bp.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'vitals_bp_measurement'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.systolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'systolic'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.diastolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'diastolic'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.heartRate3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'pulse_rate'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.bluetooth),
                                    label: Text('measure_bp'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Submit Button
                    AppPrimaryButton(
                      label: 'submit'.tr,
                      onPressed: () => controller.submitSec4(),
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

  void _showHabitSuggestionDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('ok_i_will_do'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}


