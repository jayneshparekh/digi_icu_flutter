import 'package:digi_icu_flutter/controllers/chest_pain_other_questions_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChestPainOtherQuestionsScreen
    extends GetView<ChestPainOtherQuestionsController> {
  const ChestPainOtherQuestionsScreen({super.key});

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
                  // Question 1: Acidity pain?
                  Text(
                    'acidity_pain_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.acidityPain.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.acidityPain.value = val;
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

                  // Question 2: Epigastric region just below chest?
                  Text(
                    'pain_epigastric_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.chestRegion.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.chestRegion.value = val;
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

                  // Question 3: Suffered similar pain anytime in past?
                  Text(
                    'suffered_similar_pain_q'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioGroup<String>(
                    groupValue: controller.sufferedPainPast.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.sufferedPainPast.value = val;
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

                  // Question 3.1: Heart pain after visiting doctor (conditional on sufferedPainPast == Yes)
                  if (controller.sufferedPainPast.value == 'Yes') ...[
                    Text(
                      'heart_pain_after_doctor_q'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RadioGroup<String>(
                      groupValue: controller.heartPain.value,
                      onChanged: (val) {
                        if (val != null) {
                          controller.heartPain.value = val;
                        }
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const AppRadio<String>(value: 'Yes'),
                              Text('yes'.tr),
                              const SizedBox(width: 24),
                              const AppRadio<String>(value: 'No'),
                              Text('no'.tr),
                            ],
                          ),
                          Row(
                            children: [
                              const AppRadio<String>(
                                value: "I didn't go to the doctor",
                              ),
                              Text('didnt_go_to_doctor'.tr),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Conditional fields if forWhom == "Other"
                  if (controller.forWhom == 'Other') ...[
                    // Past surgery / attack
                    Text(
                      'past_heart_surgery_q'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RadioGroup<String>(
                      groupValue: controller.pastSurgeryInput.value,
                      onChanged: (val) {
                        if (val != null) {
                          controller.pastSurgeryInput.value = val;
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

                    // Family heart attack
                    Text(
                      'chest_pain_family_attack_q'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RadioGroup<String>(
                      groupValue: controller.familyHTKInput.value,
                      onChanged: (val) {
                        if (val != null) {
                          controller.familyHTKInput.value = val;
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
                  ],

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      label: 'submit'.tr,
                      onPressed: controller.submitFollowUp,
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
