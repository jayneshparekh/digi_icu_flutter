import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image(
                image: AssetImage(
                  'assets/images/digi_icu_logo.png',
                ),
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: LinearProgressIndicator(
              backgroundColor: AppColors.lightGray,
              // Light orange background
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
              minHeight: 6,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
          ),
        ],
      ),
    );
  }
}


