import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import '../../core/app_session.dart';
import 'brand_mark.dart';

enum _HeaderAction {
  home,
  guide,
  checkout,
  dashboard,
  secondaryDashboard,
  profile,
  login,
  register,
  logout,
  messages,
}

class AppHeader extends StatelessWidget {
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

  const AppHeader({
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
  });

  String get _dashboardLabel {
    switch (role) {
      case AppRole.customer:
        return 'Dashboard';
      case AppRole.vendor:
        return 'Vendor workspace';
      case AppRole.admin:
        return 'Admin console';
      case AppRole.superadmin:
        return 'Superadmin console';
    }
  }

  String get _secondaryRoleLabel {
    switch (role) {
      case AppRole.customer:
        return 'Tempahan';
      case AppRole.vendor:
        return 'Bookings';
      case AppRole.admin:
        return 'Approval queue';
      case AppRole.superadmin:
        return 'Users & settings';
    }
  }

  DashboardSection get _primarySection {
    switch (role) {
      case AppRole.vendor:
        return DashboardSection.vendorOverview;
      case AppRole.admin:
      case AppRole.superadmin:
        return DashboardSection.platformOverview;
      case AppRole.customer:
        return DashboardSection.platformOverview;
    }
  }

  DashboardSection get _secondarySection {
    switch (role) {
      case AppRole.vendor:
        return DashboardSection.vendorBookings;
      case AppRole.admin:
        return DashboardSection.approvalQueue;
      case AppRole.superadmin:
        return DashboardSection.systemManagement;
      case AppRole.customer:
        return DashboardSection.platformOverview;
    }
  }

