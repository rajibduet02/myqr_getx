import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart' as app;

class EmvcoGeneratorController extends GetxController {
  final disableValidationObs = false.obs;

  @override
  void onInit() {
    super.onInit();
    disableValidationObs.value = app.disableValidation;
  }

  void toggleValidation(bool? value) {
    if (value == null) return;
    disableValidationObs.value = value;
    app.disableValidation = value;
  }
}
