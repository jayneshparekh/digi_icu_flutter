import 'package:get/get.dart';

import '../../services/api/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiClient as a permanent dependency so it is not cleared on logout (offAllNamed)
    Get.put<ApiClient>(ApiClient(), permanent: true);
  }
}

