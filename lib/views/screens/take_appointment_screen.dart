import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/take_appointment_controller.dart';

class TakeAppointmentScreen extends GetView<TakeAppointmentController> {
  const TakeAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final loggedIn = controller.loggedInUserName.value;
          final patient = controller.userName;
          final subtitle = (loggedIn.isNotEmpty && patient.isNotEmpty)
              ? 'Dr. $loggedIn ($patient)'
              : loggedIn.isNotEmpty ? 'Dr. $loggedIn' : patient;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'book_appointment'.tr,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: AppColors.white),
            onPressed: () => Get.offAllNamed('/patient-dashboard'),
          ),
        ],
      ),
      body: Obx(() {
        final activePlace = controller.selectedPlace.value;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Conditionally show problem explanation
                  if (controller.speciality.isNotEmpty || controller.isFromDoctorHomeService) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabeledTextField(
                            controller: controller.problemController,
                            label: 'purpose_of_visit'.tr,
                            hint: 'purpose_of_visit'.tr,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],

                  // Question
                  Text(
                    'where_are_you'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Options Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLocationOption(
                        label: 'home'.tr,
                        imagePath: 'assets/images/house.png',
                        isSelected: activePlace == 'Home',
                        onTap: () => controller.selectPlace('Home'),
                      ),
                      _buildLocationOption(
                        label: 'office'.tr,
                        imagePath: 'assets/images/building.png',
                        isSelected: activePlace == 'Office',
                        onTap: () => controller.selectPlace('Office'),
                      ),
                      _buildLocationOption(
                        label: 'outdoor'.tr,
                        imagePath: 'assets/images/warehouse.png',
                        isSelected: activePlace == 'Outdoor',
                        onTap: () => controller.selectPlace('Outdoor'),
                      ),
                      _buildLocationOption(
                        label: 'clinic_home_visit'.tr,
                        imagePath: 'assets/images/health_clinic.png',
                        isSelected: activePlace == 'Clinic',
                        onTap: () => controller.selectPlace('Clinic'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Book Now Button (Shown only when a place is selected)
                  if (activePlace.isNotEmpty)
                    AppPrimaryButton(
                      label: 'book_now'.tr,
                      onPressed: () => controller.bookAppointment(),
                      width: 160,
                    ),
                ],
              ),
            ),
            AppLoadingOverlay(isLoading: controller.isLoading.value),
          ],
        );
      }),
    );
  }

  Widget _buildLocationOption({
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.error : Colors.transparent,
                width: 3,
              ),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.error : AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


