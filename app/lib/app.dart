import 'package:material_ui/material_ui.dart';

import 'core/app_page.dart';
import 'core/app_theme.dart';
import 'features/auth/auth_gate_page.dart';
import 'features/checkout/checkout_page.dart';
import 'features/guide/guide_detail_page.dart';
import 'features/home/home_page.dart';
import 'shared/widgets/app_shell.dart';

class TravelBuddyApp extends StatefulWidget {
  const TravelBuddyApp({super.key});

  @override
  State<TravelBuddyApp> createState() => _TravelBuddyAppState();
}

class _TravelBuddyAppState extends State<TravelBuddyApp> {
  AppPage currentPage = AppPage.home;

  void _navigate(AppPage page) {
    setState(() {
      currentPage = page;
    });
  }

  Widget _pageContent() {
    switch (currentPage) {
      case AppPage.home:
        return HomePage(
          onGuide: () => _navigate(AppPage.guide),
          onAuth: () => _navigate(AppPage.auth),
        );
      case AppPage.guide:
        return GuideDetailPage(
          onBook: () => _navigate(AppPage.auth),
        );
      case AppPage.auth:
        return AuthGatePage(
          onContinue: () => _navigate(AppPage.checkout),
        );
      case AppPage.checkout:
        return const CheckoutPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelBuddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AppShell(
        currentPage: currentPage,
        onNavigate: _navigate,
        child: _pageContent(),
      ),
    );
  }
}
