import 'dart:io';
import 'package:digi_icu_flutter/controllers/serving_patient_medical_form_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/m_cholesterol.png', width: 65, height: 65),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 5. Asthma
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/m_asthma.png', width: 65, height: 65),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                  iconPath: 'assets/images/m_heart_attack.png',
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
                ),
                const Divider(height: 24),

                // 2. Stroke
                _buildConditionSection(
                  context: context,
                  title: 'q_stroke'.tr,
                  iconPath: 'assets/images/m_stroke.png',
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
                ),
                const Divider(height: 24),

                // 3. Kidney Failure
                _buildConditionSection(
                  context: context,
                  title: 'q_kidney_failure'.tr,
                  iconPath: 'assets/images/m_kidney_failure.png',
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
                ),
                const Divider(height: 24),

                // 4. Angioplasty
                _buildConditionSection(
                  context: context,
                  title: 'q_angioplasty'.tr,
                  iconPath: 'assets/images/m_angioplasty.png',
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
                ),
                const Divider(height: 24),

                // 5. Bypass Surgery
                _buildConditionSection(
                  context: context,
                  title: 'q_bypass'.tr,
                  iconPath: 'assets/images/m_bypass_surgery.png',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/m_allergy.png', width: 65, height: 65),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                              children: [
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
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 7. Bleeding Tendencies
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/m_bleeding_tendencny.png', width: 65, height: 65),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 8. Other Surgery / Treatment
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/m_bypass_surgery.png', width: 65, height: 65),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
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
                              children: [
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
                    ),
                  ],
                ),

                const SizedBox(height: 28),

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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconPath, width: 65, height: 65),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
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
                          children: ['Yes', 'No', "Don't Know"].map((opt) => Row(
                            children: [
                              AppRadio<String>(value: opt),
                              Text(opt == "Don't Know" ? 'dont_know'.tr : opt.toLowerCase().tr),
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
          ),
        ),
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
