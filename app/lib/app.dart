import 'package:flutter/material.dart';

import 'core/app_page.dart';
import 'core/app_session.dart';
import 'core/app_theme.dart';
import 'features/auth/auth_gate_page.dart';
import 'features/booking/booking_draft.dart';
import 'features/checkout/checkout_page.dart';
import 'features/guide/guide_detail_page.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'shared/widgets/app_shell.dart';

class TravelBuddyApp extends StatefulWidget {
  const TravelBuddyApp({super.key});

  @override
  State<TravelBuddyApp> createState() => _TravelBuddyAppState();
}

class _TravelBuddyAppState extends State<TravelBuddyApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  AppPage currentPage = AppPage.home;
  AppSession? _session;
  BookingDraft? _booking;
  AppPage _authReturnPage = AppPage.home;
  bool _initiallyRegistering = false;

  bool get _isAuthenticated => _session != null;

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

  void _startBooking() {
    _booking = const BookingDraft.sample();
    _openCheckout();
  }

  void _handleAuthenticated(AppSession session) {
    setState(() {
      _session = session;
      currentPage = _authReturnPage;
    });
  }

  void _handleProfileSaved(AppSession session) {
    setState(() {
      _session = session;
    });

    _messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('Maklumat profil berjaya dikemas kini.'),
      ),
    );
  }

  void _logout() {
    setState(() {
      _session = null;
      _booking = null;
      currentPage = AppPage.home;
    });
  }

  void _handlePayment() {
    if (!_isAuthenticated) {
      _openAuth(returnPage: AppPage.checkout);
      return;
    }

    _messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text(
          'Login berjaya. Payment gateway perlu disambungkan untuk transaksi sebenar.',
        ),
      ),
    );
  }

  void _showMessagesPlaceholder() {
    _messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('Mesej customer akan tersedia tidak lama lagi.'),
      ),
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
        );
      case AppPage.guide:
        return GuideDetailPage(
          onBook: _startBooking,
        );
      case AppPage.auth:
        return AuthGatePage(
          initiallyRegistering: _initiallyRegistering,
          onAuthenticated: _handleAuthenticated,
        );
      case AppPage.checkout:
        final session = _session;
        if (session == null) {
          return AuthGatePage(
            initiallyRegistering: _initiallyRegistering,
            onAuthenticated: _handleAuthenticated,
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
          );
        }

        return ProfilePage(
          session: session,
          onSave: _handleProfileSaved,
          onLogout: _logout,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelBuddy',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: AppTheme.light,
      home: AppShell(
        currentPage: currentPage,
        isAuthenticated: _isAuthenticated,
        userName: _session?.displayName,
        onNavigate: _navigate,
        onOpenCheckout: _openCheckout,
        onLogin: () => _openAuth(returnPage: currentPage),
        onRegister: () => _openAuth(
          returnPage: currentPage,
          registering: true,
        ),
        onLogout: _logout,
        onProfile: _openProfile,
        onMessages: _showMessagesPlaceholder,
        child: _pageContent(),
      ),
    );
  }
}
