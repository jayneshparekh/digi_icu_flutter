import 'package:digi_icu_flutter/controllers/serving_patient_quick_form_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/episode_selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServingPatientQuickFormView extends StatelessWidget {
  const ServingPatientQuickFormView({super.key});

  Widget _buildRadioRow({
    required String title,
    required RxString selectedVal,
    required List<String> options,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.navy),
            ),
          ),
          Expanded(
            child: Obx(
              () => Wrap(
                spacing: 12,
                children: options.map((opt) {
                  final isSelected = selectedVal.value == opt;
                  return InkWell(
                    onTap: () => selectedVal.value = opt,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            size: 20,
                            color: isSelected ? AppColors.teal : AppColors.medicalGray,
                          ),
                          const SizedBox(width: 4),
                          Text(opt, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServingPatientQuickFormController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.isEditMode.value ? 'edit_quick_form'.tr : 'add_quick_form'.tr,
              style: const TextStyle(color: AppColors.navy),
            )),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Blood Pressure Section
                AppFormSectionHeader(title: 'blood_pressure'.tr),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.systolicCtrl,
                        label: 'systolic'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.diastolicCtrl,
                        label: 'diastolic_bp'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('lying_down_bp'.tr, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.lyingDownSystolicCtrl,
                        label: 'lying_down_systolic'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.lyingDownDiastolicCtrl,
                        label: 'lying_down_diastolic'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('standing_bp'.tr, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.standingSystolicCtrl,
                        label: 'standing_systolic'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.standingDiastolicCtrl,
                        label: 'standing_diastolic'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                // 2. Blood Sugar Section
                AppFormSectionHeader(title: 'blood_sugar_unit'.tr),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.fastingCtrl,
                        label: 'fasting'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.afterFoodCtrl,
                        label: 'after_food'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppLabeledTextField(
                        controller: controller.randomCtrl,
                        label: 'random'.tr,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                // 3. Weight Section
                AppFormSectionHeader(title: 'vital_weight'.tr),
                const SizedBox(height: 12),
                AppLabeledTextField(
                  controller: controller.weightCtrl,
                  label: 'weight_kg_label'.tr,
                  keyboardType: TextInputType.number,
                ),

                // 4. Episode Symptoms Selection
                AppFormSectionHeader(title: 'episode_symptoms'.tr),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: [
                      EpisodeSelectionTile(
                        label: 'ep_breathlessness'.tr,
                        imageName: 'm_breathing',
                        isSelected: controller.isBreathlessness.value,
                        onTap: () => controller.isBreathlessness.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_chest_pain'.tr,
                        imageName: 'm_chest_pain',
                        isSelected: controller.isChestPain.value,
                        onTap: () => controller.isChestPain.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_chest_pain_sweating'.tr,
                        imageName: 'm_chest_pain',
                        isSelected: controller.isChestPainSweating.value,
                        onTap: () => controller.isChestPainSweating.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_low_bp'.tr,
                        imageName: 'm_chest_pain',
                        isSelected: controller.isLowBp.value,
                        onTap: () => controller.isLowBp.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_palpitations'.tr,
                        imageName: 'm_palpitations',
                        isSelected: controller.isPalpitations.value,
                        onTap: () => controller.isPalpitations.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_headache'.tr,
                        imageName: 'm_headache',
                        isSelected: controller.isHeadache.value,
                        onTap: () => controller.isHeadache.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_giddiness'.tr,
                        imageName: 'm_giddiness',
                        isSelected: controller.isGiddiness.value,
                        onTap: () => controller.isGiddiness.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_low_sugar'.tr,
                        imageName: 'm_breathing',
                        isSelected: controller.isLowSugar.value,
                        onTap: () => controller.isLowSugar.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_high_sugar'.tr,
                        imageName: 'm_chest_pain',
                        isSelected: controller.isHighSugar.value,
                        onTap: () => controller.isHighSugar.toggle(),
                      ),
                      EpisodeSelectionTile(
                        label: 'ep_high_bp'.tr,
                        imageName: 'm_chest_pain',
                        isSelected: controller.isHighBp.value,
                        onTap: () => controller.isHighBp.toggle(),
                      ),
                    ],
                  ),
                ),

                // 5. Hospitalization History
                AppFormSectionHeader(title: 'hospitalization_history'.tr),
                const SizedBox(height: 12),
                Obx(() => CheckboxListTile(
                      title: Text('q_heart_attack'.tr),
                      value: controller.cbHeartAttack.value,
                      onChanged: (v) => controller.cbHeartAttack.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('q_stroke'.tr),
                      value: controller.cbStroke.value,
                      onChanged: (v) => controller.cbStroke.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('q_kidney_failure'.tr),
                      value: controller.cbKidneyFailure.value,
                      onChanged: (v) => controller.cbKidneyFailure.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('very_high_bp'.tr),
                      value: controller.cbHighBP.value,
                      onChanged: (v) => controller.cbHighBP.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('very_high_sugar'.tr),
                      value: controller.cbHighSugar.value,
                      onChanged: (v) => controller.cbHighSugar.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('low_sugar'.tr),
                      value: controller.cbLowSugar.value,
                      onChanged: (v) => controller.cbLowSugar.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text('other'.tr),
                      value: controller.cbOther.value,
                      onChanged: (v) => controller.cbOther.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() {
                  if (!controller.cbOther.value) return const SizedBox.shrink();
                  return AppLabeledTextField(
                    controller: controller.otherHospitalizationCtrl,
                    label: 'other_hospitalization_details'.tr,
                  );
                }),

                // 6. TMT Section
                AppFormSectionHeader(title: 'tmt_section'.tr),
                const SizedBox(height: 12),
                _buildRadioRow(
                  title: 'result'.tr,
                  selectedVal: controller.tmtResult,
                  options: ['positive'.tr, 'negative'.tr, 'inconclusive'.tr],
                ),
                AppLabeledTextField(
                  controller: controller.metCtrl,
                  label: 'mets'.tr,
                  keyboardType: TextInputType.number,
                ),
                AppLabeledTextField(
                  controller: controller.tmtOtherCtrl,
                  label: 'tmt_other_notes'.tr,
                ),

                // 7. Blood Tests Checklist
                AppFormSectionHeader(title: 'blood_tests_checklist'.tr),
                const SizedBox(height: 12),
                Obx(() => CheckboxListTile(
                      title: Text('creatinine'.tr),
                      value: controller.cbCreatinine.value,
                      onChanged: (v) => controller.cbCreatinine.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() {
                  if (!controller.cbCreatinine.value) return const SizedBox.shrink();
                  return AppLabeledTextField(
                    controller: controller.creatinineCtrl,
                    label: 'creatinine_value'.tr,
                    keyboardType: TextInputType.number,
                  );
                }),
                Obx(() => CheckboxListTile(
                      title: Text('hba1c'.tr),
                      value: controller.cbHbA1c.value,
                      onChanged: (v) => controller.cbHbA1c.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() {
                  if (!controller.cbHbA1c.value) return const SizedBox.shrink();
                  return Row(
                    children: [
                      Expanded(
                        child: AppLabeledTextField(
                          controller: controller.hba1cCtrl,
                          label: 'hba1c_percent'.tr,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectHbA1cDate(context),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.medicalGray),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Obx(
                              () => Text(
                                controller.hba1cDateStr.value.isEmpty
                                    ? 'select_date'.tr
                                    : controller.hba1cDateStr.value,
                                style: TextStyle(
                                  color: controller.hba1cDateStr.value.isEmpty
                                      ? AppColors.medicalGray
                                      : AppColors.navy,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() => CheckboxListTile(
                      title: Text('total_cholesterol'.tr),
                      value: controller.cbTotalCholesterol.value,
                      onChanged: (v) => controller.cbTotalCholesterol.value = v ?? false,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    )),
                Obx(() {
                  if (!controller.cbTotalCholesterol.value) return const SizedBox.shrink();
                  return AppLabeledTextField(
                    controller: controller.totalCholesterolCtrl,
                    label: 'total_cholesterol_value'.tr,
                    keyboardType: TextInputType.number,
                  );
                }),

                // 8. 2D Echo Section
                AppFormSectionHeader(title: 'echo_section'.tr),
                const SizedBox(height: 12),
                _buildRadioRow(title: 'COA', selectedVal: controller.coa, options: ['yes'.tr, 'no'.tr]),
                _buildRadioRow(title: 'RAS', selectedVal: controller.ras, options: ['yes'.tr, 'no'.tr]),
                _buildRadioRow(title: 'RWMA', selectedVal: controller.rwma, options: ['yes'.tr, 'no'.tr]),
                Obx(() {
                  if (controller.rwma.value != 'yes'.tr && controller.rwma.value != 'Yes') return const SizedBox.shrink();
                  return Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Anterior'),
                        selected: controller.cbAnterior.value,
                        onSelected: (v) => controller.cbAnterior.value = v,
                      ),
                      FilterChip(
                        label: const Text('Lateral'),
                        selected: controller.cbLateral.value,
                        onSelected: (v) => controller.cbLateral.value = v,
                      ),
                      FilterChip(
                        label: const Text('Inferior'),
                        selected: controller.cbInferior.value,
                        onSelected: (v) => controller.cbInferior.value = v,
                      ),
                      FilterChip(
                        label: const Text('Posterior'),
                        selected: controller.cbPosterior.value,
                        onSelected: (v) => controller.cbPosterior.value = v,
                      ),
                    ],
                  );
                }),
                _buildRadioRow(title: 'LVH', selectedVal: controller.lvh, options: ['yes'.tr, 'no'.tr]),
                Obx(() {
                  if (controller.lvh.value != 'yes'.tr && controller.lvh.value != 'Yes') return const SizedBox.shrink();
                  return Row(
                    children: [
                      Expanded(child: AppLabeledTextField(controller: controller.lviddCtrl, label: 'LVIDd')),
                      const SizedBox(width: 12),
                      Expanded(child: AppLabeledTextField(controller: controller.lvpwdCtrl, label: 'LVPWD')),
                    ],
                  );
                }),
                AppLabeledTextField(controller: controller.efCtrl, label: 'EF'),
                Row(
                  children: [
                    Expanded(child: AppLabeledTextField(controller: controller.eCtrl, label: 'E')),
                    const SizedBox(width: 12),
                    Expanded(child: AppLabeledTextField(controller: controller.aCtrl, label: 'A')),
                  ],
                ),
                _buildRadioRow(title: 'LVDd', selectedVal: controller.lvdd, options: ['yes'.tr, 'no'.tr]),
                _buildRadioRow(title: 'RV Dysfunction', selectedVal: controller.rvDysfunction, options: ['yes'.tr, 'no'.tr]),
                _buildRadioRow(title: 'PAH', selectedVal: controller.pah, options: ['yes'.tr, 'no'.tr]),
                Obx(() {
                  if (controller.pah.value != 'yes'.tr && controller.pah.value != 'Yes') return const SizedBox.shrink();
                  return AppLabeledTextField(controller: controller.paspCtrl, label: 'PASP');
                }),
                _buildRadioRow(title: 'Regularization', selectedVal: controller.regularization, options: ['yes'.tr, 'no'.tr]),
                Obx(() {
                  if (controller.regularization.value != 'yes'.tr && controller.regularization.value != 'Yes') return const SizedBox.shrink();
                  return Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('MR'),
                        selected: controller.cbMR.value,
                        onSelected: (v) => controller.cbMR.value = v,
                      ),
                      FilterChip(
                        label: const Text('TR'),
                        selected: controller.cbTR.value,
                        onSelected: (v) => controller.cbTR.value = v,
                      ),
                      FilterChip(
                        label: const Text('AR'),
                        selected: controller.cbAR.value,
                        onSelected: (v) => controller.cbAR.value = v,
                      ),
                    ],
                  );
                }),
                AppLabeledTextField(controller: controller.echoOtherCtrl, label: 'echo_other_notes'.tr),

                // 9. 2 Days MYBSL Section (Hidden when Select Day is default)
                AppFormSectionHeader(title: 'mybsl_section'.tr),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${'select_day'.tr}: ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                    const SizedBox(width: 8),
                    Obx(
                      () => DropdownButton<String>(
                        value: controller.selectedDay.value,
                        items: controller.daysList.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) {
                          if (v != null) controller.selectedDay.value = v;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedDay.value == 'Select Day' || controller.selectedDay.value == 'select_day'.tr) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabeledTextField(
                        controller: controller.morningFastingCtrl,
                        label: 'morning_fasting_bsl'.tr,
                        keyboardType: TextInputType.number,
                      ),
                      _buildRadioRow(
                        title: 'morning_med_taken'.tr,
                        selectedVal: controller.morningMedTaken,
                        options: ['yes'.tr, 'no'.tr],
                      ),
                      Obx(() {
                        if (controller.morningMedTaken.value != 'yes'.tr && controller.morningMedTaken.value != 'Yes') return const SizedBox.shrink();
                        return AppLabeledTextField(controller: controller.morningDoseCtrl, label: 'medicine_name_dose'.tr);
                      }),
                      AppLabeledTextField(
                        controller: controller.postLunchCtrl,
                        label: 'post_lunch_bsl'.tr,
                        keyboardType: TextInputType.number,
                      ),
                      _buildRadioRow(
                        title: 'post_lunch_med_taken'.tr,
                        selectedVal: controller.postLunchMedTaken,
                        options: ['yes'.tr, 'no'.tr],
                      ),
                      Obx(() {
                        if (controller.postLunchMedTaken.value != 'yes'.tr && controller.postLunchMedTaken.value != 'Yes') return const SizedBox.shrink();
                        return AppLabeledTextField(controller: controller.postLunchDoseCtrl, label: 'medicine_name_dose'.tr);
                      }),
                      AppLabeledTextField(
                        controller: controller.atNightCtrl,
                        label: 'night_bsl'.tr,
                        keyboardType: TextInputType.number,
                      ),
                      _buildRadioRow(
                        title: 'night_med_taken'.tr,
                        selectedVal: controller.atNightMedTaken,
                        options: ['yes'.tr, 'no'.tr],
                      ),
                      Obx(() {
                        if (controller.atNightMedTaken.value != 'yes'.tr && controller.atNightMedTaken.value != 'Yes') return const SizedBox.shrink();
                        return AppLabeledTextField(controller: controller.atNightDoseCtrl, label: 'medicine_name_dose'.tr);
                      }),
                    ],
                  );
                }),

                const SizedBox(height: 24),
                // Submit Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.submitQuickForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        controller.isEditMode.value ? 'update_quick_form'.tr : 'submit_quick_form'.tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Obx(() => AppLoadingOverlay(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }
}
