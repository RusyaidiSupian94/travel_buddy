import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'app_footer.dart';
import 'app_header.dart';

class AppShell extends StatelessWidget {
  final AppPage currentPage;
  final bool isAuthenticated;
  final String? userName;
  final ValueChanged<AppPage> onNavigate;
  final VoidCallback onOpenCheckout;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onLogout;
  final VoidCallback onProfile;
  final VoidCallback onMessages;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentPage,
    required this.isAuthenticated,
    required this.userName,
    required this.onNavigate,
    required this.onOpenCheckout,
    required this.onLogin,
    required this.onRegister,
    required this.onLogout,
    required this.onProfile,
    required this.onMessages,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(
                currentPage: currentPage,
                isAuthenticated: isAuthenticated,
                userName: userName,
                onNavigate: onNavigate,
                onOpenCheckout: onOpenCheckout,
                onLogin: onLogin,
                onRegister: onRegister,
                onLogout: onLogout,
                onProfile: onProfile,
                onMessages: onMessages,
              ),
              child,
              AppFooter(
                onNavigate: onNavigate,
                onOpenCheckout: onOpenCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
