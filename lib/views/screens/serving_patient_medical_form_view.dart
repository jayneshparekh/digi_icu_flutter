import 'dart:io';
import 'package:digi_icu_flutter/controllers/serving_patient_medical_form_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_family_member_selector.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Doctor-facing Medical Form View with reactive GetX controls, backend prefilling and update submission.
class ServingPatientMedicalFormView extends StatelessWidget {
  const ServingPatientMedicalFormView({super.key});

  static const List<String> yearsDropdownOptions = [
    'Select',
    'Less than 6 months',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6-10 Years',
    'More than 10 years',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServingPatientMedicalFormController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'medical_form'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= SECTION 1: CLINICAL HISTORY =================
                AppFormSectionHeader(
                  subtitle: '',
                  title: 'clinical_history'.tr,
                ),
                const SizedBox(height: 12),

                // 1. Hypertension
                _buildConditionSection(
                  context: context,
                  title: 'q_hypertension'.tr,
                  iconPath: 'assets/images/m_hypertension.png',
                  hasCondition: controller.hasHypertension,
                  yearsSince: controller.htnYears,
                  onMedicine: controller.htnOnMedicine,
                  medicineRegular: controller.htnMedicineRegular,
                  medCount: controller.htnMedCount,
                  medName1: controller.htnMedName1Ctrl,
                  medName2: controller.htnMedName2Ctrl,
                  medName3: controller.htnMedName3Ctrl,
                  medFreq1: controller.htnMedFreq1,
                  medFreq2: controller.htnMedFreq2,
                  medFreq3: controller.htnMedFreq3,
                  reportsList: controller.htnReports,
                  networkImages: controller.htnNetworkImages,
                  typeKey: 'HTN',
                  controller: controller,
                  allowDontKnow: true,
                ),
                const Divider(height: 24),

                // 2. Diabetes
                _buildConditionSection(
                  context: context,
                  title: 'q_diabetes'.tr,
                  iconPath: 'assets/images/m_diabetes.png',
                  hasCondition: controller.hasDiabetes,
                  yearsSince: controller.diabetesYears,
                  onMedicine: controller.diabetesOnMedicine,
                  medicineRegular: controller.diabetesMedicineRegular,
                  medCount: controller.diabetesMedCount,
                  medName1: controller.diabetesMedName1Ctrl,
                  medName2: controller.diabetesMedName2Ctrl,
                  medName3: controller.diabetesMedName3Ctrl,
                  medFreq1: controller.diabetesMedFreq1,
                  medFreq2: controller.diabetesMedFreq2,
                  medFreq3: controller.diabetesMedFreq3,
                  reportsList: controller.diabetesReports,
                  networkImages: controller.diabetesNetworkImages,
                  typeKey: 'Diabetes',
                  controller: controller,
                  allowDontKnow: true,
                ),
                const Divider(height: 24),

                // 3. Thyroid
                _buildConditionSection(
                  context: context,
                  title: 'q_thyroid'.tr,
                  iconPath: 'assets/images/m_feeling.png',
                  hasCondition: controller.hasThyroid,
                  yearsSince: controller.thyroidYears,
                  onMedicine: controller.thyroidOnMedicine,
                  medicineRegular: controller.thyroidMedicineRegular,
                  medCount: controller.thyroidMedCount,
                  medName1: controller.thyroidMedName1Ctrl,
                  medName2: controller.thyroidMedName2Ctrl,
                  medName3: controller.thyroidMedName3Ctrl,
                  medFreq1: controller.thyroidMedFreq1,
                  medFreq2: controller.thyroidMedFreq2,
                  medFreq3: controller.thyroidMedFreq3,
                  reportsList: controller.thyroidReports,
                  networkImages: controller.thyroidNetworkImages,
                  typeKey: 'Thyroid',
                  controller: controller,
                  allowDontKnow: true,
                ),
                const Divider(height: 24),

                // 4. Cholesterol
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'q_cholesterol'.tr,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => RadioGroup<String>(
                        groupValue: controller.hasCholesterol.value,
                        onChanged: (val) => controller.hasCholesterol.value = val ?? 'No',
                        child: Column(
                          children: ['Yes', 'No', "Don't Know"].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == "Don't Know" ? 'dont_know'.tr : opt.toLowerCase().tr),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 5. Asthma
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'q_asthma'.tr,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => RadioGroup<String>(
                        groupValue: controller.hasAsthma.value,
                        onChanged: (val) => controller.hasAsthma.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 24),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                // 6. Pregnancy details (Female only)
                Obx(() {
                  if (!controller.showPregnancySection) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 24),
                      Text(
                        'q_pregnant'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                      ),
                      const SizedBox(height: 4),
                      RadioGroup<String>(
                        groupValue: controller.isPregnant.value,
                        onChanged: (val) => controller.isPregnant.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No', 'May be'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'May be' ? 'may_be'.tr : opt.toLowerCase().tr),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'pregnancy_details'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                      ),
                      const SizedBox(height: 4),
                      RadioGroup<String>(
                        groupValue: controller.duringPregnancy.value,
                        onChanged: (val) => controller.duringPregnancy.value = val ?? 'None',
                        child: Column(
                          children: ['Hypertension', 'Diabetes', 'Both', 'None'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'Both' ? 'both'.tr : opt == 'None' ? 'none'.tr : opt),
                            ],
                          )).toList(),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 24),

                // ================= SECTION 2: PAST HISTORY =================
                AppFormSectionHeader(
                  subtitle: '',
                  title: 'past_history_title'.tr,
                ),
                const SizedBox(height: 12),

                // 1. Heart Attack
                _buildConditionSection(
                  context: context,
                  title: 'q_heart_attack'.tr,
                  iconPath: '',
                  hasCondition: controller.hasHeartAttack,
                  yearsSince: controller.heartAttackYears,
                  onMedicine: controller.heartAttackOnMedicine,
                  medicineRegular: RxString('Yes'),
                  medCount: controller.heartAttackMedCount,
                  medName1: controller.heartAttackMedName1Ctrl,
                  medName2: controller.heartAttackMedName2Ctrl,
                  medName3: controller.heartAttackMedName3Ctrl,
                  medFreq1: controller.heartAttackMedFreq1,
                  medFreq2: controller.heartAttackMedFreq2,
                  medFreq3: controller.heartAttackMedFreq3,
                  reportsList: controller.heartAttackReports,
                  networkImages: controller.heartAttackNetworkImages,
                  typeKey: 'HeartAttack',
                  controller: controller,
                  hideRegularQuestion: true,
                  allowDontKnow: false,
                  customSubWidgets: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('heart_attack_status_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.heartAttackStatus.value,
                        onChanged: (val) => controller.heartAttackStatus.value = val ?? 'No Records',
                        child: Wrap(
                          children: ['Acute', 'Recent', 'Old', 'No Records'].map((opt) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'No Records' ? 'no_records'.tr : opt.toLowerCase().tr),
                              const SizedBox(width: 12),
                            ],
                          )).toList(),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(height: 24),

                // 2. Stroke
                _buildConditionSection(
                  context: context,
                  title: 'q_stroke'.tr,
                  iconPath: '',
                  hasCondition: controller.hasStroke,
                  yearsSince: controller.strokeYears,
                  onMedicine: controller.strokeOnMedicine,
                  medicineRegular: RxString('Yes'),
                  medCount: controller.strokeMedCount,
                  medName1: controller.strokeMedName1Ctrl,
                  medName2: controller.strokeMedName2Ctrl,
                  medName3: controller.strokeMedName3Ctrl,
                  medFreq1: controller.strokeMedFreq1,
                  medFreq2: controller.strokeMedFreq2,
                  medFreq3: controller.strokeMedFreq3,
                  reportsList: controller.strokeReports,
                  networkImages: controller.strokeNetworkImages,
                  typeKey: 'Stroke',
                  controller: controller,
                  hideRegularQuestion: true,
                  allowDontKnow: false,
                  customSubWidgets: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('stroke_status_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.strokeStatus.value,
                        onChanged: (val) => controller.strokeStatus.value = val ?? 'No Records',
                        child: Wrap(
                          children: ['Acute', 'Recent', 'Old', 'No Records'].map((opt) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'No Records' ? 'no_records'.tr : opt.toLowerCase().tr),
                              const SizedBox(width: 12),
                            ],
                          )).toList(),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(height: 24),

                // 3. Kidney Failure
                _buildConditionSection(
                  context: context,
                  title: 'q_kidney_failure'.tr,
                  iconPath: '',
                  hasCondition: controller.hasKidneyFailure,
                  yearsSince: controller.kidneyFailureYears,
                  onMedicine: controller.kidneyFailureOnMedicine,
                  medicineRegular: RxString('Yes'),
                  medCount: controller.kidneyFailureMedCount,
                  medName1: controller.kidneyFailureMedName1Ctrl,
                  medName2: controller.kidneyFailureMedName2Ctrl,
                  medName3: controller.kidneyFailureMedName3Ctrl,
                  medFreq1: controller.kidneyFailureMedFreq1,
                  medFreq2: controller.kidneyFailureMedFreq2,
                  medFreq3: controller.kidneyFailureMedFreq3,
                  reportsList: controller.kidneyFailureReports,
                  networkImages: controller.kidneyFailureNetworkImages,
                  typeKey: 'KidneyFailure',
                  controller: controller,
                  hideRegularQuestion: true,
                  allowDontKnow: false,
                  customSubWidgets: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('kidney_failure_status_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.kidneyFailureStatus.value,
                        onChanged: (val) => controller.kidneyFailureStatus.value = val ?? 'No Records',
                        child: Wrap(
                          children: ['Acute', 'Chronic', 'No Records'].map((opt) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'Chronic' ? 'chronic'.tr : opt == 'No Records' ? 'no_records'.tr : opt.toLowerCase().tr),
                              const SizedBox(width: 12),
                            ],
                          )).toList(),
                        ),
                      )),
                      const SizedBox(height: 8),
                      Text('on_dialysis_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.kidneyFailureDialysis.value,
                        onChanged: (val) => controller.kidneyFailureDialysis.value = val ?? 'Regular',
                        child: Row(
                          children: ['Regular', 'Sometimes'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == 'Sometimes' ? 'sometimes'.tr : opt.toLowerCase().tr),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(height: 24),

                // 4. Angioplasty
                _buildConditionSection(
                  context: context,
                  title: 'q_angioplasty'.tr,
                  iconPath: '',
                  hasCondition: controller.hasAngioplasty,
                  yearsSince: controller.angioplastyYears,
                  onMedicine: controller.angioplastyOnMedicine,
                  medicineRegular: RxString('Yes'),
                  medCount: controller.angioplastyMedCount,
                  medName1: controller.angioplastyMedName1Ctrl,
                  medName2: controller.angioplastyMedName2Ctrl,
                  medName3: controller.angioplastyMedName3Ctrl,
                  medFreq1: controller.angioplastyMedFreq1,
                  medFreq2: controller.angioplastyMedFreq2,
                  medFreq3: controller.angioplastyMedFreq3,
                  reportsList: controller.angioplastyReports,
                  networkImages: controller.angioplastyNetworkImages,
                  typeKey: 'Angioplasty',
                  controller: controller,
                  hideRegularQuestion: true,
                  allowDontKnow: false,
                  customSubWidgets: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('stents_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.angioplastyStents.value,
                        onChanged: (val) => controller.angioplastyStents.value = val ?? 'I',
                        child: Row(
                          children: ['I', 'II', 'III', 'IV'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      )),
                      const SizedBox(height: 8),
                      Text('brilinta'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.angioplastyBrilinta.value,
                        onChanged: (val) => controller.angioplastyBrilinta.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      )),
                      const SizedBox(height: 8),
                      Text('clopilet'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.angioplastyClopilet.value,
                        onChanged: (val) => controller.angioplastyClopilet.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      )),
                      const SizedBox(height: 8),
                      Text('prasita'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      Obx(() => RadioGroup<String>(
                        groupValue: controller.angioplastyPrasita.value,
                        onChanged: (val) => controller.angioplastyPrasita.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 16),
                            ],
                          )).toList(),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(height: 24),

                // 5. Bypass Surgery
                _buildConditionSection(
                  context: context,
                  title: 'q_bypass'.tr,
                  iconPath: '',
                  hasCondition: controller.hasBypass,
                  yearsSince: controller.bypassYears,
                  onMedicine: controller.bypassOnMedicine,
                  medicineRegular: RxString('Yes'),
                  medCount: controller.bypassMedCount,
                  medName1: controller.bypassMedName1Ctrl,
                  medName2: controller.bypassMedName2Ctrl,
                  medName3: controller.bypassMedName3Ctrl,
                  medFreq1: controller.bypassMedFreq1,
                  medFreq2: controller.bypassMedFreq2,
                  medFreq3: controller.bypassMedFreq3,
                  reportsList: controller.bypassReports,
                  networkImages: controller.bypassNetworkImages,
                  typeKey: 'Bypass',
                  controller: controller,
                  hideRegularQuestion: true,
                  allowDontKnow: false,
                ),
                const Divider(height: 24),

                // 6. Allergy to Medicines
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'q_allergy'.tr,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => RadioGroup<String>(
                        groupValue: controller.hasAllergy.value,
                        onChanged: (val) => controller.hasAllergy.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 24),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.hasAllergy.value != 'Yes') return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Allergic to Cardiac / Diabetic Medicine?', style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          RadioGroup<String>(
                            groupValue: controller.allergicToCardiacDiabetic.value,
                            onChanged: (val) => controller.allergicToCardiacDiabetic.value = val ?? 'No',
                            child: Row(
                              children: ['Yes', 'No'].map((opt) => Row(
                                children: [
                                  AppRadio<String>(value: opt),
                                  Text(opt.toLowerCase().tr),
                                  const SizedBox(width: 16),
                                ],
                              )).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (controller.allergyMedCount.value == 0)
                            Center(
                              child: TextButton.icon(
                                onPressed: () => controller.allergyMedCount.value = 1,
                                icon: const Icon(Icons.add, color: AppColors.teal),
                                label: Text('add_medicine'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          if (controller.allergyMedCount.value >= 1) ...[
                            TextField(
                              controller: controller.allergyMedName1Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_medicine_name'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.allergyMedCount.value >= 2) ...[
                            TextField(
                              controller: controller.allergyMedName2Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_medicine_name_2'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.allergyMedCount.value >= 3) ...[
                            TextField(
                              controller: controller.allergyMedName3Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_medicine_name_3'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.allergyMedCount.value > 0 && controller.allergyMedCount.value < 3)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => controller.allergyMedCount.value++,
                                icon: const Icon(Icons.add, color: AppColors.teal),
                                label: Text('add_more'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
                const Divider(height: 24),

                // 7. Bleeding Tendencies
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'q_bleeding_tendencies'.tr,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => RadioGroup<String>(
                        groupValue: controller.hasBleedingTendency.value,
                        onChanged: (val) => controller.hasBleedingTendency.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 24),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.hasBleedingTendency.value != 'Yes') return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('bleeding_severity_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          RadioGroup<String>(
                            groupValue: controller.bleedingSeverity.value,
                            onChanged: (val) => controller.bleedingSeverity.value = val ?? 'Mild',
                            child: Row(
                              children: ['Mild', 'Moderate', 'Severe'].map((opt) => Row(
                                children: [
                                  AppRadio<String>(value: opt),
                                  Text(opt == 'Mild' ? 'mild'.tr : opt == 'Moderate' ? 'moderate'.tr : 'severe'.tr),
                                  const SizedBox(width: 16),
                                ],
                              )).toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('can_aspirin_continue_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          RadioGroup<String>(
                            groupValue: controller.canAspirinContinue.value,
                            onChanged: (val) => controller.canAspirinContinue.value = val ?? 'No',
                            child: Row(
                              children: ['Yes', 'No'].map((opt) => Row(
                                children: [
                                  AppRadio<String>(value: opt),
                                  Text(opt.toLowerCase().tr),
                                  const SizedBox(width: 16),
                                ],
                              )).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                const Divider(height: 24),

                // 8. Other Surgery / Treatment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'q_other_surgery'.tr,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => RadioGroup<String>(
                        groupValue: controller.hasOtherSurgery.value,
                        onChanged: (val) => controller.hasOtherSurgery.value = val ?? 'No',
                        child: Row(
                          children: ['Yes', 'No'].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt.toLowerCase().tr),
                              const SizedBox(width: 24),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.hasOtherSurgery.value != 'Yes') return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('surgery_category_q'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              _buildCheckboxItem('abdominal'.tr, controller.surgeryAbdominal),
                              _buildCheckboxItem('neuro'.tr, controller.surgeryNeuro),
                              _buildCheckboxItem('Cardiac', controller.surgeryCardiac),
                              _buildCheckboxItem('ortho'.tr, controller.surgeryOrtho),
                              _buildCheckboxItem('gynaec'.tr, controller.surgeryGynaec),
                              _buildCheckboxItem('vascular'.tr, controller.surgeryVascular),
                              _buildCheckboxItem('cancer'.tr, controller.surgeryCancer),
                              _buildCheckboxItem('tumor'.tr, controller.surgeryTumor),
                              _buildCheckboxItem('ent'.tr, controller.surgeryENT),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (controller.surgeryMedCount.value == 0)
                            Center(
                              child: TextButton.icon(
                                onPressed: () => controller.surgeryMedCount.value = 1,
                                icon: const Icon(Icons.add, color: AppColors.teal),
                                label: Text('add_surgery'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          if (controller.surgeryMedCount.value >= 1) ...[
                            TextField(
                              controller: controller.surgeryName1Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_surgery_name'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.surgeryMedCount.value >= 2) ...[
                            TextField(
                              controller: controller.surgeryName2Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_surgery_name_2'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.surgeryMedCount.value >= 3) ...[
                            TextField(
                              controller: controller.surgeryName3Ctrl,
                              decoration: InputDecoration(
                                hintText: 'enter_surgery_name_3'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (controller.surgeryMedCount.value > 0 && controller.surgeryMedCount.value < 3)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => controller.surgeryMedCount.value++,
                                icon: const Icon(Icons.add, color: AppColors.teal),
                                label: Text('add_more'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 28),

                // ================= SECTION 3: FAMILY HISTORY =================
                AppFormSectionHeader(
                  subtitle: '',
                  title: 'sec3_title'.tr,
                ),
                const SizedBox(height: 12),

                // 1. Family Heart Attack
                Text('family_heart_attack_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasFamilyHeartAttack.value,
                      onChanged: (val) => controller.hasFamilyHeartAttack.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasFamilyHeartAttack.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFamilyMemberSelector(
                          fatherSelected: controller.famHeartAttackFather,
                          fatherAgeController: controller.famHeartAttackFatherAgeCtrl,
                          motherSelected: controller.famHeartAttackMother,
                          motherAgeController: controller.famHeartAttackMotherAgeCtrl,
                          brotherSelected: controller.famHeartAttackBrother,
                          brotherAgeController: controller.famHeartAttackBrotherAgeCtrl,
                          sisterSelected: controller.famHeartAttackSister,
                          sisterAgeController: controller.famHeartAttackSisterAgeCtrl,
                          grandparentsSelected: controller.famHeartAttackGrandparents,
                          grandparentsAgeController: controller.famHeartAttackGrandparentsAgeCtrl,
                        ),
                        const SizedBox(height: 8),
                        Text('fh_significance'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        RadioGroup<String>(
                          groupValue: controller.famHeartAttackSignificance.value,
                          onChanged: (val) => controller.famHeartAttackSignificance.value = val ?? 'Significant',
                          child: Row(
                            children: ['Significant', 'Non-Significant'].map((opt) => Row(
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt == 'Significant' ? 'fh_significant'.tr : 'fh_non_significant'.tr),
                                const SizedBox(width: 16),
                              ],
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),

                // 2. Family Stroke
                Text('family_stroke_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasFamilyStroke.value,
                      onChanged: (val) => controller.hasFamilyStroke.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasFamilyStroke.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFamilyMemberSelector(
                          fatherSelected: controller.famStrokeFather,
                          fatherAgeController: controller.famStrokeFatherAgeCtrl,
                          motherSelected: controller.famStrokeMother,
                          motherAgeController: controller.famStrokeMotherAgeCtrl,
                          brotherSelected: controller.famStrokeBrother,
                          brotherAgeController: controller.famStrokeBrotherAgeCtrl,
                          sisterSelected: controller.famStrokeSister,
                          sisterAgeController: controller.famStrokeSisterAgeCtrl,
                          grandparentsSelected: controller.famStrokeGrandparents,
                          grandparentsAgeController: controller.famStrokeGrandparentsAgeCtrl,
                        ),
                        const SizedBox(height: 8),
                        Text('fh_significance'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        RadioGroup<String>(
                          groupValue: controller.famStrokeSignificance.value,
                          onChanged: (val) => controller.famStrokeSignificance.value = val ?? 'Significant',
                          child: Row(
                            children: ['Significant', 'Non-Significant'].map((opt) => Row(
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt == 'Significant' ? 'fh_significant'.tr : 'fh_non_significant'.tr),
                                const SizedBox(width: 16),
                              ],
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),

                // 3. Family Angioplasty
                Text('family_angioplasty_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasFamilyAngioplasty.value,
                      onChanged: (val) => controller.hasFamilyAngioplasty.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasFamilyAngioplasty.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFamilyMemberSelector(
                          fatherSelected: controller.famAngioplastyFather,
                          fatherAgeController: controller.famAngioplastyFatherAgeCtrl,
                          motherSelected: controller.famAngioplastyMother,
                          motherAgeController: controller.famAngioplastyMotherAgeCtrl,
                          brotherSelected: controller.famAngioplastyBrother,
                          brotherAgeController: controller.famAngioplastyBrotherAgeCtrl,
                          sisterSelected: controller.famAngioplastySister,
                          sisterAgeController: controller.famAngioplastySisterAgeCtrl,
                          grandparentsSelected: controller.famAngioplastyGrandparents,
                          grandparentsAgeController: controller.famAngioplastyGrandparentsAgeCtrl,
                        ),
                        const SizedBox(height: 8),
                        Text('fh_significance'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        RadioGroup<String>(
                          groupValue: controller.famAngioplastySignificance.value,
                          onChanged: (val) => controller.famAngioplastySignificance.value = val ?? 'Significant',
                          child: Row(
                            children: ['Significant', 'Non-Significant'].map((opt) => Row(
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt == 'Significant' ? 'fh_significant'.tr : 'fh_non_significant'.tr),
                                const SizedBox(width: 16),
                              ],
                            )).toList(),
                          ),
                        ),
                        if (controller.famAngioplastySignificance.value == 'Significant') ...[
                          const SizedBox(height: 8),
                          AppLabeledTextField(
                            controller: controller.famAngioplastyCommentsCtrl,
                            label: 'angioplasty_comments'.tr,
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),

                // 4. Family Sudden Death
                Text('family_died_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasFamilySuddenDeath.value,
                      onChanged: (val) => controller.hasFamilySuddenDeath.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasFamilySuddenDeath.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFamilyMemberSelector(
                          fatherSelected: controller.famDiedFather,
                          fatherAgeController: controller.famDiedFatherAgeCtrl,
                          motherSelected: controller.famDiedMother,
                          motherAgeController: controller.famDiedMotherAgeCtrl,
                          brotherSelected: controller.famDiedBrother,
                          brotherAgeController: controller.famDiedBrotherAgeCtrl,
                          sisterSelected: controller.famDiedSister,
                          sisterAgeController: controller.famDiedSisterAgeCtrl,
                          grandparentsSelected: controller.famDiedGrandparents,
                          grandparentsAgeController: controller.famDiedGrandparentsAgeCtrl,
                        ),
                        const SizedBox(height: 8),
                        Text('sudden_death_reason'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        const SizedBox(height: 4),
                        Obx(() => RadioGroup<String>(
                          groupValue: controller.famDiedReasonRadio.value,
                          onChanged: (val) => controller.famDiedReasonRadio.value = val ?? 'Heart Attack',
                          child: Wrap(
                            children: ['Heart Attack', 'Stroke', 'Accident', 'Other', "Reason don't know"].map((opt) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt == 'Heart Attack'
                                    ? 'heart_attack'.tr
                                    : opt == 'Stroke'
                                        ? 'stroke'.tr
                                        : opt == 'Other'
                                            ? 'other'.tr
                                            : opt == "Reason don't know"
                                                ? 'reason_dont_know'.tr
                                                : opt),
                                const SizedBox(width: 12),
                              ],
                            )).toList(),
                          ),
                        )),
                        const SizedBox(height: 8),
                        Text('fh_significance'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        RadioGroup<String>(
                          groupValue: controller.famDiedSignificance.value,
                          onChanged: (val) => controller.famDiedSignificance.value = val ?? 'Significant',
                          child: Row(
                            children: ['Significant', 'Non-Significant'].map((opt) => Row(
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt == 'Significant' ? 'fh_significant'.tr : 'fh_non_significant'.tr),
                                const SizedBox(width: 16),
                              ],
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 28),

                // ================= SECTION 4: PERSONAL HABITS =================
                AppFormSectionHeader(
                  subtitle: '',
                  title: 'sec4_title'.tr,
                ),
                const SizedBox(height: 12),

                // 1. Smoking
                Text('do_you_smoke'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.smokeHabit.value,
                      onChanged: (val) => controller.smokeHabit.value = val ?? 'No',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [AppRadio<String>(value: 'Yes'), Text('yes'.tr)]),
                          Row(children: [AppRadio<String>(value: 'No'), Text('no'.tr)]),
                          Row(children: [AppRadio<String>(value: 'Ex-Smoker'), Text('ex_smoker'.tr)]),
                        ],
                      ),
                    )),
                Obx(() {
                  if (controller.smokeHabit.value == 'Yes') {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AppLabeledTextField(
                        controller: controller.dailyCigaretteCountCtrl,
                        label: 'daily_cigarette_count'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    );
                  }
                  if (controller.smokeHabit.value == 'Ex-Smoker') {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('stopped_before'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.medicalGray),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.smokeStopBeforeYears.value,
                                isExpanded: true,
                                items: ['Less than 6 months', '1 Year', '2 Years', 'More than 5 Years']
                                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                                    .toList(),
                                onChanged: (val) => controller.smokeStopBeforeYears.value = val ?? 'Less than 6 months',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const Divider(height: 24),

                // 2. Alcohol
                Text('do_you_take_alcohol'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.alcoholHabit.value,
                      onChanged: (val) => controller.alcoholHabit.value = val ?? 'No',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [AppRadio<String>(value: 'Yes'), Text('yes'.tr)]),
                          Row(children: [AppRadio<String>(value: 'No'), Text('no'.tr)]),
                          Row(children: [AppRadio<String>(value: 'Ex-Alcoholic'), Text('ex_alcoholic'.tr)]),
                          Row(children: [AppRadio<String>(value: 'Not Disclosed'), Text('not_disclosed'.tr)]),
                        ],
                      ),
                    )),
                const Divider(height: 24),

                // 3. Extra Salt
                Text('do_you_use_extra_salt_in_food'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.extraSaltHabit.value,
                      onChanged: (val) => controller.extraSaltHabit.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.extraSaltHabit.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppLabeledTextField(
                      controller: controller.familyMembersCountCtrl,
                      label: 'family_members_count'.tr,
                      keyboardType: TextInputType.number,
                    ),
                  );
                }),
                const Divider(height: 24),

                // 4. Morning Walk
                Text('morning_walk_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.morningWalkHabit.value,
                      onChanged: (val) => controller.morningWalkHabit.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                const Divider(height: 24),

                // 5. Yoga
                Text('yoga_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.yogaHabit.value,
                      onChanged: (val) => controller.yogaHabit.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                const SizedBox(height: 28),

                // ================= SECTION 5: VITALS & EVALUATION =================
                AppFormSectionHeader(
                  subtitle: '',
                  title: 'sec5_title'.tr,
                ),
                const SizedBox(height: 12),

                // Height & Weight
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.heightCtrl,
                        label: 'height_2'.tr,
                        hint: 'cm',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.weightCtrl,
                        label: 'weight'.tr,
                        hint: 'kg',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Last Known BP Reading
                Text('your_last_known_bp_reading'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.bpSystolicCtrl,
                        label: 'systolic'.tr,
                        hint: '120',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.bpDiastolicCtrl,
                        label: 'diastolic'.tr,
                        hint: '80',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Any Other Info
                Text('any_other_info'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasOtherInfo.value,
                      onChanged: (val) => controller.hasOtherInfo.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasOtherInfo.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppLabeledTextField(
                      controller: controller.otherInfoCtrl,
                      label: 'other_info'.tr,
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // First Evaluation Impression (Speech Input)
                AppSpeechInputWidget(
                  controller: controller.evaluationNoteCtrl,
                  label: 'first_evaluation_title'.tr,
                  hintText: 'evaluation'.tr,
                ),
                const SizedBox(height: 16),

                // Other Care Needed
                Text('other_care_q'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy)),
                const SizedBox(height: 4),
                Obx(() => RadioGroup<String>(
                      groupValue: controller.hasOtherCare.value,
                      onChanged: (val) => controller.hasOtherCare.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    )),
                Obx(() {
                  if (controller.hasOtherCare.value != 'Yes') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppLabeledTextField(
                      controller: controller.otherCareDetailsCtrl,
                      label: 'care'.tr,
                    ),
                  );
                }),

                const SizedBox(height: 32),

                // Bottom Update Button
                Center(
                  child: AppPrimaryButton(
                    label: 'update'.tr,
                    onPressed: () {
                      controller.submitUpdateMedicalForm();
                    },
                    backgroundColor: AppColors.success,
                    width: 160,
                    height: 46,
                    borderRadius: 8,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Obx(() => AppLoadingOverlay(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }

  Widget _buildConditionSection({
    required BuildContext context,
    required String title,
    required String iconPath,
    required RxString hasCondition,
    required RxString yearsSince,
    required RxString onMedicine,
    required RxString medicineRegular,
    required RxInt medCount,
    required TextEditingController medName1,
    required TextEditingController medName2,
    required TextEditingController medName3,
    required RxString medFreq1,
    required RxString medFreq2,
    required RxString medFreq3,
    required RxList<File> reportsList,
    required RxList<String> networkImages,
    required String typeKey,
    required ServingPatientMedicalFormController controller,
    bool hideRegularQuestion = false,
    required bool allowDontKnow,
    Widget? customSubWidgets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
        ),
        const SizedBox(height: 4),
        Obx(
          () => RadioGroup<String>(
            groupValue: hasCondition.value,
            onChanged: (val) => hasCondition.value = val ?? 'No',
            child: allowDontKnow
                ? Column(
                    children: ['Yes', 'No', "New Diagnosis"].map((opt) => Row(
                      children: [
                        AppRadio<String>(value: opt),
                        Text(opt == "New Diagnosis" ? 'new_diagnosis'.tr : opt.toLowerCase().tr),
                      ],
                    )).toList(),
                  )
                : Row(
                    children: ['Yes', 'No'].map((opt) => Row(
                      children: [
                        AppRadio<String>(value: opt),
                        Text(opt.toLowerCase().tr),
                        const SizedBox(width: 24),
                      ],
                    )).toList(),
                  ),
          ),
        ),
              Obx(() {
                if (hasCondition.value != 'Yes') return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ?customSubWidgets,
                    const SizedBox(height: 12),
                    Text('since_how_many_years'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.medicalGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: yearsDropdownOptions.contains(yearsSince.value)
                              ? yearsSince.value
                              : 'Select',
                          isExpanded: true,
                          items: yearsDropdownOptions
                              .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v == 'Select' ? 'select'.tr : v),
                                  ))
                              .toList(),
                          onChanged: (val) => yearsSince.value = val ?? 'Select',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('are_you_on_medicines'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                    const SizedBox(height: 4),
                    RadioGroup<String>(
                      groupValue: onMedicine.value,
                      onChanged: (val) => onMedicine.value = val ?? 'No',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            AppRadio<String>(value: opt),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    ),
                    if (onMedicine.value == 'Yes') ...[
                      const SizedBox(height: 12),
                      // Dynamic Medicines Fields
                      if (medCount.value == 0)
                        Center(
                          child: TextButton.icon(
                            onPressed: () => medCount.value = 1,
                            icon: const Icon(Icons.add, color: AppColors.teal),
                            label: Text('add_medicine'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (medCount.value >= 1) ...[
                        _buildMedicineRow(medName1, medFreq1, 'enter_name_of_medicine'.tr),
                        const SizedBox(height: 8),
                      ],
                      if (medCount.value >= 2) ...[
                        _buildMedicineRow(medName2, medFreq2, 'enter_name_of_medicine_2'.tr),
                        const SizedBox(height: 8),
                      ],
                      if (medCount.value >= 3) ...[
                        _buildMedicineRow(medName3, medFreq3, 'enter_name_of_medicine_3'.tr),
                        const SizedBox(height: 8),
                      ],
                      if (medCount.value > 0 && medCount.value < 3)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => medCount.value++,
                            icon: const Icon(Icons.add, color: AppColors.teal),
                            label: Text('add_more'.tr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold)),
                          ),
                        ),

                      // Upload Images Section
                      const SizedBox(height: 12),
                      Text('or_upload_report'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      if (networkImages.isNotEmpty || reportsList.isNotEmpty) ...[
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...networkImages.map((url) => Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.medicalGray),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Center(
                                          child: Icon(Icons.broken_image, size: 24, color: AppColors.coolGray),
                                        ),
                                      ),
                                    ),
                                  )),
                              ...reportsList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final file = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.medicalGray),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(file),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () => reportsList.removeAt(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, size: 14, color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (reportsList.length + networkImages.length < 3)
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showImageSourceDialog(typeKey, controller),
                              icon: const Icon(Icons.upload_file, size: 18),
                              label: Text('select_file'.tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightGray,
                                foregroundColor: AppColors.navy,
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),

                      if (!hideRegularQuestion) ...[
                        const SizedBox(height: 12),
                        Text('do_you_take_medicines_regularly'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                        const SizedBox(height: 4),
                        RadioGroup<String>(
                          groupValue: medicineRegular.value,
                          onChanged: (val) => medicineRegular.value = val ?? 'No',
                          child: Row(
                            children: ['Yes', 'No'].map((opt) => Row(
                              children: [
                                AppRadio<String>(value: opt),
                                Text(opt.toLowerCase().tr),
                                const SizedBox(width: 24),
                              ],
                            )).toList(),
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              }),
      ],
    );
  }

  Widget _buildMedicineRow(
    TextEditingController controller,
    RxString freqValue,
    String hint,
  ) {
    const freqOptions = ['One Time', 'Two Time', 'Three Time', 'Four Time', 'SOS'];

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.medicalGray),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton<String>(
                  value: freqOptions.contains(freqValue.value) ? freqValue.value : 'One Time',
                  isExpanded: true,
                  items: freqOptions
                      .map((v) => DropdownMenuItem(
                            value: v,
                            child: Text(
                              v == 'One Time'
                                  ? 'one_time'.tr
                                  : v == 'Two Time'
                                      ? 'two_times'.tr
                                      : v == 'Three Time'
                                          ? 'three_times'.tr
                                          : v == 'Four Time'
                                              ? 'four_times'.tr
                                              : v,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => freqValue.value = val ?? 'One Time',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxItem(String label, RxBool valueObs) {
    return Obx(() => InkWell(
          onTap: () => valueObs.value = !valueObs.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: valueObs.value,
                onChanged: (val) => valueObs.value = val ?? false,
                activeColor: AppColors.teal,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Text(label, style: const TextStyle(fontSize: 13, color: AppColors.navy)),
            ],
          ),
        ));
  }

  void _showImageSourceDialog(String typeKey, ServingPatientMedicalFormController controller) {
    Get.bottomSheet(
      Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('choose_image_source'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.teal),
              title: Text('choose_from_gallery'.tr),
              onTap: () {
                Get.back();
                controller.pickReportImage(typeKey, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.teal),
              title: Text('take_a_photo'.tr),
              onTap: () {
                Get.back();
                controller.pickReportImage(typeKey, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
