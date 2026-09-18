import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/theme/app_styles.dart';

class OtherQrController extends GetxController {
  final AdService adService = Get.find<AdService>();

  final formKey = GlobalKey<FormState>();
  final qrContent = TextEditingController();
  final smsQrContent = TextEditingController();
  final emailCc = TextEditingController();
  final emailBcc = TextEditingController();
  final emailSubject = TextEditingController();
  final emailBody = TextEditingController();

  final selectedQrType = RxnString();

  final qrTypes = const [
    'BIZ CARD',
    'CALENDER EVENT',
    'EMAIL ADDRESS',
    'EMAIL',
    'FACE TIME',
    'GEO LOCATION',
    'PLAIN TEXT',
    'SMS',
    'TELE PHONE',
    'URL',
    'VCARD',
    'WIFI',
  ];

  @override
  void onClose() {
    qrContent.dispose();
    smsQrContent.dispose();
    emailCc.dispose();
    emailBcc.dispose();
    emailSubject.dispose();
    emailBody.dispose();
    super.onClose();
  }

  IconData iconForType(String itemName) {
    switch (itemName) {
      case 'WIFI':
        return Icons.wifi;
      case 'CALENDER EVENT':
        return Icons.event;
      case 'EMAIL ADDRESS':
      case 'EMAIL':
        return Icons.email_outlined;
      case 'FACE TIME':
        return Icons.video_call;
      case 'GEO LOCATION':
        return Icons.location_pin;
      case 'SMS':
        return Icons.sms;
      case 'TELE PHONE':
        return Icons.phone;
      case 'URL':
        return Icons.web;
      default:
        return Icons.text_snippet;
    }
  }

  String getQrContent(String input) {
    switch (selectedQrType.value) {
      case 'TELE PHONE':
        return 'tel:$input';
      case 'SMS':
        return 'sms:$input:${smsQrContent.text}';
      case 'EMAIL ADDRESS':
        return 'mailto:$input';
      case 'EMAIL':
        return 'mailto:$input?cc=${emailCc.text}&bcc=${emailBcc.text}&subject=${emailSubject.text}&body=${emailBody.text}';
      default:
        return input;
    }
  }

  void generateQr() {
    final qr = getQrContent(qrContent.text);
    Get.toNamed(AppRoutes.qrGeneratedImage, arguments: qr);
  }
}
