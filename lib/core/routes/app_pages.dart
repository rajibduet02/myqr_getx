import 'package:get/get.dart';

import '../../features/emvco_generator/binding/generate_crc_binding.dart';
import '../../features/emvco_generator/view/generate_crc_view.dart';
import '../../features/emvco_generator/binding/emvco_generator_binding.dart';
import '../../features/emvco_generator/view/emvco_generator_view.dart';
import '../../features/home/binding/home_binding.dart';
import '../../features/home/view/home_view.dart';
import '../../features/other_qr/binding/other_qr_binding.dart';
import '../../features/other_qr/view/other_qr_view.dart';
import '../../features/qr_image/binding/qr_image_binding.dart';
import '../../features/qr_image/view/qr_image_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.emvcoGenerator,
      page: () => const EmvcoGeneratorView(),
      binding: EmvcoGeneratorBinding(),
    ),
    GetPage(
      name: AppRoutes.generateCrc,
      page: () => const GenerateCrcView(),
      binding: GenerateCrcBinding(),
    ),
    GetPage(
      name: AppRoutes.qrGeneratedImage,
      page: () => const QrImageScreen(),
      binding: QrImageBinding(),
    ),
    GetPage(
      name: AppRoutes.otherQr,
      page: () => const OtherQrView(),
      binding: OtherQrBinding(),
    ),
  ];
}
