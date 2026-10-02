import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal dialog displaying the calculated chest pain risk score,
/// risk categorization, advisory guidance, and action CTAs.
class ChestPainScoreDialog extends StatelessWidget {
  final int score;
  final VoidCallback onEmergencyConsultation;
  final VoidCallback onSharePdf;
  final VoidCallback onOk;

  const ChestPainScoreDialog({
    super.key,
    required this.score,
    required this.onEmergencyConsultation,
    required this.onSharePdf,
    required this.onOk,
  });

  static Future<void> show({
    required int score,
    required VoidCallback onEmergencyConsultation,
    required VoidCallback onSharePdf,
    required VoidCallback onOk,
  }) {
    return AppDialog.show(
      title: 'chest_pain_check_title'.tr,
      body: ChestPainScoreDialog(
        score: score,
        onEmergencyConsultation: onEmergencyConsultation,
        onSharePdf: onSharePdf,
        onOk: onOk,
      ),
      showCloseButton: true,
    );
  }

  String _getRiskLevel() {
    if (score >= 7) {
      return 'score_low_risk'.tr;
    } else if (score == 5 || score == 6) {
      return 'score_moderate_risk'.tr;
    } else if (score == 3 || score == 4) {
      return 'score_high_risk'.tr;
    } else {
      return 'score_very_high_risk'.tr;
    }
  }

  Color _getRiskColor() {
    if (score >= 7) {
      return AppColors.success;
    } else if (score == 5 || score == 6) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  String _getRiskMessage() {
    if (score >= 7) {
      return 'score_msg_7_plus'.tr;
    } else if (score == 5 || score == 6) {
      return 'score_msg_5_6'.tr;
    } else if (score == 3 || score == 4) {
      return 'score_msg_3_4'.tr;
    } else {
      return 'score_msg_0_2'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskLevel = _getRiskLevel();
    final riskColor = _getRiskColor();
    final riskMessage = _getRiskMessage();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Score & Risk Badge Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: riskColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: riskColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                'your_score'.trParams({
                  'score': score.toString(),
                  'risk': riskLevel,
                }),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Advice Content
        Container(
          constraints: const BoxConstraints(maxHeight: 280),
          child: SingleChildScrollView(
            child: Text(
              riskMessage,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.navy,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Action Buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPrimaryButton(
              label: 'emergency_consultation'.tr,
              onPressed: () {
                Get.back();
                onEmergencyConsultation();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppSecondaryButton(
                    label: 'share_report'.tr,
                    onPressed: () {
                      onSharePdf();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'okay'.tr,
                    onPressed: () {
                      Get.back();
                      onOk();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
