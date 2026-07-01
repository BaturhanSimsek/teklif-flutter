// Tüm Go Router path'leri tek yerden yönetilir.
// context.go(AppRoutes.login) veya context.push(AppRoutes.quoteDetail(id)) şeklinde kullanılır.

class AppRoutes {
  AppRoutes._();

  static const splash        = '/';
  static const login         = '/login';
  static const register      = '/register';
  static const twoFaVerify   = '/2fa-verify';
  static const changePassword = '/change-password';

  static const dashboard     = '/dashboard';
  static const kanban        = '/kanban';
  static const reports       = '/reports';
  static const profile       = '/profile';

  static const quotes        = '/quotes';
  static const quoteNew      = '/quotes/new';
  static String quoteDetail(String id)    => '/quotes/$id';
  static String quoteRevisions(String id) => '/quotes/$id/revisions';
  static String quoteEdit(String id)      => '/quotes/$id/edit';

  static const customers     = '/customers';
  static const customerNew   = '/customers/new';
  static String customerDetail(String id) => '/customers/$id';

  static const visitPlans    = '/visit-plans';
  static const onboarding    = '/onboarding';
  static const search        = '/search';

  static const admin             = '/admin';
  static const adminProducts     = '/admin/products';
  static const adminCategories   = '/admin/categories';
  static const adminUnits        = '/admin/units';
  static const adminTemplates    = '/admin/templates';
  static const adminSettings     = '/admin/settings';
}
