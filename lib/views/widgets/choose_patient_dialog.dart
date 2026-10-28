import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../models/response/users/login_response.dart';
import 'app_dialog.dart';
import 'app_network_avatar.dart';

class ChoosePatientDialog extends StatelessWidget {
  final List<LoginDataRes> patients;
  final Function(LoginDataRes selectedPatient) onSelect;

  const ChoosePatientDialog({
    super.key,
    required this.patients,
    required this.onSelect,
  });

  static Future<void> show({
    BuildContext? context,
    required List<LoginDataRes> patients,
    required Function(LoginDataRes selectedPatient) onSelect,
  }) {
    return Get.dialog<void>(
      ChoosePatientDialog(
        patients: patients,
        onSelect: onSelect,
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'select_your_account'.tr,
      body: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: patients.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: AppColors.lightGray,
          ),
          itemBuilder: (context, index) {
            final patient = patients[index];
            final fullName = '${patient.firstName} ${patient.midName} ${patient.surname}'.trim();
            final displayName = fullName.isNotEmpty ? fullName : patient.firstName;

            return InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onSelect(patient);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  children: [
                    // Avatar / Profile Pic using the project's AppNetworkAvatar
                    AppNetworkAvatar(
                      imageUrl: patient.profilePic,
                      size: 48,
                      borderRadius: 24,
                    ),
                    const SizedBox(width: 14),
                    // Patient Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.pureBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            patient.mhcId.isNotEmpty ? patient.mhcId : patient.mobileNo,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.coolGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.teal,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
