import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/ambulance_service_request_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_labeled_text_field.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_radio.dart';

class AmbulanceServiceRequestScreen
    extends GetView<AmbulanceServiceRequestController> {
  const AmbulanceServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 64,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/icons/svg/ic_back.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                  width: 26,
                  height: 26,
                ),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ambulance_service'.tr,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Obx(() {
                      final displayName =
                          controller.rxPatientName.value.isNotEmpty
                              ? controller.rxPatientName.value
                              : controller.patientName;
                      if (displayName.isEmpty) return const SizedBox.shrink();
                      return Text(
                        displayName,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: For Whom
                    _buildSectionContainer(
                      title: 'ambulance_service_for_whom'.tr,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return RadioGroup<String>(
                              groupValue: controller.forWhom.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.onForWhomChanged(val);
                                }
                              },
                              child: Row(
                                children: [
                                  _buildRadioItem(
                                    title: 'my_self'.tr,
                                    value: 'Myself',
                                    isSelected:
                                        controller.forWhom.value == 'Myself',
                                    onTap: () =>
                                        controller.onForWhomChanged('Myself'),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildRadioItem(
                                    title: 'other'.tr,
                                    value: 'Other',
                                    isSelected:
                                        controller.forWhom.value == 'Other',
                                    onTap: () =>
                                        controller.onForWhomChanged('Other'),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          Obx(() {
                            if (controller.forWhom.value == 'Myself') {
                              final mobileToShow =
                                  controller.rxPtMobileNo.value.isNotEmpty
                                      ? controller.rxPtMobileNo.value
                                      : controller.ptMobileNo;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'mobile_no_with_val'.trParams({
                                            'mobile': mobileToShow,
                                          }),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            controller.toggleEditMyselfMobile,
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              controller
                                                  .isEditingMyselfMobile
                                                  .value
                                              ? AppColors.error
                                              : AppColors.teal,
                                        ),
                                        child: Text(
                                          controller.isEditingMyselfMobile.value
                                              ? 'cancel'.tr
                                              : 'change'.tr,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (controller
                                      .isEditingMyselfMobile
                                      .value) ...[
                                    const SizedBox(height: 8),
                                    AppLabeledTextField(
                                      controller: controller.mobileController,
                                      label: 'mobile_number'.tr,
                                      hint: 'enter_mobile_number'.tr,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLabeledTextField(
                                    controller: controller.nameController,
                                    label: 'full_name'.tr,
                                    hint: 'enter_full_name'.tr,
                                  ),
                                  const SizedBox(height: 12),
                                  AppLabeledTextField(
                                    controller: controller.mobileController,
                                    label: 'mobile_number'.tr,
                                    hint: 'enter_mobile_number'.tr,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Why do you want ambulance service?
                    _buildSectionContainer(
                      title: 'why_do_you_want_ambulance'.tr,
                      child: AppLabeledTextField(
                        controller: controller.problemController,
                        label: '',
                        hint: 'why_do_you_want_ambulance'.tr,
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 3: For Which Location
                    _buildSectionContainer(
                      title: 'for_which_location_you_want'.tr,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return RadioGroup<String>(
                              groupValue: controller.locationType.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.onLocationTypeChanged(val);
                                }
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildRadioItem(
                                      title: 'registered'.tr,
                                      value: 'RegisterLocation',
                                      isSelected:
                                          controller.locationType.value ==
                                          'RegisterLocation',
                                      onTap: () => controller
                                          .onLocationTypeChanged(
                                            'RegisterLocation',
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildRadioItem(
                                      title: 'current'.tr,
                                      value: 'Current',
                                      isSelected:
                                          controller.locationType.value ==
                                          'Current',
                                      onTap: () =>
                                          controller.onLocationTypeChanged(
                                            'Current',
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildRadioItem(
                                      title: 'other_loc'.tr,
                                      value: 'Other',
                                      isSelected:
                                          controller.locationType.value ==
                                          'Other',
                                      onTap: () =>
                                          controller.onLocationTypeChanged(
                                            'Other',
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                          Obx(() {
                            final isEditable =
                                controller.locationType.value == 'Other';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller.isLocating.value)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.teal,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Detecting GPS location...',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.coolGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                AppLabeledTextField(
                                  controller: controller.addressController,
                                  label: 'address'.tr,
                                  hint: 'enter_address'.tr,
                                  readOnly: !isEditable,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 12),
                                AppLabeledTextField(
                                  controller: controller.pinCodeController,
                                  label: 'pincode'.tr,
                                  hint: 'enter_pincode'.tr,
                                  keyboardType: TextInputType.number,
                                  readOnly: !isEditable,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 4: In How Much Time Do You Want Ambulance?
                    _buildSectionContainer(
                      title: 'in_how_much_time_ambulance'.tr,
                      child: Obx(() {
                        final currentVisitType = controller.visitType.value;
                        return RadioGroup<String>(
                          groupValue: currentVisitType,
                          onChanged: (val) {
                            if (val != null) {
                              controller.onVisitTypeChanged(val);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRadioTileItem(
                                title: 'urgent_within_hour'.tr,
                                value: 'Urgent',
                                isSelected: currentVisitType == 'Urgent',
                                onTap: () =>
                                    controller.onVisitTypeChanged('Urgent'),
                              ),
                              _buildRadioTileItem(
                                title: 'today'.tr,
                                value: 'Today',
                                isSelected: currentVisitType == 'Today',
                                onTap: () =>
                                    controller.onVisitTypeChanged('Today'),
                              ),
                              if (currentVisitType == 'Today')
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    bottom: 8,
                                    top: 4,
                                  ),
                                  child: _buildTimePickerBox(
                                    context: context,
                                    time: controller.selectedTodayTime.value,
                                    onTap: () =>
                                        controller.selectTodayTime(context),
                                  ),
                                ),
                              _buildRadioTileItem(
                                title: 'tomorrow'.tr,
                                value: 'Tomorrow',
                                isSelected: currentVisitType == 'Tomorrow',
                                onTap: () =>
                                    controller.onVisitTypeChanged('Tomorrow'),
                              ),
                              if (currentVisitType == 'Tomorrow')
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    bottom: 8,
                                    top: 4,
                                  ),
                                  child: _buildTimePickerBox(
                                    context: context,
                                    time: controller.selectedTomorrowTime.value,
                                    onTap: () =>
                                        controller.selectTomorrowTime(context),
                                  ),
                                ),
                              _buildRadioTileItem(
                                title: 'schedule_ambulance_visit'.tr,
                                value: 'Schedule ambulance visit',
                                isSelected:
                                    currentVisitType ==
                                    'Schedule ambulance visit',
                                onTap: () => controller.onVisitTypeChanged(
                                  'Schedule ambulance visit',
                                ),
                              ),
                              if (currentVisitType ==
                                  'Schedule ambulance visit')
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    bottom: 8,
                                    top: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildDatePickerBox(
                                          context: context,
                                          date: controller
                                              .selectedScheduleDate
                                              .value,
                                          onTap: () => controller
                                              .selectScheduleDate(context),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildTimePickerBox(
                                          context: context,
                                          time: controller
                                              .selectedScheduleTime
                                              .value,
                                          onTap: () => controller
                                              .selectScheduleTime(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pureBlack.withValues(alpha: 0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Obx(() {
                return AppPrimaryButton(
                  label: 'proceed_and_pay'.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitAndProceed,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildRadioItem({
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadio<String>(value: value),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.navy : AppColors.coolGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTileItem({
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            AppRadio<String>(value: value),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.navy : AppColors.coolGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerBox({
    required BuildContext context,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final timeStr = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'select_time'.tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.medicalGray.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 16, color: AppColors.teal),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                timeStr,
                style: TextStyle(
                  fontSize: 13,
                  color: time != null ? AppColors.navy : AppColors.medicalGray,
                  fontWeight: time != null ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerBox({
    required BuildContext context,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final dateStr = date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'select_date'.tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.medicalGray.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.teal),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                dateStr,
                style: TextStyle(
                  fontSize: 13,
                  color: date != null ? AppColors.navy : AppColors.medicalGray,
                  fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
