// Tüm API endpoint path'leri tek yerden yönetilir.
// Her servis kendi iç sınıfına sahiptir — baseUrl ayrı tutuluyor (AppConstants),
// burada yalnızca path segmentleri tanımlanır.

class ApiPaths {
  ApiPaths._();

  // ── Kimlik & Profil ─────────────────────────────────────────────────────────
  static const profile          = '/profile';
  static const profileDevToken  = '/profile/device-token';
  static const users            = '/users';
  static const userLocation     = '/users/me/location';
  static const userLocations    = '/users/locations';
  static String userToggle(String id) => '/users/$id/toggle-active';
  static String userRole(String id)   => '/users/$id/role';
  static const account          = '/account';
  static const accountRestore   = '/account/restore';
  static const appVersion       = '/app-version';

  // ── Kiracı ──────────────────────────────────────────────────────────────────
  static const tenantsRegister  = '/tenants/register';
  static const tenantsSettings  = '/tenants/settings';

  // ── Teklifler ────────────────────────────────────────────────────────────────
  static const quotes           = '/quotes';
  static const quotesKanban     = '/quotes/kanban';
  static const quotesAiGenerate = '/quotes/ai-generate';
  static String quoteById(String id)         => '/quotes/$id';
  static String quoteByCustomer(String cid)  => '/quotes/by-customer/$cid';
  static String quoteRevise(String id)       => '/quotes/$id/revise';
  static String quoteRevisions(String id)    => '/quotes/$id/revisions';
  static String quoteShareLink(String id)    => '/quotes/$id/share-link';
  static String quoteSend(String id)         => '/quotes/$id/send';
  static String quoteStage(String id)        => '/quotes/$id/stage';
  static String quoteApprove(String id)      => '/quotes/$id/approve';
  static String quotePdf(String id)          => '/quotes/$id/pdf';

  // ── Müşteriler ───────────────────────────────────────────────────────────────
  static const customers        = '/customers';
  static String customer(String id) => '/customers/$id';

  // ── Ürünler ──────────────────────────────────────────────────────────────────
  static const products         = '/products';
  static String product(String id) => '/products/$id';

  // ── Kategoriler ──────────────────────────────────────────────────────────────
  static const categories       = '/categories';
  static String category(String id) => '/categories/$id';

  // ── Form Şablonları ──────────────────────────────────────────────────────────
  static const formTemplates    = '/formtemplates';
  static String formTemplate(String id) => '/formtemplates/$id';

  // ── Birimler ─────────────────────────────────────────────────────────────────
  static const units            = '/units';
  static String unit(String id) => '/units/$id';

  // ── Ziyaret Planları ─────────────────────────────────────────────────────────
  static const visitPlans       = '/visit-plans';
  static String visitPlan(String id)       => '/visit-plans/$id';
  static String visitPlanStatus(String id) => '/visit-plans/$id/status';
  static String visitPlanDone(String id)   => '/visit-plans/$id/done';

  // ── Exchange Rate ────────────────────────────────────────────────────────────
  static const exchangeRates    = '/exchange-rates';
}

// AuthService endpoint'leri (baseUrl: AppConstants.authServiceUrl)
class AuthPaths {
  AuthPaths._();
  static const login          = '/login';
  static const register       = '/register';
  static const refresh        = '/refresh';
  static const revoke         = '/revoke';
  static const changePassword = '/change-password';
  static const twoFaSetup     = '/2fa/setup';
  static const twoFaEnable    = '/2fa/enable';
  static const twoFaDisable   = '/2fa/disable';
  static const twoFaVerify    = '/2fa/verify';
  static const adminSetRole   = '/admin/set-role';
}

// ReportingService endpoint'leri (baseUrl: AppConstants.reportingServiceUrl)
class ReportingPaths {
  ReportingPaths._();
  static const dashboard    = '/dashboard';
  static const summary      = '/summary';
  static const audit        = '/audit';
  static const exportExcel  = '/export/excel';
}
