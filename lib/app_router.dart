import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/customers/presentation/customer_list_screen.dart';
import 'features/customers/presentation/customer_detail_screen.dart';
import 'features/customers/presentation/customer_form_screen.dart';
import 'features/quotes/presentation/quote_list_screen.dart';
import 'features/quotes/presentation/quote_detail_screen.dart';
import 'features/admin/presentation/admin_screen.dart';
import 'features/admin/presentation/company_settings_screen.dart';
import 'features/admin/presentation/form_templates_screen.dart';
import 'features/auth/presentation/change_password_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/quotes/presentation/create_quote_screen.dart';
import 'shared/widgets/main_scaffold.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) async {
      const storage   = FlutterSecureStorage();
      final repo      = ref.read(authRepositoryProvider);
      final loggedIn  = await repo.isLoggedIn();
      final location  = state.matchedLocation;
      final onLogin   = location == '/login';
      final onChangePw = location == '/change-password';

      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin)  {
        final mustChange = await storage.read(key: AppConstants.mustChangePasswordKey);
        if (mustChange == 'true') return '/change-password';
        return '/dashboard';
      }
      if (loggedIn && !onChangePw) {
        final mustChange = await storage.read(key: AppConstants.mustChangePasswordKey);
        if (mustChange == 'true') return '/change-password';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (_, __) => const ChangePasswordScreen(forced: true),
      ),

      ShellRoute(
        builder: (_, state, child) =>
            MainScaffold(child: child, location: state.matchedLocation),
        routes: [

          // ── Dashboard ─────────────────────────────────────────────
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),

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

          // ── Yönetim ───────────────────────────────────────────────
          GoRoute(
            path: '/admin',
            builder: (_, __) => const AdminScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (_, __) => const CompanySettingsScreen(),
              ),
              GoRoute(
                path: 'templates',
                builder: (_, __) => const FormTemplatesScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
