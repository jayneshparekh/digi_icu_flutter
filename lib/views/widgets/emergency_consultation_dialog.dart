import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyConsultationDialog extends StatelessWidget {
  final String remainPackages;
  final int myCredit;
  final int consultationFee;
  final String userType;
  final RxString selectedOption;
  final bool isLoading;
  final VoidCallback onPay;

  const EmergencyConsultationDialog({
    super.key,
    required this.remainPackages,
    required this.myCredit,
    required this.consultationFee,
    required this.userType,
    required this.selectedOption,
    required this.isLoading,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final hasPackage = remainPackages != "0" && remainPackages.isNotEmpty;

    return AppDialog(
      title: 'payment_txt'.tr,
      confirmLabel: 'pay'.tr,
      isConfirmLoading: isLoading,
      onConfirm: () {
        onPay();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Remaining package card if available
          if (hasPackage) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pureBlack.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'remain_emergency_package'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          remainPackages,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'remain_package_deduct'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Payment option selection
          Obx(() {
            return RadioGroup<String>(
              groupValue: selectedOption.value,
              onChanged: (val) {
                if (val != null) {
                  selectedOption.value = val;
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hasPackage &&
                      (userType == "Leader" ||
                          userType == "Doctor" ||
                          userType == "Patient" ||
                          userType == "Nurse")) ...[
                    AppRadioListTile<String>(
                      value: "Wallet",
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'wallet'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.teal.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '₹ $myCredit',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedOption.value == "Wallet") ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 36, bottom: 8),
                        child: Text(
                          'wallet_credit_deduct'.trParams({'amount': '$consultationFee'}),
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],

                  AppRadioListTile<String>(
                    value: "Package / Online",
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hasPackage
                              ? 'package_dashboard_text'.tr
                              : 'package_online'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                        if (!hasPackage) ...[
                          Text(
                            '₹ $consultationFee',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
