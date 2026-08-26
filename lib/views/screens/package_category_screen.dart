import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/package_category_controller.dart';
import '../widgets/dashboard_card.dart';

class PackageCategoryScreen extends GetView<PackageCategoryController> {
  const PackageCategoryScreen({super.key});

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
            onPressed: () => Get.offAllNamed('/patient-dashboard'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search packages input
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) => controller.filterCategories(val),
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  prefixIcon: Icon(Icons.search, color: AppColors.teal),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Scrollable layout containing package details card & Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  // General Consultation Card
                  if (controller.packageType == 'General Consultation') ...[
                    _buildOneTimeConsultationCard(context),
                    const SizedBox(height: 16),
                  ],

                  // Package categories list heading
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                      child: Text(
                        'package_categories'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),

                  // Grid of Package Categories
                  Obx(() {
                    if (controller.isLoading.value && controller.categories.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                        ),
                      );
                    }

                    if (controller.errorMsg.value.isNotEmpty) {
                      return Center(
                        child: Text(
                          controller.errorMsg.value,
                          style: TextStyle(color: AppColors.medicalGray, fontSize: 14),
                        ),
                      );
                    }

                    final list = controller.filteredCategories;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'no_package_categories_found'.tr,
                          style: TextStyle(color: AppColors.medicalGray, fontSize: 14),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final category = list[index];
                        return DashboardCard(
                          title: category.name,
                          iconPath: category.image,
                          onTap: () {
                            // Redirect to payment screen for category (to be implemented next)
                            Get.toNamed('/payment', arguments: {
                              'medicalForm': controller.medicalForm,
                              'patientId': controller.patientId,
                              'userName': controller.patientName,
                              'userAge': controller.age,
                              'userGender': controller.gender,
                              'type': controller.userType,
                              'leaderId': controller.leaderId,
                              'packageCategory': category.name,
                              'packageType': controller.packageType,
                              'mData': controller.doctorData,
                            });
                          },
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneTimeConsultationCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.info, Color(0xFF00E5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Section (One time title and Online Pay button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'one_time_consultation'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹ ${controller.consultationCharge}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => controller.initiateOnlinePayment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'online_pay'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pay options buttons: Free, Cash/Wallet
            Obx(() {
              final activeType = controller.selectedPaymentType.value;
              return Row(
                children: [
                  Expanded(
                    child: _buildSelectorButton(
                      text: 'free'.tr,
                      isSelected: activeType == 'free',
                      onTap: () => controller.selectPaymentType('free'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSelectorButton(
                      text: 'cash_wallet'.tr,
                      isSelected: activeType == 'cash',
                      onTap: () => controller.selectPaymentType('cash'),
                    ),
                  ),
                ],
              );
            }),

            // Promo Code field section (Only visible when Free is selected)
            Obx(() {
              if (controller.selectedPaymentType.value != 'free') {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: controller.promoCodeController,
                            decoration: InputDecoration(
                              hintText: 'promo_code'.tr,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => controller.applyPromoCode(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('submit'.tr),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warning : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


