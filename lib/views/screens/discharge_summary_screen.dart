import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/discharge_summary_controller.dart';

class DischargeSummaryScreen extends GetView<DischargeSummaryController> {
  const DischargeSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final genderDisplay =
              controller.gender.value.toLowerCase() == 'male'
                  ? 'M'
                  : (controller.gender.value.toLowerCase() == 'female'
                      ? 'F'
                      : 'O');
          final ageText = controller.age.value.isNotEmpty
              ? '${controller.age.value}/'
              : '';
          final subTitle =
              '${controller.patientName.value} / $ageText$genderDisplay';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'discharge_summary'.tr,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.patientName.value.isNotEmpty)
                Text(
                  subTitle,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          // Top Action Tabs Row (Prepare DS, Upload DS, Death Summary)
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Obx(() {
              final active = controller.activeTab.value;
              return Row(
                children: [
                  Expanded(
                    child: _buildTopTab(
                      label: 'prepare_ds'.tr,
                      isSelected: active == 'prepare',
                      onTap: () => controller.setTab('prepare'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTopTab(
                      label: 'upload_ds'.tr,
                      isSelected: active == 'upload',
                      onTap: () => controller.setTab('upload'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTopTab(
                      label: 'death_summary'.tr,
                      isSelected: active == 'death',
                      onTap: () => controller.setTab('death'),
                    ),
                  ),
                ],
              );
            }),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.medicalGray),

          // Main Tab Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
                );
              }

              final active = controller.activeTab.value;
              if (active == 'prepare') {
                return _buildPrepareDsContent(context);
              } else if (active == 'upload') {
                return Center(
                  child: Text(
                    '${'upload_ds'.tr} (${'coming_soon'.tr})',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.coolGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    '${'death_summary'.tr} (${'coming_soon'.tr})',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.coolGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warning : AppColors.teal,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPrepareDsContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Diagnosis Section
          _buildSectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'diagnosis_label'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.coolGray,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    return Text(
                      controller.diagnosisText.value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/svg/ic_add_circle.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      AppColors.teal,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: controller.openDiagnosisScreen,
                  tooltip: 'diagnosis'.tr,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Patient Condition Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_patient_condition_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return RadioGroup<String>(
                    groupValue: controller.patientCondition.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.patientCondition.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Stable'),
                            const SizedBox(width: 4),
                            Text(
                              'stable'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Unstable'),
                            const SizedBox(width: 4),
                            Text(
                              'unstable'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Past History Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_past_history_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppSpeechInputWidget(
                  controller: controller.pastHistoryController,
                  hintText: 'past_history_hint'.tr,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Symptoms Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_symptoms_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSymptomsGrid(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. At Presentation Complaints Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_at_presentation_complaints_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppSpeechInputWidget(
                  controller: controller.atPresentationComplaintsController,
                  hintText: 'ds_at_presentation_complaints_hint'.tr,
                  maxLines: 3,
                  onChanged: (val) {
                    controller.syncSymptomCheckboxesFromText(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.medicalGray),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSymptomsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;
        final childAspectRatio = constraints.maxWidth > 600 ? 3.5 : 2.6;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: controller.standardSymptoms.length,
          itemBuilder: (context, index) {
            final symptom = controller.standardSymptoms[index];
            return Obx(() {
              final isChecked = controller.selectedSymptoms.contains(symptom);
              return InkWell(
                onTap: () => controller.toggleSymptom(symptom, !isChecked),
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: AppColors.teal,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) {
                        controller.toggleSymptom(symptom, val ?? false);
                      },
                    ),
                    Expanded(
                      child: Text(
                        _getSymptomLabel(symptom),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }

  String _getSymptomLabel(String symptom) {
    switch (symptom) {
      case 'Fever':
        return 'fever'.tr;
      case 'Chest Pain':
        return 'chest_pain'.tr;
      case 'Dyspnea':
        return 'dyspnea'.tr;
      case 'Cough':
        return 'cough'.tr;
      case 'Bodyache':
        return 'bodyache'.tr;
      case 'Giddiness':
        return 'giddiness'.tr;
      case 'Leg Pain':
        return 'leg_pain'.tr;
      case 'Headache':
        return 'headache'.tr;
      case 'Abdominal Pain':
        return 'abdominal_pain'.tr;
      case 'Vomitting':
        return 'vomitting'.tr;
      case 'Loose Motions':
        return 'loose_motions'.tr;
      case 'Asymptomatic':
        return 'asymptomatic'.tr;
      default:
        return symptom;
    }
  }
}
