import 'package:material_ui/material_ui.dart';

import 'core/api_client.dart';
import 'core/app_page.dart';
import 'core/auth_request.dart';
import 'core/app_session.dart';
import 'core/app_theme.dart';
import 'features/auth/auth_gate_page.dart';
import 'features/booking/booking_draft.dart';
import 'features/checkout/checkout_page.dart';
import 'features/dashboard/role_dashboard_page.dart';
import 'features/guide/guide_detail_page.dart';
import 'features/guide/travel_service.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'shared/widgets/app_shell.dart';
import 'shared/widgets/sweet_alert.dart';

class TravelBuddyApp extends StatefulWidget {
  const TravelBuddyApp({super.key});

  @override
  State<TravelBuddyApp> createState() => _TravelBuddyAppState();
}

class _TravelBuddyAppState extends State<TravelBuddyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final ApiClient _apiClient;
  late Future<List<TravelService>> _servicesFuture;

  AppPage currentPage = AppPage.home;
  AppSession? _session;
  BookingDraft? _booking;
  AppPage _authReturnPage = AppPage.home;
  bool _initiallyRegistering = false;
  DashboardSection? _dashboardSection;

  bool get _isAuthenticated => _session != null;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _servicesFuture = _apiClient.getServices();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  void _retryServices() {
    setState(() {
      _servicesFuture = _apiClient.getServices();
    });
  }

  void _navigate(AppPage page) {
    switch (page) {
      case AppPage.checkout:
        _openCheckout();
        break;
      case AppPage.auth:
        _openAuth(returnPage: currentPage);
        break;
      case AppPage.profile:
        _openProfile();
        break;
      case AppPage.dashboard:
        _openDashboard();
        break;
      case AppPage.home:
      case AppPage.guide:
        setState(() {
          currentPage = page;
        });
        break;
    }
  }

  void _openAuth({
    required AppPage returnPage,
    bool registering = false,
  }) {
    final destination = currentPage == AppPage.auth ? _authReturnPage : returnPage;

    setState(() {
      _authReturnPage = destination;
      _initiallyRegistering = registering;
      currentPage = AppPage.auth;
    });
  }

  void _openCheckout() {
    _booking ??= const BookingDraft.sample();

    if (!_isAuthenticated) {
      _openAuth(returnPage: AppPage.checkout);
      return;
    }

    setState(() {
      currentPage = AppPage.checkout;
    });
  }

  void _openProfile() {
    if (!_isAuthenticated) {
      _openAuth(returnPage: AppPage.profile);
      return;
    }

    setState(() {
      currentPage = AppPage.profile;
    });
  }

  void _openDashboard({DashboardSection? section}) {
    final session = _session;
    if (session == null) {
      _openAuth(returnPage: AppPage.dashboard);
      return;
    }

    if (!session.role.canAccessDashboard) {
      _showSweetAlert(
        type: SweetAlertType.warning,
        title: 'Akses dashboard terhad',
        message: 'Dashboard hanya tersedia untuk Vendor, Admin dan Superadmin.',
      );
      return;
    }

    setState(() {
      _dashboardSection = section;
      currentPage = AppPage.dashboard;
    });
  }

  void _startBooking() {
    _booking = const BookingDraft.sample();
    _openCheckout();
  }

  void _handleAuthenticated(AppSession session) {
    final dashboardDenied =
        _authReturnPage == AppPage.dashboard && !session.role.canAccessDashboard;
    final destination = dashboardDenied ? AppPage.home : _authReturnPage;

    setState(() {
      _session = session;
      _apiClient.setAccessToken(
        session.accessToken,
        expiresAt: session.accessTokenExpiresAt,
      );
      currentPage = destination;
    });

    if (dashboardDenied) {
      _showSweetAlert(
        type: SweetAlertType.warning,
        title: 'Role belum mempunyai akses',
        message:
            'Pilih role Vendor, Admin atau Superadmin untuk membuka dashboard.',
      );
    }
  }

  Future<AppSession> _authenticate(AuthRequest request) {
    if (request.registering) {
      return _apiClient.register(request);
    }

    return _apiClient.login(request);
  }

  void _handleSocialLogin(String provider) {
    _showSweetAlert(
      type: SweetAlertType.info,
      title: '$provider login',
      message:
          'Integrasi $provider memerlukan konfigurasi OAuth dan backend terlebih dahulu.',
    );
  }

  void _showSweetAlert({
    required SweetAlertType type,
    required String title,
    required String message,
  }) {
    final context = _navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    showAppSweetAlert(
      context: context,
      type: type,
      title: title,
      message: message,
    );
  }

  void _handleProfileSaved(AppSession session) {
    setState(() {
      _session = session;
    });

    _showSweetAlert(
      type: SweetAlertType.success,
      title: 'Profil dikemas kini',
      message: 'Maklumat profil anda telah berjaya disimpan.',
    );
  }

  void _logout() {
    setState(() {
      _session = null;
      _apiClient.clearAccessToken();
      _booking = null;
      _dashboardSection = null;
      currentPage = AppPage.home;
    });
  }

  void _handlePayment() {
    if (!_isAuthenticated) {
      _openAuth(returnPage: AppPage.checkout);
      return;
    }

    _showSweetAlert(
      type: SweetAlertType.warning,
      title: 'Payment belum disambungkan',
      message:
          'Anda sudah login. Sambungkan payment gateway untuk transaksi sebenar.',
    );
  }

  void _showRoleMessages(AppRole role) {
    _showSweetAlert(
      type: SweetAlertType.info,
      title: 'Mesej ${role.label}',
      message: 'Inbox untuk role ${role.label} akan tersedia tidak lama lagi.',
    );
  }

  void _showDashboardAction(String action) {
    _showSweetAlert(
      type: SweetAlertType.info,
      title: action,
      message: 'UI dashboard demo. Fungsi sebenar memerlukan backend dan permission role.',
    );
  }

  Widget _pageContent() {
    switch (currentPage) {
      case AppPage.home:
        return HomePage(
          isAuthenticated: _isAuthenticated,
          userName: _session?.displayName,
          onGuide: () => _navigate(AppPage.guide),
          onAuth: () => _openAuth(returnPage: AppPage.home),
          onItinerary: _openCheckout,
          servicesFuture: _servicesFuture,
          onRetryServices: _retryServices,
        );
      case AppPage.guide:
        return GuideDetailPage(
          onBook: _startBooking,
        );
      case AppPage.auth:
        return AuthGatePage(
          initiallyRegistering: _initiallyRegistering,
          onAuthenticated: _handleAuthenticated,
          onAuthenticate: _authenticate,
          onSocialLogin: _handleSocialLogin,
        );
      case AppPage.checkout:
        final session = _session;
        if (session == null) {
          return AuthGatePage(
            initiallyRegistering: _initiallyRegistering,
            onAuthenticated: _handleAuthenticated,
            onAuthenticate: _authenticate,
            onSocialLogin: _handleSocialLogin,
          );
        }

        return CheckoutPage(
          session: session,
          booking: _booking ?? const BookingDraft.sample(),
          onPay: _handlePayment,
        );
      case AppPage.profile:
        final session = _session;
        if (session == null) {
          return AuthGatePage(
            initiallyRegistering: _initiallyRegistering,
            onAuthenticated: _handleAuthenticated,
            onAuthenticate: _authenticate,
            onSocialLogin: _handleSocialLogin,
          );
        }

        return ProfilePage(
          session: session,
          onSave: _handleProfileSaved,
          onLogout: _logout,
          onDashboard: session.role.canAccessDashboard ? _openDashboard : null,
        );
      case AppPage.dashboard:
        final session = _session;
        if (session == null) {
          return AuthGatePage(
            initiallyRegistering: _initiallyRegistering,
            onAuthenticated: _handleAuthenticated,
            onAuthenticate: _authenticate,
            onSocialLogin: _handleSocialLogin,
          );
        }

        if (!session.role.canAccessDashboard) {
          return HomePage(
            isAuthenticated: true,
            userName: session.displayName,
            onGuide: () => _navigate(AppPage.guide),
            onAuth: () => _openAuth(returnPage: AppPage.home),
            onItinerary: _openCheckout,
          servicesFuture: _servicesFuture,
          onRetryServices: _retryServices,
          );
        }

        return RoleDashboardPage(
          session: session,
          initialSection: _dashboardSection,
          onAction: _showDashboardAction,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelBuddy',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: AppTheme.light,
      home: AppShell(
        currentPage: currentPage,
        isAuthenticated: _isAuthenticated,
        canAccessDashboard: _session?.role.canAccessDashboard ?? false,
        role: _session?.role ?? AppRole.customer,
        userName: _session?.displayName,
        onNavigate: _navigate,
        onOpenCheckout: _openCheckout,
        onOpenDashboard: (section) => _openDashboard(section: section),
        onLogin: () => _openAuth(returnPage: currentPage),
        onRegister: () => _openAuth(
          returnPage: currentPage,
          registering: true,
        ),
        onLogout: _logout,
        onProfile: _openProfile,
        onMessages: _showRoleMessages,
        child: _pageContent(),
      ),
    );
  }
}
