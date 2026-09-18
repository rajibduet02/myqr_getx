# MyQR GetX Migration Report

**Original project:** `/Users/raj/AndroidStudioProjects/myqr` (read-only reference)  
**New project:** `/Users/raj/AndroidStudioProjects/myqr_getx`  
**Migration date:** June 26, 2026  
**Architecture:** Feature-first Clean Architecture with GetX (controllers, bindings, routes)

---

## 1. Project Overview

The original **myqr** app is a QR Generator & Scanner focused on **EMVCo merchant QR** standards. It provides:

| Area | Description |
|------|-------------|
| **Scan** | Camera/gallery QR scan, EMVCo TLV parsing, generic QR content detection (URL, WiFi, SMS, etc.) |
| **Generate** | EMVCo merchant QR builder with CRC16, and “Other QR” types |
| **Knowledge Base** | Searchable EMVCo field specification reference |
| **Services** | Firebase Cloud Messaging, local notifications, Google Mobile Ads, RabbitMQ consumer |
| **Navigation** | MaterialApp + named routes (4 routes) |

The new **myqr_getx** project preserves the same screens, flows, business rules, and UI styling while restructuring code under GetX.

---

## 2. Folder Comparison

### Original (`myqr/lib/`)

```
lib/
├── main.dart
├── homescreen.dart
├── scan.dart, generate.dart, otherQR.dart, allfields.dart, qrimage.dart
├── ads/, components/, CRC/, emvco/, gloss ybutton/, models/, notificationservice/
├── routes/, styles/
└── assets/ (under lib/assets/)
```

### New (`myqr_getx/lib/`)

```
lib/
├── main.dart
├── core/
│   ├── constants/app_constants.dart
│   ├── theme/app_styles.dart
│   ├── routes/app_routes.dart, app_pages.dart
│   └── services/ (ad, firebase, notification, rabbitmq)
├── shared/
│   ├── models/ (emv_spec, emv_field, emvco_spec_list)
│   ├── repositories/emvco_repository.dart
│   ├── widgets/ (card_component, glossy_button)
│   └── crc/ (unchanged algorithm logic)
├── features/
│   ├── home/          (controller, binding, view)
│   ├── scan/
│   ├── generate/
│   ├── knowledge_base/
│   ├── emvco_generator/
│   ├── merchant_qr/
│   ├── other_qr/
│   └── qr_image/
└── assets/ (at project root: assets/images, assets/font)
```

---

## 3. Features Completed

| Feature | Status | GetX Components |
|---------|--------|-----------------|
| App bootstrap (Firebase, Ads, RabbitMQ, notifications) | ✅ | `InitialBinding`, services |
| Home (3-tab: Scan / Generate / Knowledge Base) | ✅ | `HomeController`, `HomeBinding`, `HomeView` |
| Scan (camera, gallery, EMVCo parse, search, extract) | ✅ | `ScanController`, `ScanBinding`, `ScanView` |
| Generate hub (EMVCo / Others navigation) | ✅ | `GenerateController`, `GenerateView` |
| Knowledge Base (EMV spec search/list) | ✅ | `KnowledgeBaseController`, `KnowledgeBaseView` |
| EMVCo Generator (Merchant QR + Client placeholder) | ✅ | `EmvcoGeneratorController`, `EmvcoGeneratorView` |
| Merchant QR form (CRC, dialogs, validation toggle) | ✅ | `MerchantQrController`, `MerchantQrView` |
| Other QR types | ✅ | `OtherQrController`, `OtherQrView` |
| QR Image display + share | ✅ | `QrImageController`, `QrImageScreen` |
| Firebase push → navigate to Other QR | ✅ | `FirebaseService` |
| Banner ads on all major screens | ✅ | `AdService` (permanent DI) |

---

## 4. Controllers Created

- `HomeController`
- `ScanController`
- `GenerateController`
- `KnowledgeBaseController`
- `EmvcoGeneratorController`
- `MerchantQrController`
- `OtherQrController`
- `QrImageController`

---

## 5. Bindings Created

- `InitialBinding` (AdService, FirebaseService)
- `HomeBinding`
- `ScanBinding`
- `GenerateBinding`
- `EmvcoGeneratorBinding`
- `OtherQrBinding`
- `QrImageBinding`

---

## 6. Services Created

| Service | Responsibility |
|---------|----------------|
| `AdService` | Google Mobile Ads banner lifecycle |
| `FirebaseService` | FCM token, foreground/background/opened handlers |
| `NotificationService` | Local notification display for FCM |
| `RabbitMqService` | AMQP consumer (same host/credentials as original) |

---

## 7. Repositories Created

| Repository | Responsibility |
|------------|----------------|
| `EmvcoRepository` | EMVCo TLV extraction (`extractEmvcoInformation`), spec lookup |

---

