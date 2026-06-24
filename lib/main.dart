import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'core/security/jailbreak_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final compromised = await JailbreakService().isDeviceCompromised();
  if (compromised) {
    runApp(const _BlockedApp());
    return;
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

class TeklifApp extends ConsumerWidget {
  const TeklifApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    ref.read(themeModeNotifierProvider.notifier).init();

    return MaterialApp.router(
      title:       'TeklifApp',
      theme:       AppTheme.light,
      darkTheme:   AppTheme.dark,
      themeMode:   themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
