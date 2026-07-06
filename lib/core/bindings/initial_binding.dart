import 'package:get/get.dart';
import '../../controllers/doctor_dashboard_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/splash_controller.dart';
import '../../services/api/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.put<SplashController>(SplashController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<DoctorDashboardController>(() => DoctorDashboardController());
  }
}
