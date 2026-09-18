import 'package:get/get.dart';

import '../controller/emvco_generator_controller.dart';

class EmvcoGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmvcoGeneratorController>(() => EmvcoGeneratorController());
  }
}
