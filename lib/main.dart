import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/doctor_dashboard_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/manage_patients_controller.dart';
import 'controllers/patient_list_controller.dart';
import 'controllers/patient_signup_controller.dart';
import 'controllers/patient_dashboard_controller.dart';
import 'controllers/splash_controller.dart';
import 'controllers/appointment_controller.dart';
import 'controllers/package_category_controller.dart';
import 'controllers/take_appointment_controller.dart';
import 'controllers/primary_care_controller.dart';
import 'controllers/clinical_form_controller.dart';
import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'views/screens/doctor_dashboard_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/manage_patients_screen.dart';
import 'views/screens/patient_dashboard_screen.dart';
import 'views/screens/patient_list_screen.dart';
import 'views/screens/patient_signup_screen.dart';
import 'views/screens/splash_screen.dart';
import 'views/screens/package_category_screen.dart';
import 'views/screens/appointment_screen.dart';
import 'views/screens/take_appointment_screen.dart';
import 'views/screens/primary_care_screen.dart';
import 'views/screens/clinical_form_screen.dart';
import 'views/screens/medical_form_screen.dart';
import 'controllers/medical_form_controller.dart';
import 'controllers/serving_patient_controller.dart';
import 'views/screens/serving_patient_screen.dart';
import 'views/screens/diagnosis_screen.dart';
import 'controllers/diagnosis_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force standard overlays to prevent immersive/full screen behavior
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  // Set the status bar color to teal globally
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.teal, // Teal status bar
      statusBarIconBrightness: Brightness.light, // Light icons for status bar
      systemNavigationBarColor: AppColors.white, // Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.dark, // Dark icons for nav bar
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-assert system bars every time the app comes back to the foreground.
  /// The OS can reset the system UI mode on resume, keyboard events, or
  /// when certain platform views are presented.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digi ICU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
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
        GetPage(
          name: '/serving-patient',
          page: () => const ServingPatientScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ServingPatientController());
          }),
        ),
        GetPage(
          name: '/manage-patients',
          page: () => const ManagePatientsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ManagePatientsController());
          }),
        ),
        GetPage(
          name: '/patient-signup',
          page: () => const PatientSignUpScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PatientSignUpController());
          }),
        ),
        GetPage(
          name: '/patient-dashboard',
          page: () => const PatientDashboardScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PatientDashboardController());
          }),
        ),
        GetPage(
          name: '/appointment',
          page: () => const AppointmentScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AppointmentController());
          }),
        ),
        GetPage(
          name: '/package-categories',
          page: () => const PackageCategoryScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PackageCategoryController());
          }),
        ),
        GetPage(
          name: '/take-appointment',
          page: () => const TakeAppointmentScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => TakeAppointmentController());
          }),
        ),
        GetPage(
          name: '/primary-care',
          page: () => const PrimaryCareScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => PrimaryCareController());
          }),
        ),
        GetPage(
          name: '/clinical-form',
          page: () => const ClinicalFormScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ClinicalFormController());
          }),
        ),
        GetPage(
          name: '/medical-form',
          page: () => const MedicalFormScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MedicalFormController());
          }),
        ),
        GetPage(
          name: '/diagnosis',
          page: () => const DiagnosisScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => DiagnosisController());
          }),
        ),
      ],
    );
  }
}


