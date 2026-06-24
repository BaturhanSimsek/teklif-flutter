import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/customers/presentation/customer_list_screen.dart';
import 'features/customers/presentation/customer_detail_screen.dart';
import 'features/customers/presentation/customer_form_screen.dart';
import 'features/quotes/presentation/quote_list_screen.dart';
import 'features/quotes/presentation/quote_detail_screen.dart';
import 'features/quotes/presentation/create_quote_screen.dart';
import 'shared/widgets/main_scaffold.dart';

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

      ShellRoute(
        builder: (_, state, child) =>
            MainScaffold(child: child, location: state.matchedLocation),
        routes: [

          // ── Teklifler ──────────────────────────────────────────────
          GoRoute(
            path: '/quotes',
            builder: (_, state) => QuoteListScreen(
              customerId: state.uri.queryParameters['customerId'],
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, state) => CreateQuoteScreen(
                  preCustomerId:   state.uri.queryParameters['customerId'],
                  preCustomerName: state.uri.queryParameters['customerName'],
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    QuoteDetailScreen(quoteId: state.pathParameters['id']!),
              ),
            ],
          ),

          // ── Müşteriler ────────────────────────────────────────────
          GoRoute(
            path: '/customers',
            builder: (_, __) => const CustomerListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const CustomerFormScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    CustomerDetailScreen(customerId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
