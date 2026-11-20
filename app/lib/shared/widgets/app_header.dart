import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'brand_mark.dart';

enum _HeaderAction {
  home,
  guide,
  checkout,
  profile,
  login,
  register,
  logout,
  messages,
}

class AppHeader extends StatelessWidget {
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

  const AppHeader({
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
  });

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
        onMessages();
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
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: _HeaderAction.home,
                              child: Text('Jelajah'),
                            ),
                            const PopupMenuItem(
                              value: _HeaderAction.guide,
                              child: Text('Guide'),
                            ),
                            PopupMenuItem(
                              value: _HeaderAction.checkout,
                              child: Text(
                                isAuthenticated ? 'Tempahan' : 'Itinerary',
                              ),
                            ),
                            if (isAuthenticated) ...[
                              const PopupMenuItem(
                                value: _HeaderAction.profile,
                                child: Text('Profil saya'),
                              ),
                              const PopupMenuItem(
                                value: _HeaderAction.messages,
                                child: Text('Mesej'),
                              ),
                            ],
                            if (!isAuthenticated) ...[
                              const PopupMenuItem(
                                value: _HeaderAction.login,
                                child: Text('Log masuk'),
                              ),
                              const PopupMenuItem(
                                value: _HeaderAction.register,
                                child: Text('Daftar'),
                              ),
                            ] else
                              const PopupMenuItem(
                                value: _HeaderAction.logout,
                                child: Text('Log keluar'),
                              ),
                          ],
                        )
                      else if (isAuthenticated) ...[
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
                          onTap: onMessages,
                        ),
                        const SizedBox(width: 13),
                        PopupMenuButton<_HeaderAction>(
                          tooltip: 'Akaun',
                          onSelected: _selectCompactAction,
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: _HeaderAction.profile,
                              child: Text('Profil saya'),
                            ),
                            PopupMenuItem(
                              value: _HeaderAction.logout,
                              child: Text('Log keluar'),
                            ),
                          ],
                          child: _UserAvatar(userName: userName),
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

  const _UserAvatar({required this.userName});

  @override
  Widget build(BuildContext context) {
    final trimmedName = userName?.trim() ?? '';
    final label = trimmedName.isEmpty
        ? 'A'
        : trimmedName.substring(0, 1).toUpperCase();

    return Container(
      width: 31,
      height: 31,
      decoration: const BoxDecoration(
        color: Color(0xFFF7D7BD),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8D5A51),
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
