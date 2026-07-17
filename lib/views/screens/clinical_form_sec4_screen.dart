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
            'Action Required',
            "You cannot go back from this form.",
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
                            : 'Patient Name',
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
                      subtitle: 'Clinical Form Section 4',
                      title: 'About Habits',
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
                                const Text(
                                  'Did you stop smoking?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.smoking.value,
                                   onChanged: (val) {
                                     controller.smoking.value = val ?? '';
                                     if (val == 'No') {
                                       _showHabitSuggestionDialog(
                                         'Suggestion',
                                         'Quitting smoking significantly reduces the risk of heart disease and stroke. Please consider stopping smoking.',
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
                                         Text(option),
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
                                const Text(
                                  'Did you stop alcohol?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.alcohol.value,
                                   onChanged: (val) {
                                     controller.alcohol.value = val ?? '';
                                     if (val == 'No') {
                                       _showHabitSuggestionDialog(
                                         'Suggestion',
                                         'Limiting alcohol helps control high blood pressure and other medical conditions. Please consider stopping alcohol.',
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
                                         Text(option),
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
                                const Text(
                                  '1. Did you reduce salt intake?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                       const Text('Yes'),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       const Text('No'),
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
                                const Text(
                                  '2. Are you going for morning walk daily?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                         Text(option),
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
                                const Text(
                                  '3. Are you in stress?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                       const Text('Yes'),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       const Text('No'),
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
                                const Text(
                                  '4. Did you miss any medication doses in last 5 days?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.missMedicine.value,
                                   onChanged: (val) {
                                     controller.missMedicine.value = val ?? '';
                                     if (val == 'Yes') {
                                       _showHabitSuggestionDialog(
                                         'Medication Suggestion',
                                         'Consistency in taking medicines is critical to your health outcome. Please set reminders or alarms so you never miss a dose.',
                                       );
                                     }
                                   },
                                   child: Row(
                                     children: [
                                       Radio<String>(
                                         value: 'Yes',
                                         activeColor: AppColors.primary,
                                       ),
                                       const Text('Yes'),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       const Text('No'),
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
                    const Text(
                      'Vitals Again',
                      style: TextStyle(
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
                              const Text(
                                '6. Last Hospitalization',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                       const Text('Yes'),
                                       const SizedBox(width: 24),
                                       Radio<String>(
                                         value: 'No',
                                         activeColor: AppColors.primary,
                                       ),
                                       const Text('No'),
                                     ],
                                   ),
                                 ),
                              if (controller.lastHospitalization.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                const Text('Reason for hospitalization', style: TextStyle(fontSize: 13, color: Colors.black54)),
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
                                      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                                      onChanged: (val) => controller.hospitalizationReasonSelected.value = val ?? 'Select',
                                    ),
                                  ),
                                ),
                                if (controller.hospitalizationReasonSelected.value == 'other') ...[
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: controller.hospitalizationReasonCustomController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter other hospitalization reason',
                                      border: OutlineInputBorder(),
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
                                const Text(
                                  'Vitals BP Measurement',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.systolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Systolic',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.diastolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Diastolic',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.heartRate3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Pulse Rate',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                    label: const Text('Measure BP'),
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
                      label: 'Submit',
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
            child: const Text('OK, I WILL DO', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}


