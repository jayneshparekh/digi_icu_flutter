import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/take_appointment_controller.dart';

class TakeAppointmentScreen extends GetView<TakeAppointmentController> {
  const TakeAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
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
                          Text(
                            'purpose_of_visit'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: controller.problemController,
                            maxLines: 4,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintText: 'purpose_of_visit'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],

                  // Question
                  Text(
                    'where_are_you'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                    SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => controller.bookAppointment(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'book_now'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                color: isSelected ? Colors.red : Colors.transparent,
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
                color: isSelected ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


