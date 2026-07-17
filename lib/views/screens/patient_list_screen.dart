import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient_list_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../models/response/doctors/statuswise_patients_response.dart';
import '../widgets/common_list_app_bar.dart';

class PatientListScreen extends GetView<PatientListController> {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonListAppBar(
        title: 'Patient List',
        doctorName: controller.doctorName,
        searchController: controller.searchController,
        onSearch: (val) => controller.fetchPatients(search: val),
        onRefresh: () =>
            controller.fetchPatients(search: controller.searchController.text),
        onHome: () => Get.offAllNamed('/doctor-dashboard'),
      ),
      body: Column(
        children: [
          // Filter Tabs Area
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                // Filter Row 1
                Row(
                  children: [
                    Expanded(child: _buildFilterBtn('Refer')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFilterBtn('Institute')),
                  ],
                ),
                const SizedBox(height: 8), // Filter Row 2
                Row(
                  children: [
                    Expanded(child: _buildFilterBtn('In Process')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFilterBtn('On Hold')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFilterBtn('Served')),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Scrollable Patient List or Loader
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.patients.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.patients.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (controller.patients.isEmpty) {
                return const Center(
                  child: Text(
                    'No patients found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final displayCount =
                  controller.patients.length + (controller.hasMore.value ? 1 : 0);

              return ListView.separated(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12.0),
                itemCount: displayCount,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == controller.patients.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }
                  final patient = controller.patients[index];
                  return _buildPatientCard(patient);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(String statusValue) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == statusValue;
      final Color bg = isSelected
          ? AppColors.warning
          : AppColors.primary;

      String label = '';
      if (statusValue == 'Refer') {
        label = 'Refer (${controller.referCount.value})';
      } else if (statusValue == 'Institute') {
        label = 'Institute';
      } else if (statusValue == 'In Process') {
        label = 'In Process\n(${controller.inProcessCount.value})';
      } else if (statusValue == 'On Hold') {
        label = 'On Hold\n(${controller.onHoldCount.value})';
      } else if (statusValue == 'Served') {
        label = 'Served\n(${controller.servedCount.value})';
      }

      return InkWell(
        onTap: () => controller.changeStatus(statusValue),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPatientCard(PatientAppointmentData patient) {
    final name = '${patient.firstName} ${patient.midName} ${patient.lastName}'
        .trim();
    final genderText = patient.gender.isNotEmpty
        ? patient.gender[0].toUpperCase()
        : '';
    final detailsText = '/ ${patient.age} / ${patient.mhcId} / $genderText';

    // Check if profile picture is valid (not empty/null, and does not contain "default.jpg")
    final hasValidProfilePic =
        patient.profilePic.isNotEmpty &&
        !patient.profilePic.contains('default.jpg');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Columns
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Details (Age, MHC ID, Gender)
                    Text(
                      detailsText,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Phone Number (Directs to Dialer on Click)
                    InkWell(
                      onTap: () => controller.callNumber(patient.mobileNo),
                      child: Text(
                        '${patient.mobileNo} /',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Taluka, District, State details (if present)
                    if (patient.taluka.isNotEmpty ||
                        patient.district.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${patient.taluka} / ${patient.district}'.trim(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ), // Optional Profile Image on the Right
              if (hasValidProfilePic) ...[
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    '${AppConstants.patientImageUrl}${patient.profilePic}',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Appointment details
          Text(
            'Appointment: ${patient.id} / ${patient.bookingDate} / ${patient.bookingTime}',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          // View Details Button (Only button displayed in patient cards now, no refer button)
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () => controller.onViewDetails(patient),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


