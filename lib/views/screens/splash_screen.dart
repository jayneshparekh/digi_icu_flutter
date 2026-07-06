import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image(
                image: AssetImage('assets/images/mobile_hypertension_clinic.png'),
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFFFFE0B2), // Light orange background
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 6,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
          ),
        ],
      ),
    );
  }
}
