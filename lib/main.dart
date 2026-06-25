import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app_router.dart';
import 'core/location/location_service.dart';
import 'core/notifications/notification_service.dart';
import 'core/security/jailbreak_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  final compromised = await JailbreakService().isDeviceCompromised();
  if (compromised) {
    runApp(const _BlockedApp());
    return;
  }

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // Firebase yapılandırılmamış — FCM devre dışı, uygulama çalışmaya devam eder
  }

  runApp(const ProviderScope(child: TeklifApp()));
}

class _BlockedApp extends StatelessWidget {
  const _BlockedApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Bu uygulama güvenliği tehlikeye girmiş cihazlarda çalışmaz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class TeklifApp extends ConsumerStatefulWidget {
  const TeklifApp({super.key});

  @override
  ConsumerState<TeklifApp> createState() => _TeklifAppState();
}

class _TeklifAppState extends ConsumerState<TeklifApp> {
  @override
  void initState() {
    super.initState();
    ref.read(notificationServiceProvider).initialize();
    ref.read(locationServiceProvider).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    ref.read(themeModeNotifierProvider.notifier).init();

    return MaterialApp.router(
      title:        'TeklifApp',
      theme:        AppTheme.light,
      darkTheme:    AppTheme.dark,
      themeMode:    themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
