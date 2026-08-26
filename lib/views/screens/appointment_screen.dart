import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/appointment_controller.dart';
import '../../models/response/patients/doctor_list_patient_side_response.dart';
import '../widgets/app_network_avatar.dart';

class AppointmentScreen extends GetView<AppointmentController> {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

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
          final patient = controller.patientName;
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
            onPressed: () {
              // Redirect to Dashboard (main route or splash redirection)
              Get.offAllNamed('/patient-dashboard');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) => controller.filterDoctors(val),
                decoration: InputDecoration(
                  hintText: 'search_doctors'.tr,
                  prefixIcon: Icon(Icons.search, color: AppColors.teal),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Doctor List Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.teal,
                    ),
                  ),
                );
              }

              if (controller.errorMsg.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMsg.value,
                    style: TextStyle(fontSize: 16, color: AppColors.medicalGray),
                  ),
                );
              }

              final list = controller.filteredDoctors;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'no_doctors_found'.tr,
                    style: TextStyle(fontSize: 16, color: AppColors.medicalGray),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: list.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doctor = list[index];
                  return _buildDoctorCard(context, doctor);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorDataModel doctor) {
    final hasReason = doctor.holdReason.isNotEmpty;
    final isAvailable = doctor.availability == 'Available';
    final docName = '${doctor.firstName} ${doctor.lastName}';

    // Button text determination matching Android Adapter logic
    String btnText = 'take_appointment'.tr;
    if (doctor.bookingStatus == '2') {
      btnText = 'i_am_ready'.tr;
    }
    if (doctor.clinicalFormStatus == '0') {
      btnText = 'fill_clinical_form'.tr;
    }
    if (doctor.status == 'Upcoming') {
      btnText = 'join_call'.tr;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.lightGray),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            AppNetworkAvatar(
              imageUrl: doctor.profilePic,
              size: 90,
              borderRadius: 4,
            ),
            const SizedBox(width: 12),

            // Doctor Details & Action
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (doctor.degrees.isNotEmpty) ...[
                    Text(
                      doctor.degrees,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.coolGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${'reg_no'.tr} ${doctor.regNo}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.coolGray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isAvailable ? AppColors.success : AppColors.medicalGray,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAvailable ? 'available'.tr : 'not_available'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: isAvailable ? AppColors.success : AppColors.medicalGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hold Reason / Pending statuses
                  if (hasReason) ...[
                    Row(
                      children: [
                        Text(
                          'on_hold_label'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            doctor.holdReason,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.warning,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ] else if (doctor.clinicalFormStatus == '0') ...[
                    Text(
                      'clinical_form_pending'.tr,
                      style: TextStyle(fontSize: 12, color: AppColors.warning),
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Action Button
                  ElevatedButton(
                    onPressed: () => controller.checkPaymentStatus(doctor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(120, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      btnText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


