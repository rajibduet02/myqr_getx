import 'package:get/get.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../scan/binding/scan_binding.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    ScanBinding().dependencies();
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AdService>(AdService()..init(), permanent: true);
    Get.putAsync<FirebaseService>(() => FirebaseService().init());
  }
}
