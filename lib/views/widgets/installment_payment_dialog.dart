import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/response/patients/installment_details_res.dart';

class InstallmentPaymentDialog extends StatelessWidget {
  final InstallmentDetailsRes data;
  final Function(
    String payableAmount,
    String packageId,
    String packageType,
    String packageName,
    String paymentReferenceId,
  ) onPayNowClick;

  const InstallmentPaymentDialog({
    super.key,
    required this.data,
    required this.onPayNowClick,
  });

  @override
  Widget build(BuildContext context) {
    final isThirdInstallment = data.installments == "Third Installment";
    final dueDate = isThirdInstallment ? data.thirdInstallmentDate : data.secondInstallmentDate;
    final amount = isThirdInstallment ? data.thirdInstallmentAmount : data.secondInstallmentAmount;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Title and Cancel button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.installments.isNotEmpty ? data.installments : 'installment_payment'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Warning Message
                if (data.warningMsg.isNotEmpty) ...[
                  Text(
                    data.warningMsg,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],

                // Due Date
                Text(
                  'installment_due_date'.tr.replaceAll('@date', dueDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.navy,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Package Name
                Text(
                  data.packageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Amount
                Text(
                  'amount_rupees'.tr.replaceAll('@amount', amount),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Bottom Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text(
                        'pay_later'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onPayNowClick(
                          amount,
                          data.packageId,
                          data.installments,
                          data.packageName,
                          data.paymentReferenceId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('pay_now'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


