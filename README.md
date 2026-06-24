# TeklifApp Flutter

## Kurulum

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## API Adresi

`lib/core/constants/app_constants.dart` içinde `baseUrl`:
- Android emülatör: `http://10.0.2.2:5074/api/v1`
- iOS simülatör / fiziksel cihaz: `http://<PC-IP>:5074/api/v1`

## Mimari

```
lib/
  core/
    api/         → Dio client + interceptor (JWT auto-attach)
    constants/   → AppConstants
    theme/       → Material 3 tema
  features/
    auth/        → Login, token yönetimi
    quotes/      → Teklif listesi + detay + onay + revizyon
    customers/   → Müşteri listesi (gelecek)
    form_templates/ → Dinamik form şablonları (gelecek)
  shared/
    widgets/     → Ortak widgetlar
  app_router.dart → GoRouter (auth guard dahil)
  main.dart
```
