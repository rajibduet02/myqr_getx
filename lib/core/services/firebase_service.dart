import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'notification_service.dart';

class FirebaseService extends GetxService {
  Future<FirebaseService> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    await _setupMessaging();
    return this;
  }

  Future<void> _setupMessaging() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data['_id'] == 'GOQR') {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.currentRoute != AppRoutes.otherQr) {
          Get.toNamed(AppRoutes.otherQr);
        }
      });
    }

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        NotificationService.createAndDisplayNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print('message.data22 ${message.data['_id']}');
      }
    });
  }

  Future<String?> getDeviceToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
