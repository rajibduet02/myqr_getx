import 'package:get/get.dart';

import '../controller/qr_image_controller.dart';

class QrImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<QrImageController>(() => QrImageController());
  }
}
