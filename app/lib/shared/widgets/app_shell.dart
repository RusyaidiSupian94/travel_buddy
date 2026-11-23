import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import '../../core/app_session.dart';
import 'app_footer.dart';
import 'app_header.dart';

class AppShell extends StatelessWidget {
  final AppPage currentPage;
  final bool isAuthenticated;
  final bool canAccessDashboard;
  final AppRole role;
  final String? userName;
  final ValueChanged<AppPage> onNavigate;
  final VoidCallback onOpenCheckout;
  final ValueChanged<DashboardSection> onOpenDashboard;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onLogout;
  final VoidCallback onProfile;
  final ValueChanged<AppRole> onMessages;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentPage,
    required this.isAuthenticated,
    required this.canAccessDashboard,
    required this.role,
    required this.userName,
    required this.onNavigate,
    required this.onOpenCheckout,
    required this.onOpenDashboard,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppHeader(
                      currentPage: currentPage,
                      isAuthenticated: isAuthenticated,
                      canAccessDashboard: canAccessDashboard,
                      role: role,
                      userName: userName,
                      onNavigate: onNavigate,
                      onOpenCheckout: onOpenCheckout,
                      onOpenDashboard: onOpenDashboard,
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
            );
          },
        ),
      ),
    );
  }
}
