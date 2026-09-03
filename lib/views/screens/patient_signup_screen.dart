import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'dart:io';

import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/patient_signup_controller.dart';

class PatientSignUpScreen extends GetView<PatientSignUpController> {
  const PatientSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        title: Text(
          'add_patient'.tr,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Pic Picker Section
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        return CircleAvatar(
                          radius: 55,
                          backgroundColor: AppColors.lightGray,
                          backgroundImage:
                              controller.pickedImagePath.value.isNotEmpty
                              ? FileImage(
                                      File(controller.pickedImagePath.value),
                                    )
                                    as ImageProvider
                              : const AssetImage(
                                  'assets/images/default_user.png',
                                ),
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: () => _showImageSourceDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Name fields
                AppLabeledTextField(
                  controller: controller.firstNameController,
                  label: 'first_name'.tr,
                  hint: 'enter_first_name'.tr,
                ),
                const SizedBox(height: 16),
                AppLabeledTextField(
                  controller: controller.midNameController,
                  label: 'middle_name'.tr,
                  hint: 'enter_middle_name'.tr,
                ),
                const SizedBox(height: 16),
                AppLabeledTextField(
                  controller: controller.lastNameController,
                  label: 'last_name'.tr,
                  hint: 'enter_last_name'.tr,
                ),
                const SizedBox(height: 16),

                // Mobile Number field
                AppLabeledTextField(
                  controller: controller.mobileNoController,
                  label: 'mobile_number'.tr,
                  hint: 'enter_mobile_number'.tr,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Age field
                AppLabeledTextField(
                  controller: controller.ageController,
                  label: 'age'.tr,
                  hint: 'enter_age'.tr,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Email field
                AppLabeledTextField(
                  controller: controller.emailController,
                  label: 'email_address_optional'.tr,
                  hint: 'enter_email_address'.tr,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Gender Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'gender'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coolGray,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return RadioGroup<String>(
                    groupValue: controller.selectedGender.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedGender.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: AppRadioListTile<String>(
                            title: Text('male'.tr),
                            value: 'Male',
                          ),
                        ),
                        Expanded(
                          child: AppRadioListTile<String>(
                            title: Text('female'.tr),
                            value: 'Female',
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Past History Checkboxes Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'past_history'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coolGray,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildPastHistoryCheckbox('hypertension'.tr),
                _buildPastHistoryCheckbox('diabetes'.tr),
                _buildPastHistoryCheckbox('thyroid'.tr),
                _buildPastHistoryCheckbox('family_member_has_it'.tr),
                _buildPastHistoryCheckbox('none'.tr),
                const SizedBox(height: 32),

                // Accept Terms & Conditions checkbox
                Obx(() {
                  return CheckboxListTile(
                    value: controller.acceptTerms.value,
                    onChanged: (val) {
                      if (val != null) controller.acceptTerms.value = val;
                    },
                    activeColor: AppColors.teal,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'accept_terms'.tr,
                      style: TextStyle(fontSize: 14, color: AppColors.navy),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),
                const SizedBox(height: 24),

                // Submit Button
                Obx(() {
                  final isEnabled = controller.acceptTerms.value;
                  return AppPrimaryButton(
                    label: 'submit_upper'.tr,
                    onPressed: isEnabled
                        ? () => controller.registerPatient()
                        : null,
                    backgroundColor: isEnabled
                        ? AppColors.teal
                        : AppColors.medicalGray,
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Obx(() => AppLoadingOverlay(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }

  Widget _buildPastHistoryCheckbox(String label) {
    return Obx(() {
      final isChecked = controller.selectedPastHistory.contains(label);
      return CheckboxListTile(
        title: Text(label),
        value: isChecked,
        activeColor: AppColors.teal,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (val) {
          if (val != null) {
            controller.togglePastHistory(label, val);
          }
        },
      );
    });
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.teal,
                ),
                title: Text('choose_from_gallery'.tr),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.teal),
                title: Text('take_a_photo'.tr),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


