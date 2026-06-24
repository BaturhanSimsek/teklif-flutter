import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TeklifApp()));
}

class TeklifApp extends ConsumerWidget {
  const TeklifApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    // İlk açılışta kayıtlı temayı yükle
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
