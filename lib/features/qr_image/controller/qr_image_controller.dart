import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/theme/app_colors.dart';

class QrImageController extends GetxController {
  final AdService adService = Get.find<AdService>();
  final screenshotController = ScreenshotController();

  late final String qrString;

  @override
  void onInit() {
    super.onInit();
    qrString = Get.arguments as String? ?? '';
  }

  Future<void> shareScreenshot() async {
    try {
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      if (directory == null) {
        _showShareError();
        return;
      }

      final localPath = '${directory.path}/qr_images';
      final value = await screenshotController.captureAndSave(
        localPath,
        delay: const Duration(milliseconds: 200),
        pixelRatio: 2,
      );
      if (value == null) {
        _showShareError();
        return;
      }

      await Share.shareXFiles([XFile(value)]);
    } catch (_) {
      _showShareError();
    }
  }

  void _showShareError() {
    Fluttertoast.showToast(
      msg: 'Unable to share QR image. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }
}
