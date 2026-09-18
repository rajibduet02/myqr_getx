import 'package:get/get.dart';

import '../controller/generate_crc_controller.dart';

class GenerateCrcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateCrcController>(() => GenerateCrcController());
  }
}
