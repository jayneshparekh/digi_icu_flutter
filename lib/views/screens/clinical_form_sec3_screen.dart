import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/clinical_form_controller.dart';

class ClinicalFormSec3Screen extends GetView<ClinicalFormController> {
  const ClinicalFormSec3Screen({super.key});

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

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFormSectionHeader(
                      subtitle: 'Clinical Form Section 3',
                      title: 'Symptoms',
                    ),
                    const SizedBox(height: 24),

                    // --- QUESTION 1: Feeling compared to last visit ---
                    if (showSpecialityFields) ...[
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
                                  '1. How are you feeling as compared to our last consultation?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                  RadioGroup<String>(
                                    groupValue: controller.improvement.value,
                                    onChanged: (val) => controller.improvement.value = val ?? '',
                                    child: Column(
                                      children: ['Good', 'Better', 'Same', 'More Suffering', 'This is my first consultation']
                                          .map((option) => Row(
                                                children: [
                                                  Radio<String>(
                                                    value: option,
                                                    activeColor: AppColors.primary,
                                                  ),
                                                  Text(option),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- QUESTION 2: Chest Pain ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_chest_pain.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '2. Do you have chest pain?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.chestPain.value,
                                onChanged: (val) => controller.chestPain.value = val ?? '',
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
                              if (controller.chestPain.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                const Text(
                                  'with sweating?',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                                RadioGroup<String>(
                                  groupValue: controller.chestPainSweating.value,
                                  onChanged: (val) => controller.chestPainSweating.value = val ?? '',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- QUESTION 3: Breathing Difficulty ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_breathing.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '3. Do you have difficulty in breathing while walking or at rest?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.breathlessness.value,
                                onChanged: (val) => controller.breathlessness.value = val ?? '',
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
                              if (controller.breathlessness.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                RadioGroup<String>(
                                  groupValue: controller.breathlessWhile.value,
                                  onChanged: (val) => controller.breathlessWhile.value = val ?? '',
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: 'Walking',
                                        activeColor: AppColors.primary,
                                      ),
                                      const Text('Walking'),
                                      const SizedBox(width: 16),
                                      Radio<String>(
                                        value: 'At Rest',
                                        activeColor: AppColors.primary,
                                      ),
                                      const Text('At Rest'),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- QUESTION 4: Palpitations ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_palpitations.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '4. Do you have palpitations?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.palpitations.value,
                                onChanged: (val) => controller.palpitations.value = val ?? '',
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

                    // --- QUESTION 5: Giddiness ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_giddiness.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '5. Do you have giddiness?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.giddiness.value,
                                onChanged: (val) => controller.giddiness.value = val ?? '',
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

                    // --- QUESTION 6: Headache ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_headache.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '6. Do you have headache?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.headache.value,
                                onChanged: (val) => controller.headache.value = val ?? '',
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

                    // --- QUESTION 7: Dizziness on standing up ---
                    if (showSpecialityFields) ...[
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
                                  '7. When you stand up from sitting or sleeping position, do you feel dizziness?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.dizziness.value,
                                   onChanged: (val) => controller.dizziness.value = val ?? '',
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

                    // --- QUESTION 8: Bleeding Episode ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_bleeding_tendencny.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '8. Did you have any bleeding episode?',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                   groupValue: controller.bleedingEpisode.value,
                                   onChanged: (val) => controller.bleedingEpisode.value = val ?? '',
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

                    // --- QUESTION 9: Other Symptoms ---
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
                                '9. Other Symptoms if any?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.otherSymptomsChoice.value,
                                onChanged: (val) => controller.otherSymptomsChoice.value = val ?? '',
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Yes',
                                      activeColor: AppColors.primary,
                                    ),
                                    const Text('Yes'),
                                    const SizedBox(width: 24),
                                    Radio<String>(
                                      value: 'None',
                                      activeColor: AppColors.primary,
                                    ),
                                    const Text('None'),
                                  ],
                                ),
                              ),
                              if (controller.otherSymptomsChoice.value == 'Yes') ...[
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller.otherSymptomsController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter details of other symptoms',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Next Button
                    AppPrimaryButton(
                      label: 'Next',
                      onPressed: () => controller.submitSec3(),
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
}


