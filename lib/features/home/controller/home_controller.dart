import 'package:get/get.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AdService adService = Get.find<AdService>();

  @override
  void onInit() {
    super.onInit();
    _logDeviceToken();
  }

  Future<void> _logDeviceToken() async {
    final token = await firebaseService.getDeviceToken();
    print('Token Value $token');
  }
}