  List<PopupMenuEntry<_HeaderAction>> _compactMenuItems() {
    if (!isAuthenticated) {
      return [
        const PopupMenuItem(
          value: _HeaderAction.home,
          child: Text('Jelajah'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.guide,
          child: Text('Guide'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.checkout,
          child: Text('Itinerary'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.login,
          child: Text('Log masuk'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.register,
          child: Text('Daftar'),
        ),
      ];
    }

    if (role == AppRole.customer) {
      return [
        const PopupMenuItem(
          value: _HeaderAction.home,
          child: Text('Jelajah'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.guide,
          child: Text('Guide'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.checkout,
          child: Text('Tempahan'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.profile,
          child: Text('Profil saya'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.messages,
          child: Text('Mesej'),
        ),
        const PopupMenuItem(
          value: _HeaderAction.logout,
          child: Text('Log keluar'),
        ),
      ];
    }

    return [
      if (canAccessDashboard)
        PopupMenuItem(
          value: _HeaderAction.dashboard,
          child: Text(_dashboardLabel),
        ),
      PopupMenuItem(
        value: _HeaderAction.secondaryDashboard,
        child: Text(_secondaryRoleLabel),
      ),
      const PopupMenuItem(
        value: _HeaderAction.profile,
        child: Text('Profil saya'),
      ),
      const PopupMenuItem(
        value: _HeaderAction.messages,
        child: Text('Mesej'),
      ),
      const PopupMenuItem(
        value: _HeaderAction.logout,
        child: Text('Log keluar'),
      ),
    ];
  }

  List<Widget> _authenticatedNavigation() {
    if (role == AppRole.customer) {
      return [
        _NavItem(
          label: 'Jelajah',
          selected: currentPage == AppPage.home,
          onTap: () => onNavigate(AppPage.home),
        ),
        _NavItem(
          label: 'Guide',
          selected: currentPage == AppPage.guide,
          onTap: () => onNavigate(AppPage.guide),
        ),
        _NavItem(
          label: 'Tempahan',
          selected: currentPage == AppPage.checkout,
          onTap: onOpenCheckout,
        ),
        _NavItem(
          label: 'Mesej',
          selected: false,
          onTap: () => onMessages(role),
        ),
      ];
    }

    return [
      _NavItem(
        label: _dashboardLabel,
        selected: currentPage == AppPage.dashboard,
        onTap: () => onOpenDashboard(_primarySection),
      ),
      _NavItem(
        label: _secondaryRoleLabel,
        selected: false,
        onTap: () => onOpenDashboard(_secondarySection),
      ),
      _NavItem(
        label: 'Mesej',
        selected: false,
        onTap: () => onMessages(role),
      ),
    ];
  }

  void _selectCompactAction(_HeaderAction action) {
    switch (action) {
      case _HeaderAction.home:
        onNavigate(AppPage.home);
        break;
      case _HeaderAction.guide:
        onNavigate(AppPage.guide);
        break;
      case _HeaderAction.checkout:
        onOpenCheckout();
        break;
      case _HeaderAction.dashboard:
        onOpenDashboard(_primarySection);
        break;
      case _HeaderAction.secondaryDashboard:
        onOpenDashboard(_secondarySection);
        break;
      case _HeaderAction.profile:
        onProfile();
        break;
      case _HeaderAction.login:
        onLogin();
        break;
      case _HeaderAction.register:
        onRegister();
        break;
      case _HeaderAction.logout:
        onLogout();
        break;
      case _HeaderAction.messages:
        onMessages(role);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 700;
                  return Row(
                    children: [
                      const BrandMark(),
                      const Spacer(),
                      if (compact)
                        PopupMenuButton<_HeaderAction>(
                          tooltip: 'Menu',
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: AppColors.ink,
                          ),
                          onSelected: _selectCompactAction,
                          itemBuilder: (context) => _compactMenuItems(),
                        )
                      else if (isAuthenticated) ...[
                        ..._authenticatedNavigation(),
                        const SizedBox(width: 13),
                        PopupMenuButton<_HeaderAction>(
                          tooltip: 'Akaun ${role.label}',
                          onSelected: _selectCompactAction,
                          itemBuilder: (context) => [
                            if (canAccessDashboard)
                              PopupMenuItem(
                                value: _HeaderAction.dashboard,
                                child: Text(_dashboardLabel),
                              ),
                            PopupMenuItem(
                              value: _HeaderAction.profile,
                              child: Text('Profil ${role.label}'),
                            ),
                            const PopupMenuItem(
                              value: _HeaderAction.logout,
                              child: Text('Log keluar'),
                            ),
                          ],
                          child: _UserAvatar(
                            userName: userName,
                            role: role,
                          ),
                        ),
                      ] else ...[
                        _NavItem(
                          label: 'Jelajah',
                          selected: currentPage == AppPage.home,
                          onTap: () => onNavigate(AppPage.home),
                        ),
                        _NavItem(
                          label: 'Guide',
                          selected: currentPage == AppPage.guide,
                          onTap: () => onNavigate(AppPage.guide),
                        ),
                        _NavItem(
                          label: 'Itinerary',
                          selected: currentPage == AppPage.checkout,
                          onTap: onOpenCheckout,
                        ),
                        const SizedBox(width: 22),
                        OutlinedButton(
                          onPressed: onLogin,
                          child: const Text('Log masuk'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: onRegister,
                          child: const Text('Daftar'),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? userName;
  final AppRole role;

  const _UserAvatar({
    required this.userName,
    required this.role,
  });

  Color get _backgroundColor {
    switch (role) {
      case AppRole.customer:
        return const Color(0xFFF7D7BD);
      case AppRole.vendor:
        return AppColors.mint;
      case AppRole.admin:
        return AppColors.lavender;
      case AppRole.superadmin:
        return const Color(0xFFFFE7E1);
    }
  }

  Color get _foregroundColor {
    switch (role) {
      case AppRole.customer:
        return const Color(0xFF8D5A51);
      case AppRole.vendor:
        return AppColors.tealDark;
      case AppRole.admin:
        return const Color(0xFF66518D);
      case AppRole.superadmin:
        return const Color(0xFFB95757);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trimmedName = userName?.trim() ?? '';
    final label = trimmedName.isEmpty
        ? 'A'
        : trimmedName.substring(0, 1).toUpperCase();

    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: _foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected ? AppColors.teal : AppColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      child: Text(label),
    );
  }
}
