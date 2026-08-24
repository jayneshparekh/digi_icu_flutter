import 'dart:io';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/medical_form_controller.dart';

class MedicalFormScreen extends GetView<MedicalFormController> {
  const MedicalFormScreen({super.key});

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
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
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
                  'medical_form'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            );
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => Get.offAllNamed('/patient-dashboard'),
            ),
          ],
        ),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFormSectionHeader(
                      subtitle: '',
                      title: 'clinical_history'.tr,
                    ),
                    const SizedBox(height: 12),

                    // --- 1. HYPERTENSION ---
                    _buildConditionSection(
                      title: 'q_hypertension'.tr,
                      iconPath: 'assets/images/m_hypertension.png',
                      hasCondition: controller.hasHypertension,
                      yearsSince: controller.htnYears,
                      onMedicine: controller.htnOnMedicine,
                      medicineRegular: controller.htnMedicineRegular,
                      medCount: controller.htnMedCount,
                      medName1: controller.htnMedName1Controller,
                      medName2: controller.htnMedName2Controller,
                      medName3: controller.htnMedName3Controller,
                      medFreq1: controller.htnMedFreq1,
                      medFreq2: controller.htnMedFreq2,
                      medFreq3: controller.htnMedFreq3,
                      reportsList: controller.htnReports,
                      typeKey: 'HTN',
                      allowDontKnow: true,
                    ),
                    const Divider(height: 24),

                    // --- 2. DIABETES ---
                    _buildConditionSection(
                      title: 'q_diabetes'.tr,
                      iconPath: 'assets/images/m_diabetes.png',
                      hasCondition: controller.hasDiabetes,
                      yearsSince: controller.diabetesYears,
                      onMedicine: controller.diabetesOnMedicine,
                      medicineRegular: controller.diabetesMedicineRegular,
                      medCount: controller.diabetesMedCount,
                      medName1: controller.diabetesMedName1Controller,
                      medName2: controller.diabetesMedName2Controller,
                      medName3: controller.diabetesMedName3Controller,
                      medFreq1: controller.diabetesMedFreq1,
                      medFreq2: controller.diabetesMedFreq2,
                      medFreq3: controller.diabetesMedFreq3,
                      reportsList: controller.diabetesReports,
                      typeKey: 'Diabetes',
                      allowDontKnow: true,
                    ),
                    const Divider(height: 24),

                    // --- 3. THYROID ---
                    _buildConditionSection(
                      title: 'q_thyroid'.tr,
                      iconPath: 'assets/images/m_feeling.png',
                      hasCondition: controller.hasThyroid,
                      yearsSince: controller.thyroidYears,
                      onMedicine: controller.thyroidOnMedicine,
                      medicineRegular: controller.thyroidMedicineRegular,
                      medCount: controller.thyroidMedCount,
                      medName1: controller.thyroidMedName1Controller,
                      medName2: controller.thyroidMedName2Controller,
                      medName3: controller.thyroidMedName3Controller,
                      medFreq1: controller.thyroidMedFreq1,
                      medFreq2: controller.thyroidMedFreq2,
                      medFreq3: controller.thyroidMedFreq3,
                      reportsList: controller.thyroidReports,
                      typeKey: 'Thyroid',
                      allowDontKnow: true,
                    ),
                    const Divider(height: 24),

                    // --- 4. CHOLESTEROL ---
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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              RadioGroup<String>(
                                groupValue: controller.hasCholesterol.value,
                                onChanged: (val) => controller.hasCholesterol.value = val ?? '',
                                child: Column(
                                  children: ['Yes', 'No', "Don't Know"].map((opt) => Row(
                                    children: [
                                      Radio<String>(value: opt, activeColor: AppColors.primary),
                                      Text(opt == "Don't Know" ? 'dont_know'.tr : opt.toLowerCase().tr),
                                    ],
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // --- 5. ASTHMA ---
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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              RadioGroup<String>(
                                groupValue: controller.hasAsthma.value,
                                onChanged: (val) => controller.hasAsthma.value = val ?? '',
                                child: Row(
                                  children: ['Yes', 'No'].map((opt) => Row(
                                    children: [
                                      Radio<String>(value: opt, activeColor: AppColors.primary),
                                      Text(opt.toLowerCase().tr),
                                      const SizedBox(width: 24),
                                    ],
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // --- PREGNANCY SECTIONS (FEMALE ONLY) ---
                    if (controller.showPregnancySection) ...[
                      const Divider(height: 24),
                      if (controller.showIsPregnantQuestion) ...[
                        Text(
                          'q_pregnant'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        RadioGroup<String>(
                          groupValue: controller.isPregnant.value,
                          onChanged: (val) => controller.isPregnant.value = val ?? '',
                          child: Row(
                              children: ['Yes', 'No', 'May be'].map((opt) => Row(
                                children: [
                                  Radio<String>(value: opt, activeColor: AppColors.primary),
                                  Text(opt == 'May be' ? 'may_be'.tr : opt.toLowerCase().tr),
                                  const SizedBox(width: 16),
                                ],
                            )).toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        'pregnancy_details'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      RadioGroup<String>(
                        groupValue: controller.duringPregnancy.value,
                        onChanged: (val) => controller.duringPregnancy.value = val ?? '',
                        child: Column(
                          children: ['Hypertension', 'Diabetes', 'Both', 'None'].map((opt) => Row(
                            children: [
                              Radio<String>(value: opt, activeColor: AppColors.primary),
                              Text(opt == 'Both' ? 'both'.tr : opt == 'None' ? 'none'.tr : opt),
                            ],
                          )).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    AppFormSectionHeader(
                      subtitle: '',
                      title: 'past_history_title'.tr,
                    ),
                    const SizedBox(height: 12),

                    // --- 1. HEART ATTACK ---
                    _buildConditionSection(
                      title: 'q_heart_attack'.tr,
                      iconPath: 'assets/images/m_heart_attack.png',
                      hasCondition: controller.hasHeartAttack,
                      yearsSince: controller.heartAttackYears,
                      onMedicine: controller.heartAttackOnMedicine,
                      medicineRegular: RxString('Yes'),
                      medCount: controller.heartAttackMedCount,
                      medName1: controller.heartAttackMedName1Controller,
                      medName2: controller.heartAttackMedName2Controller,
                      medName3: controller.heartAttackMedName3Controller,
                      medFreq1: controller.heartAttackMedFreq1,
                      medFreq2: controller.heartAttackMedFreq2,
                      medFreq3: controller.heartAttackMedFreq3,
                      reportsList: controller.heartAttackReports,
                      typeKey: 'HeartAttack',
                      hideRegularQuestion: true,
                      allowDontKnow: false,
                    ),
                    const Divider(height: 24),

                    // --- 2. STROKE ---
                    _buildConditionSection(
                      title: 'q_stroke'.tr,
                      iconPath: 'assets/images/m_stroke.png',
                      hasCondition: controller.hasStroke,
                      yearsSince: controller.strokeYears,
                      onMedicine: controller.strokeOnMedicine,
                      medicineRegular: RxString('Yes'),
                      medCount: controller.strokeMedCount,
                      medName1: controller.strokeMedName1Controller,
                      medName2: controller.strokeMedName2Controller,
                      medName3: controller.strokeMedName3Controller,
                      medFreq1: controller.strokeMedFreq1,
                      medFreq2: controller.strokeMedFreq2,
                      medFreq3: controller.strokeMedFreq3,
                      reportsList: controller.strokeReports,
                      typeKey: 'Stroke',
                      hideRegularQuestion: true,
                      allowDontKnow: false,
                    ),
                    const Divider(height: 24),

                    // --- 3. KIDNEY FAILURE ---
                    _buildConditionSection(
                      title: 'q_kidney_failure'.tr,
                      iconPath: 'assets/images/m_kidney_failure.png',
                      hasCondition: controller.hasKidneyFailure,
                      yearsSince: controller.kidneyFailureYears,
                      onMedicine: controller.kidneyFailureOnMedicine,
                      medicineRegular: RxString('Yes'),
                      medCount: controller.kidneyFailureMedCount,
                      medName1: controller.kidneyFailureMedName1Controller,
                      medName2: controller.kidneyFailureMedName2Controller,
                      medName3: controller.kidneyFailureMedName3Controller,
                      medFreq1: controller.kidneyFailureMedFreq1,
                      medFreq2: controller.kidneyFailureMedFreq2,
                      medFreq3: controller.kidneyFailureMedFreq3,
                      reportsList: controller.kidneyFailureReports,
                      typeKey: 'KidneyFailure',
                      hideRegularQuestion: true,
                      allowDontKnow: false,
                    ),
                    const Divider(height: 24),

                    // --- 4. ANGIOPLASTY ---
                    _buildConditionSection(
                      title: 'q_angioplasty'.tr,
                      iconPath: 'assets/images/m_angioplasty.png',
                      hasCondition: controller.hasAngioplasty,
                      yearsSince: controller.angioplastyYears,
                      onMedicine: controller.angioplastyOnMedicine,
                      medicineRegular: RxString('Yes'),
                      medCount: controller.angioplastyMedCount,
                      medName1: controller.angioplastyMedName1Controller,
                      medName2: controller.angioplastyMedName2Controller,
                      medName3: controller.angioplastyMedName3Controller,
                      medFreq1: controller.angioplastyMedFreq1,
                      medFreq2: controller.angioplastyMedFreq2,
                      medFreq3: controller.angioplastyMedFreq3,
                      reportsList: controller.angioplastyReports,
                      typeKey: 'Angioplasty',
                      hideRegularQuestion: true,
                      allowDontKnow: false,
                    ),
                    const Divider(height: 24),

                    // --- 5. BYPASS SURGERY ---
                    _buildConditionSection(
                      title: 'q_bypass'.tr,
                      iconPath: 'assets/images/m_bypass_surgery.png',
                      hasCondition: controller.hasBypass,
                      yearsSince: controller.bypassYears,
                      onMedicine: controller.bypassOnMedicine,
                      medicineRegular: RxString('Yes'),
                      medCount: controller.bypassMedCount,
                      medName1: controller.bypassMedName1Controller,
                      medName2: controller.bypassMedName2Controller,
                      medName3: controller.bypassMedName3Controller,
                      medFreq1: controller.bypassMedFreq1,
                      medFreq2: controller.bypassMedFreq2,
                      medFreq3: controller.bypassMedFreq3,
                      reportsList: controller.bypassReports,
                      typeKey: 'Bypass',
                      hideRegularQuestion: true,
                      allowDontKnow: false,
                    ),
                    const Divider(height: 24),

                    // --- 6. ALLERGY TO MEDICINES ---
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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              RadioGroup<String>(
                                groupValue: controller.hasAllergy.value,
                                onChanged: (val) => controller.hasAllergy.value = val ?? '',
                                child: Row(
                                  children: ['Yes', 'No'].map((opt) => Row(
                                    children: [
                                      Radio<String>(value: opt, activeColor: AppColors.primary),
                                      Text(opt.toLowerCase().tr),
                                      const SizedBox(width: 24),
                                    ],
                                  )).toList(),
                                ),
                              ),
                              if (controller.hasAllergy.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                if (controller.allergyMedCount.value == 0)
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: () => controller.allergyMedCount.value = 1,
                                      icon: const Icon(Icons.add, color: AppColors.primary),
                                      label: Text('add_medicine'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                if (controller.allergyMedCount.value >= 1) ...[
                                  TextField(
                                    controller: controller.allergyMedName1Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_medicine_name'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.allergyMedCount.value >= 2) ...[
                                  TextField(
                                    controller: controller.allergyMedName2Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_medicine_name_2'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.allergyMedCount.value >= 3) ...[
                                  TextField(
                                    controller: controller.allergyMedName3Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_medicine_name_3'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.allergyMedCount.value > 0 && controller.allergyMedCount.value < 3)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => controller.allergyMedCount.value++,
                                      icon: const Icon(Icons.add, color: AppColors.primary),
                                      label: Text('add_more'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // --- 7. BLEEDING TENDENCIES ---
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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              RadioGroup<String>(
                                groupValue: controller.hasBleedingTendency.value,
                                onChanged: (val) => controller.hasBleedingTendency.value = val ?? '',
                                child: Row(
                                  children: ['Yes', 'No'].map((opt) => Row(
                                    children: [
                                      Radio<String>(value: opt, activeColor: AppColors.primary),
                                      Text(opt.toLowerCase().tr),
                                      const SizedBox(width: 24),
                                    ],
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // --- 8. OTHER SURGERY / TREATMENT ---
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
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              RadioGroup<String>(
                                groupValue: controller.hasOtherSurgery.value,
                                onChanged: (val) => controller.hasOtherSurgery.value = val ?? '',
                                child: Row(
                                  children: ['Yes', 'No'].map((opt) => Row(
                                    children: [
                                      Radio<String>(value: opt, activeColor: AppColors.primary),
                                      Text(opt.toLowerCase().tr),
                                      const SizedBox(width: 24),
                                    ],
                                  )).toList(),
                                ),
                              ),
                              if (controller.hasOtherSurgery.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                if (controller.surgeryMedCount.value == 0)
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: () => controller.surgeryMedCount.value = 1,
                                      icon: const Icon(Icons.add, color: AppColors.primary),
                                      label: Text('add_surgery'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                if (controller.surgeryMedCount.value >= 1) ...[
                                  TextField(
                                    controller: controller.surgeryName1Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_surgery_name'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.surgeryMedCount.value >= 2) ...[
                                  TextField(
                                    controller: controller.surgeryName2Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_surgery_name_2'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.surgeryMedCount.value >= 3) ...[
                                  TextField(
                                    controller: controller.surgeryName3Controller,
                                    decoration: InputDecoration(
                                      hintText: 'enter_surgery_name_3'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (controller.surgeryMedCount.value > 0 && controller.surgeryMedCount.value < 3)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => controller.surgeryMedCount.value++,
                                      icon: const Icon(Icons.add, color: AppColors.primary),
                                      label: Text('add_more'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    Center(
                      child: AppPrimaryButton(
                        label: 'submit'.tr,
                        onPressed: () => controller.submitMedicalForm(),
                        backgroundColor: AppColors.success,
                        width: 160,
                        height: 46,
                        borderRadius: 8,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

  Widget _buildConditionSection({
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
    required String typeKey,
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              RadioGroup<String>(
                groupValue: hasCondition.value,
                onChanged: (val) => hasCondition.value = val ?? '',
                child: allowDontKnow 
                  ? Column(
                      children: ['Yes', 'No', "Don't Know"].map((opt) => Row(
                        children: [
                          Radio<String>(value: opt, activeColor: AppColors.primary),
                          Text(opt),
                        ],
                      )).toList(),
                    )
                  : Row(
                      children: ['Yes', 'No'].map((opt) => Row(
                        children: [
                          Radio<String>(value: opt, activeColor: AppColors.primary),
                          Text(opt.toLowerCase().tr),
                          const SizedBox(width: 24),
                        ],
                      )).toList(),
                    ),
              ),
              if (hasCondition.value == 'Yes') ...[
                const SizedBox(height: 12),
                Text('since_how_many_years'.tr, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: yearsSince.value,
                      isExpanded: true,
                      items: ['Select', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10+', 'More than 10 Years']
                          .map((v) => DropdownMenuItem(value: v, child: Text(v == 'Select' ? 'select'.tr : v == 'More than 10 Years' ? 'more_than_10_years'.tr : v)))
                          .toList(),
                      onChanged: (val) => yearsSince.value = val ?? 'Select',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('are_you_on_medicines'.tr, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 4),
                RadioGroup<String>(
                  groupValue: onMedicine.value,
                  onChanged: (val) => onMedicine.value = val ?? '',
                  child: Row(
                    children: ['Yes', 'No'].map((opt) => Row(
                      children: [
                        Radio<String>(value: opt, activeColor: AppColors.primary),
                        Text(opt),
                        const SizedBox(width: 24),
                      ],
                    )).toList(),
                  ),
                ),
                if (onMedicine.value == 'Yes') ...[
                  const SizedBox(height: 12),
                  // Dynamic Medicines Fields
                  if (medCount.value >= 0) ...[
                    if (medCount.value == 0)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => medCount.value = 1,
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          label: Text('add_medicine'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          label: Text('add_more'.tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],

                  // Upload Images Section
                  const SizedBox(height: 12),
                  Text('or_upload_report'.tr, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (reportsList.isNotEmpty) ...[
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: reportsList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(reportsList[index]),
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
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (reportsList.length < 3)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showImageSourceDialog(typeKey),
                          icon: const Icon(Icons.upload_file, size: 18),
                          label: Text('select_file'.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),

                  if (!hideRegularQuestion) ...[
                    const SizedBox(height: 12),
                    Text('do_you_take_medicines_regularly'.tr, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 4),
                    RadioGroup<String>(
                      groupValue: medicineRegular.value,
                      onChanged: (val) => medicineRegular.value = val ?? '',
                      child: Row(
                        children: ['Yes', 'No'].map((opt) => Row(
                          children: [
                            Radio<String>(value: opt, activeColor: AppColors.primary),
                            Text(opt.toLowerCase().tr),
                            const SizedBox(width: 24),
                          ],
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineRow(TextEditingController controller, RxString freqValue, String hint) {
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
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: freqValue.value,
                isExpanded: true,
                items: ['One Time', 'Two Times', 'Three Times', 'Four Times']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v == 'One Time' ? 'one_time'.tr : v == 'Two Times' ? 'two_times'.tr : v == 'Three Times' ? 'three_times'.tr : v == 'Four Times' ? 'four_times'.tr : v, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) => freqValue.value = val ?? 'One Time',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSourceDialog(String typeKey) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('choose_image_source'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('choose_from_gallery'.tr),
              onTap: () {
                Get.back();
                controller.pickReportImage(typeKey, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
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
