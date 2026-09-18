import 'package:get/get.dart';

import '../controller/other_qr_controller.dart';

class OtherQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherQrController>(() => OtherQrController());
  }
}
