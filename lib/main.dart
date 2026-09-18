import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/routes/app_pages.dart';
import 'core/services/notification_service.dart';
import 'core/services/rabbitmq_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_styles.dart';
import 'core/theme/glass_theme.dart';
import 'features/home/binding/home_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await NotificationService().init();
  await Get.putAsync<RabbitMqService>(() => RabbitMqService().init());

  runApp(const MyQrGetxApp());
}

class MyQrGetxApp extends StatelessWidget {
  const MyQrGetxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AttoQR',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          secondary: AppColors.charcoal,
          onSecondary: AppColors.white,
          surface: AppColors.white.withValues(alpha: 0.5),
          onSurface: AppColors.charcoal,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.white),
          actionsIconTheme: IconThemeData(color: AppColors.white),
          titleTextStyle: AppStyles.appBarText,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: GlassTheme.glassFillStrong,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassTheme.borderRadius),
            side: BorderSide(color: GlassTheme.borderColor),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassTheme.borderRadius),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.white,
          labelStyle: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontFamily: 'cambria',
            fontWeight: FontWeight.w100,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontFamily: 'cambria',
            fontWeight: FontWeight.w100,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary.withValues(alpha: GlassTheme.buttonOpacity),
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: GlassTheme.borderColor),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : null,
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.charcoalLight,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: GlassTheme.glassFill,
          labelStyle: AppStyles.formTextStyle,
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
            borderSide: BorderSide(color: GlassTheme.borderColorSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GlassTheme.borderRadiusSmall),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.white),
            elevation: WidgetStateProperty.all(16),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(
              AppColors.charcoal.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      initialBinding: BindingsBuilder(InitialBinding().dependencies),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
