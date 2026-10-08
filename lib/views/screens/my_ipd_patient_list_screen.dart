import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctors/my_ipd_patient_list_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/my_ipd_patient_list_controller.dart';

class MyIpdPatientListScreen extends GetView<MyIpdPatientListController> {
  const MyIpdPatientListScreen({super.key});

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
        title: Text(
          'ipd_patients'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter and Search Container
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              children: [
                // Search Input & Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.medicalGray),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => controller.performSearch(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.navy,
                          ),
                          decoration: InputDecoration(
                            hintText: 'search_ipd_hint'.tr,
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.coolGray,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search Button
                    InkWell(
                      onTap: () => controller.performSearch(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/svg/ic_search.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Refresh Button
                    InkWell(
                      onTap: () => controller.refreshList(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/svg/ic_refresh.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Horizontal Scroll for Status Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusTab('Admitted', 'admitted'.tr),
                      const SizedBox(width: 8),
                      _buildStatusTab('Refer', 'refer'.tr),
                      const SizedBox(width: 8),
                      _buildStatusTab('Death', 'death'.tr),
                      const SizedBox(width: 8),
                      _buildStatusTab('Final Discharge', 'final_discharge'.tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.medicalGray),
          // Patient List / Loading / Empty State
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.patients.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
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
                        fontSize: 15,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (controller.patients.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'no_ipd_patients_found'.trParams({
                        'status': controller.selectedStatus.value,
                      }),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.coolGray,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final displayCount =
                  controller.patients.length +
                  (controller.hasMore.value ? 1 : 0);

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
                        child: CircularProgressIndicator(color: AppColors.teal),
                      ),
                    );
                  }
                  final patient = controller.patients[index];
                  return _buildIpdPatientCard(context, patient);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab(String statusKey, String label) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == statusKey;
      return InkWell(
        onTap: () => controller.changeStatus(statusKey),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
    });
  }

  Widget _buildIpdPatientCard(
    BuildContext context,
    MyIpdPatientListItem patient,
  ) {
    final genderDisplay = patient.gender.toLowerCase() == 'male'
        ? 'M'
        : (patient.gender.toLowerCase() == 'female' ? 'F' : 'O');
    final ageText = patient.age.isNotEmpty ? '${patient.age}/' : '';
    final nameTitle = '${patient.patientName} $ageText$genderDisplay';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.medicalGray),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: QR Code thumbnail + Name & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (patient.qrCode.isNotEmpty) ...[
                GestureDetector(
                  onTap: () => _showQrDialog(context, patient),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      '${AppConstants.qrCodeUrl}${patient.qrCode}',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          color: AppColors.lightGray,
                          child: const Icon(
                            Icons.qr_code,
                            color: AppColors.coolGray,
                            size: 36,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            nameTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(patient.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: MHC ID & IPD ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '${'mhc_id_label'.tr} ',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.coolGray,
                    ),
                    children: [
                      TextSpan(
                        text: patient.mhcId.isNotEmpty ? patient.mhcId : '-',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '${'ipd_id_label'.tr} ',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.coolGray,
                    ),
                    children: [
                      TextSpan(
                        text: patient.ipdId.isNotEmpty ? patient.ipdId : '-',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Row 3: Mobile No & Place
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.callNumber(patient.mobileNo),
                  child: Text.rich(
                    TextSpan(
                      text: '${'mobile_label'.tr} ',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.coolGray,
                      ),
                      children: [
                        TextSpan(
                          text: patient.mobileNo.isNotEmpty
                              ? patient.mobileNo
                              : '-',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '${'place_label'.tr} ',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.coolGray,
                    ),
                    children: [
                      TextSpan(
                        text: patient.currentPlace.isNotEmpty
                            ? patient.currentPlace
                            : '-',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: AppColors.lightGray),
          const SizedBox(height: 8),

          // Row 4: Doctor
          _buildInfoRow(
            'doctor_label'.tr,
            patient.doctorName.isNotEmpty ? patient.doctorName : '-',
          ),
          const SizedBox(height: 6),

          // Row 5: Diagnosis
          _buildInfoRow(
            'diagnosis_label'.tr,
            patient.diagnosis.isNotEmpty ? patient.diagnosis : '-',
          ),
          const SizedBox(height: 6),

          // Row 6: Admit Details
          _buildInfoRow(
            'admit_details_label'.tr,
            'admit_description_format'.trParams({
              'date': patient.created.isNotEmpty ? patient.created : '-',
              'institute': patient.instituteName.isNotEmpty
                  ? patient.instituteName
                  : '-',
            }),
          ),

          // Discharge Draft Info (if present)
          if (patient.preparedBy.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'discharge_draft_info'.trParams({
                'date': patient.draftDate.isNotEmpty ? patient.draftDate : '',
                'by': patient.preparedBy,
              }),
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.error,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Action Buttons: IPD Dashboard and Discharge Summary
          Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  label: 'ipd_dashboard'.tr,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  onPressed: () => controller.onDashboardClick(patient),
                  height: 42,
                  borderRadius: 6,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppPrimaryButton(
                  label: 'discharge_summary'.tr,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  onPressed: () => controller.onDischargeSummaryClick(patient),
                  height: 42,
                  borderRadius: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Discharge Request Button (full width)
          if (patient.status.toLowerCase() != 'discharge requested')
            AppPrimaryButton(
              label: 'discharge_request'.tr,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              onPressed: () => controller.onDischargeRequestClick(patient),
              height: 42,
              borderRadius: 6,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.coolGray,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.navy),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor = AppColors.coolGray;
    String displayStatus = status;

    final lower = status.toLowerCase();
    if (lower == 'admitted') {
      badgeColor = AppColors.success;
    } else if (lower == 'provisional discharge') {
      badgeColor = AppColors.teal;
    } else if (lower == 'refer') {
      badgeColor = AppColors.error;
    } else if (lower == 'death') {
      badgeColor = AppColors.navy;
    } else if (lower == 'final_discharge' ||
        lower == 'final discharge' ||
        lower == 'discharge') {
      badgeColor = AppColors.info;
      displayStatus = 'discharged'.tr;
    } else if (lower == 'discharge requested') {
      badgeColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayStatus,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context, MyIpdPatientListItem patient) {
    AppDialog.show(
      title: 'patient_qr_code'.tr,
      confirmLabel: 'close'.tr,
      onConfirm: () => Get.back(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (patient.qrCode.isNotEmpty)
              Image.network(
                '${AppConstants.qrCodeUrl}${patient.qrCode}',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.qr_code,
                    size: 150,
                    color: AppColors.coolGray,
                  );
                },
              )
            else
              const Icon(
                Icons.qr_code,
                size: 150,
                color: AppColors.coolGray,
              ),
            const SizedBox(height: 12),
            Text(
              '${'mhc_id_label'.tr} ${patient.mhcId}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
