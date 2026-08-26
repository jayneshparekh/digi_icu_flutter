import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_teal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CommonListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final RxString doctorName;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onRefresh;
  final VoidCallback onHome;

  const CommonListAppBar({
    super.key,
    required this.title,
    required this.doctorName,
    required this.searchController,
    required this.onSearch,
    required this.onRefresh,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 64,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Back Button SVG
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: SvgPicture.asset(
                'assets/icons/svg/ic_back.svg',
                colorFilter: const ColorFilter.mode(
                  AppColors.teal,
                  BlendMode.srcIn,
                ),
                width: 26,
                height: 26,
              ),
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 4),
            // Doctor Details Header
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() {
                    return Text(
                      '${'dr_prefix'.tr}${doctorName.value}',
                      style: TextStyle(
                        color: AppColors.coolGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 4),
            // Search Input Field
            Expanded(
              flex: 5,
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.medicalGray),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: onSearch,
                  decoration: InputDecoration(
                    hintText: 'search_patient'.tr,
                    hintStyle: TextStyle(color: AppColors.medicalGray, fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Search Button
            AppTealIconButton(
              assetPath: 'assets/icons/svg/ic_search.svg',
              onTap: () => onSearch(searchController.text),
            ),
            const SizedBox(width: 4),
            // Refresh Button
            AppTealIconButton(
              assetPath: 'assets/icons/svg/ic_refresh.svg',
              onTap: onRefresh,
            ),
            const SizedBox(width: 4),
            // Home Button
            AppTealIconButton(
              assetPath: 'assets/icons/svg/ic_home.svg',
              onTap: onHome,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}


