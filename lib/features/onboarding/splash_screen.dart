import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import '../../core/update/force_update_dialog.dart';
import '../../core/update/force_update_service.dart';
import '../../features/auth/data/auth_repository.dart';
import 'onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // Version check — uses an unauthenticated Dio instance
    final plainDio = Dio(BaseOptions(baseUrl: ref.read(dioProvider).options.baseUrl));
    final updateResult = await ForceUpdateService(plainDio).check();

    if (!mounted) return;
    if (updateResult.forceUpdate) {
      await ForceUpdateDialog.show(
        context,
        message   : updateResult.message,
        updateUrl : updateResult.updateUrl,
        isForced  : true,
      );
      if (!mounted) return;
    } else if (updateResult.updateAvailable) {
      await ForceUpdateDialog.show(
        context,
        message   : updateResult.message,
        updateUrl : updateResult.updateUrl,
        isForced  : false,
      );
      if (!mounted) return;
    }

    final onboardingDone = await isOnboardingDone();
    if (!mounted) return;

    if (!onboardingDone) {
      context.go('/onboarding');
      return;
    }

    final loggedIn = await ref.read(authRepositoryProvider).isLoggedIn();
    if (!mounted) return;
    context.go(loggedIn ? '/quotes' : '/login');
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description_rounded,
                    size: 56, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                'TeklifApp',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Profesyonel Teklif Yönetimi',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(200)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
