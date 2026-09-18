import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/emvco/emvco_crc_generator.dart';

class GenerateCrcController extends GetxController {
  final payloadController = TextEditingController();

  @override
  void onClose() {
    payloadController.dispose();
    super.onClose();
  }

  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text;
    if (text == null || text.isEmpty) {
      return;
    }
    payloadController.text = text;
  }

  void clearInput() {
    payloadController.clear();
  }

  void generateCrc() {
    final result = EmvcoCrcGenerator.generate(payloadController.text);
    if (result.errorMessage != null) {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.primary,
        textColor: Colors.white,
        fontSize: 16,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.qrGeneratedImage,
      arguments: result.output!.completePayload,
    );
  }
}
