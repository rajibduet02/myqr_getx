import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/ad_service.dart';
import '../../../shared/emvco/emvco_qr_validation_result.dart';
import '../../../shared/emvco/emvco_qr_validation_service.dart';
import '../../../shared/models/emv_field.dart';
import '../../../shared/repositories/emvco_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../../../core/theme/app_styles.dart';

class ScanController extends GetxController {
  final EmvcoRepository _repository = EmvcoRepository();
  final AdService adService = Get.find<AdService>();

  final qrTextController = TextEditingController();
  final searchController = TextEditingController();

  final barcode = ''.obs;
  final fieldDetails = <emvFileds>[].obs;
  final tempFieldDetails = <emvFileds>[].obs;
  final showFloatingAction = false.obs;
  final isValidEmvco = false.obs;
  final showNormalQr = false.obs;
  final contentType = ''.obs;
  final isRaw = false.obs;
  final showEmvcoValidationStatus = false.obs;
  final emvcoValidationStatus = Rxn<EmvcoValidationStatus>();
  final showValidation = false.obs;

  final EmvcoQrValidationService _emvcoQrValidationService =
      EmvcoQrValidationService();

  String mainString = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    qrTextController.dispose();
    searchController.dispose();
    super.onClose();
  }

  bool get hasScannedEmvco => isValidEmvco.value;

  bool get shouldDisplayValidationPanel =>
      showValidation.value &&
      showEmvcoValidationStatus.value &&
      emvcoValidationStatus.value != null;

  void setShowValidation(bool value) {
    showValidation.value = value;
  }

  void toggleRaw(bool? value) {
    if (value != null) isRaw.value = value;
  }

  void clearSearch() {
    searchController.text = '';
    fieldDetails.assignAll(tempFieldDetails);
  }

  void searchList(String query) {
    if (tempFieldDetails.isEmpty) {
      tempFieldDetails.assignAll(fieldDetails);
    }

    if (searchController.text.isNotEmpty) {
      final results = tempFieldDetails.where((element) {
        return element.tag.toUpperCase().contains(query.toUpperCase()) ||
            element.value.toUpperCase().contains(query.toUpperCase()) ||
            element.specification.Name.toUpperCase().contains(query.toUpperCase()) ||
            element.specification.Comments.toUpperCase().contains(query.toUpperCase());
      }).toList();

      if (results.isNotEmpty) {
        fieldDetails.assignAll(results);
      } else {
        Fluttertoast.showToast(
          msg: "Search text didn't match anything.Showing Last Search result.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      fieldDetails.assignAll(tempFieldDetails);
    }
  }

  void backToMainData() {
    showFloatingAction.value = false;
    fieldDetails.clear();
    fieldDetails.assignAll(
      _repository.extractEmvcoInformation(mainString, 'Root'),
    );
    searchController.text = '';
  }

  void extractAdditional(String additionalString) {
    try {
      showFloatingAction.value = true;
      tempFieldDetails.clear();
      fieldDetails.assignAll(
        _repository.extractEmvcoInformation(additionalString, '62'),
      );
      searchController.text = '';
    } catch (x) {
      Fluttertoast.showToast(
        msg: x.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.primary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void extractLanguageTemplate(String languageTemplateString) {
    showFloatingAction.value = true;
    tempFieldDetails.clear();
    fieldDetails.assignAll(
      _repository.extractEmvcoInformation(languageTemplateString, '64'),
    );
    searchController.text = '';
  }

  void extractUnreservedTemplate(String unreserved) {
    showFloatingAction.value = true;
    tempFieldDetails.clear();
    fieldDetails.assignAll(
      _repository.extractEmvcoInformation(unreserved, '80-99'),
    );
    searchController.text = '';
  }

  void handleContentType() {
    final text = qrTextController.text.toUpperCase();
    if (text.startsWith('HTTP')) {
      contentType.value = 'URL';
    } else if (text.startsWith('MAILTO:') || text.startsWith('MATMSG:')) {
      contentType.value = 'EMAIL';
    } else if (text.startsWith('TEL:')) {
      contentType.value = 'TELE PHONE';
    } else if (text.startsWith('WIFI:')) {
      contentType.value = 'WIFI';
    } else if (text.startsWith('MECARD:')) {
      contentType.value = 'CONTACT';
    } else if (text.startsWith('BIZCARD:') || text.startsWith('BEGIN:VCARD')) {
      contentType.value = 'VCARD';
    } else if (text.startsWith('SMS:')) {
      contentType.value = 'SMS';
    } else if (text.startsWith('GEO:')) {
      contentType.value = 'GEO LOCATION';
    } else if (text.startsWith('BEGIN:VEVENT')) {
      contentType.value = 'CALENDER EVENT';
    } else {
      contentType.value = 'PLAIN TEXT';
    }
  }

  Future<void> connectToWifi() async {
    Fluttertoast.showToast(
      msg: 'WiFi connect requires platform-specific configuration.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }

  Future<void> launchContent() async {
    final uri = Uri.tryParse(qrTextController.text);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> scanFromCamera() async {
    showFloatingAction.value = false;
    final result = await Get.to<String>(() => const _BarcodeScanPage());
    if (result == null || result.isEmpty) {
      isValidEmvco.value = false;
      showNormalQr.value = true;
      showEmvcoValidationStatus.value = false;
      emvcoValidationStatus.value = null;
      handleContentType();
      return;
    }

    await _processScanResult(result);
  }

  Future<void> _processScanResult(String data) async {
    barcode.value = data;
    qrTextController.text = data;
    mainString = data;
    showEmvcoValidationStatus.value = false;
    emvcoValidationStatus.value = null;

    try {
      tempFieldDetails.clear();
      fieldDetails.assignAll(_repository.extractEmvcoInformation(data, 'Root'));
      searchController.text = '';
      isValidEmvco.value = true;
      showNormalQr.value = false;
      isRaw.value = false;
      await _runEmvcoValidation(data);
    } catch (_) {
      isValidEmvco.value = false;
      showNormalQr.value = true;
      showEmvcoValidationStatus.value = false;
      emvcoValidationStatus.value = null;
      handleContentType();
    }
  }

  Future<void> _runEmvcoValidation(String data) async {
    final result = await _emvcoQrValidationService.validate(data);
    if (!result.isEmvco) {
      showEmvcoValidationStatus.value = false;
      emvcoValidationStatus.value = null;
      return;
    }

    showEmvcoValidationStatus.value = true;
    emvcoValidationStatus.value = result.displayStatus;
  }

  Future<void> scanFromGallery() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        return;
      }

      final data = await QrCodeToolsPlugin.decodeFrom(file.path);
      if (data == null || data.isEmpty) {
        qrTextController.text = '';
        return;
      }

      showFloatingAction.value = false;
      await _processScanResult(data);
    } on FormatException {
      isValidEmvco.value = false;
      showNormalQr.value = true;
      showEmvcoValidationStatus.value = false;
      emvcoValidationStatus.value = null;
    }
  }

  bool shouldShowExtractButton(emvFileds field) {
    if (showFloatingAction.value) return false;
    final tag = int.tryParse(field.tag);
    if (field.tag == '62' || field.tag == '64') return true;
    if (tag != null && tag >= 26 && tag <= 51) return true;
    if (tag != null && tag >= 80 && tag <= 99) return true;
    return false;
  }

  void onExtractTap(emvFileds field) {
    final tag = int.tryParse(field.tag);
    if (field.tag == '62') {
      extractAdditional(field.value);
    } else if (field.tag == '64') {
      extractLanguageTemplate(field.value);
    } else if (tag != null && tag >= 26 && tag <= 51) {
      extractUnreservedTemplate(field.value);
    } else if (tag != null && tag >= 80 && tag <= 99) {
      extractUnreservedTemplate(field.value);
    }
  }
}

class _BarcodeScanPage extends StatefulWidget {
  const _BarcodeScanPage();

  @override
  State<_BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<_BarcodeScanPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      extendBodyBehindAppBar: false,
      appBar: GlassAppBar.build(
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_handled) return;
          final barcodes = capture.barcodes;
          for (final b in barcodes) {
            final raw = b.rawValue;
            if (raw != null && raw.isNotEmpty) {
              _handled = true;
              Get.back(result: raw);
              return;
            }
          }
        },
      ),
    );
  }
}
