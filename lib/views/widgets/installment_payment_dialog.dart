import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
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

    return AppDialog(
      title: data.installments.isNotEmpty ? data.installments : 'installment_payment'.tr,
      confirmLabel: 'pay_now'.tr,
      cancelLabel: 'pay_later'.tr,
      onConfirm: () {
        Get.back();
        onPayNowClick(
          amount,
          data.packageId,
          data.installments,
          data.packageName,
          data.paymentReferenceId,
        );
      },
      onCancel: () => Get.back(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Warning Message
          if (data.warningMsg.isNotEmpty) ...[
            Text(
              data.warningMsg,
              style: const TextStyle(
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
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.navy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Package Name
          Text(
            data.packageName,
            style: const TextStyle(
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.teal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