## 8. Models Created / Migrated

| Model | Notes |
|-------|-------|
| `EMVSpec` | Full EMVCo spec entry + `fromJson` / `toJson` / `copyWith` |
| `emvFileds` | Parsed TLV field + serialization helpers |
| `EMVCOSpecList` | Complete spec data (707 lines, migrated verbatim) |
| CRC models | `crc.dart`, `crcParameters.dart`, `crc_std_parameters.dart`, `crc_Helper.dart` |

---

## 9. APIs & Integrations Migrated

| Integration | Original | New |
|-------------|----------|-----|
| Routes | `MaterialApp.onGenerateRoute` | `GetMaterialApp` + `GetPage` |
| Camera scan | `barcode_scan` | `mobile_scanner` (modern equivalent) |
| Gallery decode | `qr_code_tools` | `qr_code_tools` |
| QR render | `qr_flutter` | `qr_flutter` |
| Share | `share` | `share_plus` |
| Ads | `google_mobile_ads` | `google_mobile_ads` |
| Firebase | `firebase_core`, `firebase_messaging` | Same (updated versions) |
| RabbitMQ | `dart_amqp` @ 192.168.0.104:5672 | Same |
| WiFi connect | `wifi_utils` | Toast placeholder (package discontinued for Dart 3) |

**No REST HTTP APIs** exist in the original app; all logic is local + Firebase/AMQP.

---

## 10. Assets Migrated

| Asset | Path in new project |
|-------|---------------------|
| `qr.png`, `qrembed.png`, `asthalogo.jpeg`, `logo.png` | `assets/images/` |
| `cambria.ttf` | `assets/font/` |
| `google-services.json` | `android/app/google-services.json` |

---

## 11. Packages Used (myqr_getx)

```yaml
get, mobile_scanner, qr_flutter, path_provider, image_picker,
qr_code_tools, rxdart, fluttertoast, share_plus, screenshot,
google_mobile_ads, url_launcher, open_settings, font_awesome_flutter,
firebase_core, firebase_messaging, flutter_local_notifications,
dart_amqp, cryptography
```

**SDK:** Dart 3.10+ (original was Dart 2.x)

---

## 12. Navigation Map (Preserved)

```
/ (Home)
 ├── Tab: Scan
 ├── Tab: Generate → /GenerateEMVCO | /OtherQR
 ├── Tab: Knowledge Base
/GenerateEMVCO → Merchant QR | Client QR (under construction)
/GenerateQrImage (argument: QR string)
/OtherQR
```

Firebase deep link: `_id == "GOQR"` → `/OtherQR`

---

## 13. Remaining Manual Work

1. **iOS Firebase:** Copy `GoogleService-Info.plist` from original iOS project if iOS builds are needed.
2. **FlutterFire options:** Run `flutterfire configure` for typed `firebase_options.dart` (recommended for production).
3. **WiFi connect:** Re-integrate a Dart 3–compatible WiFi plugin if required on device (original used hardcoded SSID/password).
4. **RabbitMQ host:** Update `192.168.0.104:5672` when deploying to a new environment.
5. **Ad unit IDs:** Replace test IDs with production AdMob units when publishing.
6. **First Gradle build:** Initial Android build may take several minutes to download dependencies.

---

## 14. Known Issues

| Issue | Impact | Mitigation |
|-------|--------|------------|
| `wifi_utils` not available on Dart 3 | WiFi CONNECT button shows info toast | Add `wifi_iot` or platform channel |
| `barcode_scan` replaced by `mobile_scanner` | Slightly different camera UX | Functionally equivalent scan |
| RabbitMQ connects at startup | May log error if broker unreachable | Wrapped in try/catch (non-blocking) |
| Global `disableValidation` flag | Shared mutable state (same as original) | Preserved for parity |

---

## 15. Recommendations

1. **Environment config:** Move RabbitMQ host, ad unit IDs, and WiFi credentials to `.env` / flavor config.
2. **Extract EMVCo spec:** Consider JSON asset instead of 700-line Dart constructor list.
3. **Unit tests:** Add tests for `EmvcoRepository.extractEmvcoInformation` and CRC generation.
4. **GetX permanent services:** `AdService` is `permanent: true`; dispose banners in `onClose` if hot-restart issues appear.
5. **Client QR tab:** Implement when original feature is defined (currently “Under Construction” in both projects).

---

## 16. Verification

- ✅ `dart analyze lib` — **0 errors** (info/warnings only, mostly legacy naming from CRC/spec ports)
- ✅ Original project **not modified**
- ⏳ Full `flutter build apk` — run locally (first Gradle sync can be slow)

---

## 17. How to Run

```bash
cd /Users/raj/AndroidStudioProjects/myqr_getx
flutter pub get
flutter run
```

---

*Generated as part of the myqr → myqr_getx GetX architecture migration.*
