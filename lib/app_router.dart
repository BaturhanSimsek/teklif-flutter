import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/quotes/presentation/quote_list_screen.dart';
import 'features/quotes/presentation/quote_detail_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/quotes',
    redirect: (context, state) async {
      final repo     = ref.read(authRepositoryProvider);
      final loggedIn = await repo.isLoggedIn();
      final onLogin  = state.matchedLocation == '/login';

      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin)  return '/quotes';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/quotes',
        builder: (_, state) {
          final customerId = state.uri.queryParameters['customerId'] ?? 'demo';
          return QuoteListScreen(customerId: customerId);
        },
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => QuoteDetailScreen(quoteId: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
}
