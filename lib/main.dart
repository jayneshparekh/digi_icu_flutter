import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/doctor_dashboard_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/splash_controller.dart';
import 'controllers/patient_list_controller.dart';
import 'views/screens/patient_list_screen.dart';
import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'views/screens/doctor_dashboard_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force standard overlays to prevent immersive/full screen behavior
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  // Set the status bar color to teal globally
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF00897B), // Teal status bar
    statusBarIconBrightness: Brightness.light, // Light icons for status bar
    systemNavigationBarColor: Colors.white, // Navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark, // Dark icons for nav bar
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digi ICU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
          binding: BindingsBuilder(() {
            Get.put(SplashController());
          }),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => LoginController());
          }),
        ),
        GetPage(
          name: '/doctor-dashboard',
          page: () => const DoctorDashboardScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => DoctorDashboardController());
          }),
        ),
        GetPage(
          name: '/patient-list',
          page: () => const PatientListScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PatientListController());
          }),
        ),
      ],
    );
  }
}
