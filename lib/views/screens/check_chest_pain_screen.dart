import 'package:digi_icu_flutter/controllers/check_chest_pain_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CheckChestPainScreen extends GetView<CheckChestPainController> {
  const CheckChestPainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/svg/ic_back.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'chest_pain_check_title'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: AppColors.white),
            onPressed: () => Get.until(
              (route) => route.settings.name == '/patient-dashboard',
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Test for whom?
                  Center(
                    child: Text(
                      'test_for_whom'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<String>(
                    groupValue: controller.forWhom.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.forWhom.value = val;
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Self'),
                            const SizedBox(width: 4),
                            Text(
                              'me'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Other'),
                            const SizedBox(width: 4),
                            Text(
                              'someone_other'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Title
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'answer_6_questions'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(width: 80, height: 2, color: AppColors.teal),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Extra demographic fields if "Someone Other"
                  if (controller.forWhom.value == 'Other') ...[
                    Row(
                      children: [
                        Checkbox(
                          value: controller.dontKnowName.value,
                          activeColor: AppColors.teal,
                          onChanged: (val) =>
                              controller.dontKnowName.value = val ?? false,
                        ),
                        Text(
                          'dont_know_name'.tr,
                          style: const TextStyle(color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (!controller.dontKnowName.value) ...[
                      AppLabeledTextField(
                        controller: controller.fullNameController,
                        label: 'full_name_mandatory'.tr,
                        hint: 'enter_first_name'.tr,
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: AppLabeledTextField(
                            controller: controller.ageController,
                            label: 'age_label'.tr,
                            hint: 'enter_age'.tr,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'gender_label'.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.coolGray,
                                ),
                              ),
                              const SizedBox(height: 6),
                              RadioGroup<String>(
                                groupValue: controller.gender.value,
                                onChanged: (val) {
                                  if (val != null) {
                                    controller.gender.value = val;
                                  }
                                },
                                child: Row(
                                  children: [
                                    const AppRadio<String>(value: 'Male'),
                                    Text(
                                      'male'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 6),
                                    const AppRadio<String>(value: 'Female'),
                                    Text(
                                      'female'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'hypertension_or_diabetes_q'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RadioGroup<String>(
                      groupValue: controller.pastHistoryHTNDM.value,
                      onChanged: (val) {
                        if (val != null) {
                          controller.pastHistoryHTNDM.value = val;
                        }
                      },
                      child: Row(
                        children: [
                          const AppRadio<String>(value: 'Yes'),
                          Text('yes'.tr),
                          const SizedBox(width: 16),
                          const AppRadio<String>(value: 'No'),
                          Text('no'.tr),
                          const SizedBox(width: 16),
                          const AppRadio<String>(value: 'DontKnow'),
                          Text('dont_know'.tr),
                        ],
                      ),
                    ),
                    const Divider(height: 32),
                  ],

                  // Question 1: What kind of pain is it?
                  Text(
                    'what_kind_of_pain'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CheckboxListTile(
                    value: controller.painPressure.value,
                    title: Text('pain_pressure'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        controller.painPressure.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.painFullness.value,
                    title: Text('pain_fullness'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        controller.painFullness.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.painTightness.value,
                    title: Text('pain_tightness'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        controller.painTightness.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.painBurning.value,
                    title: Text('pain_burning'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        controller.painBurning.value = val ?? false,
                  ),
                  const SizedBox(height: 16),

                  // Question 2: Location Central?
                  Text(
                    'location_central_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.locationCentral.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.locationCentral.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        const AppRadio<String>(value: 'Yes'),
                        Text('yes'.tr),
                        const SizedBox(width: 24),
                        const AppRadio<String>(value: 'No'),
                        Text('no'.tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question 3: Pain going to left arm / jaw / back?
                  Text(
                    'pain_going_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.painGoing.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.painGoing.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        const AppRadio<String>(value: 'Yes'),
                        Text('yes'.tr),
                        const SizedBox(width: 24),
                        const AppRadio<String>(value: 'No'),
                        Text('no'.tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question 4: Duration continuous > 5 mins?
                  Text(
                    'duration_pain_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.durationMoreThan5.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.durationMoreThan5.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        const AppRadio<String>(value: 'Yes'),
                        Text('yes'.tr),
                        const SizedBox(width: 24),
                        const AppRadio<String>(value: 'No'),
                        Text('no'.tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question 5: Associated Symptoms
                  Text(
                    'do_you_have_symptoms_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CheckboxListTile(
                    value: controller.symptomNausea.value,
                    title: Text('symptom_nausea_vomiting'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    enabled: !controller.symptomsNone.value,
                    onChanged: (val) =>
                        controller.symptomNausea.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.symptomFatigue.value,
                    title: Text('symptom_fatigue_syncope'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    enabled: !controller.symptomsNone.value,
                    onChanged: (val) =>
                        controller.symptomFatigue.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.symptomDifficultyBreathing.value,
                    title: Text('symptom_difficulty_breathing'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    enabled: !controller.symptomsNone.value,
                    onChanged: (val) =>
                        controller.symptomDifficultyBreathing.value =
                            val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.symptomSweating.value,
                    title: Text('symptom_sweating'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    enabled: !controller.symptomsNone.value,
                    onChanged: (val) =>
                        controller.symptomSweating.value = val ?? false,
                  ),
                  CheckboxListTile(
                    value: controller.symptomsNone.value,
                    title: Text('symptoms_none'.tr),
                    activeColor: AppColors.teal,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: controller.onSymptomsNoneChanged,
                  ),
                  const SizedBox(height: 16),

                  // Question 6: Pain after exertion?
                  Text(
                    'pain_after_exertion_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.painAfterExertion.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.painAfterExertion.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        const AppRadio<String>(value: 'Yes'),
                        Text('yes'.tr),
                        const SizedBox(width: 24),
                        const AppRadio<String>(value: 'No'),
                        Text('no'.tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      label: 'submit'.tr,
                      onPressed: controller.submitAssessment,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Disclaimer
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.coolGray,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'Disclaimer - ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'This analysis is generated solely based on the answers you provided and data saved in our database. The reference scientific paper for risk generation is ',
                        ),
                        TextSpan(
                          text:
                              'https://doi.org/10.1590/1516-3180.2018.0238101218',
                          style: const TextStyle(
                            color: AppColors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = controller.openDisclaimerUrl,
                        ),
                        const TextSpan(text: '. Please review it if needed.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            AppLoadingOverlay(isLoading: controller.isLoading.value),
          ],
        );
      }),
    );
  }
}
