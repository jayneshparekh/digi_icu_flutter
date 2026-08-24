import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'dart:io';

import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/patient_signup_controller.dart';

class PatientSignUpScreen extends GetView<PatientSignUpController> {
  const PatientSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'add_patient'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                          backgroundColor: Colors.grey.shade200,
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
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
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
                      color: Colors.grey.shade700,
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
                          child: RadioListTile<String>(
                            title: Text('male'.tr),
                            value: 'Male',
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('female'.tr),
                            value: 'Female',
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
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
                      color: Colors.grey.shade700,
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
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'accept_terms'.tr,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),
                const SizedBox(height: 24),

                // Submit Button
                Obx(() {
                  final isEnabled = controller.acceptTerms.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isEnabled
                          ? () => controller.registerPatient()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'submit_upper'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isEnabled
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
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
        activeColor: AppColors.primary,
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
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: Text('choose_from_gallery'.tr),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
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


