import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'brand_mark.dart';

class AppHeader extends StatelessWidget {
  final AppPage currentPage;
  final ValueChanged<AppPage> onNavigate;

  const AppHeader({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

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
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 700;
                  final signedIn = currentPage == AppPage.checkout;
                  return Row(
                    children: [
                      const BrandMark(),
                      const Spacer(),
                      if (compact)
                        PopupMenuButton<AppPage>(
                          tooltip: 'Menu',
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: AppColors.ink,
                          ),
                          onSelected: onNavigate,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: AppPage.home,
                              child: Text('Jelajah'),
                            ),
                            const PopupMenuItem(
                              value: AppPage.guide,
                              child: Text('Guide'),
                            ),
                            PopupMenuItem(
                              value: AppPage.checkout,
                              child: Text(signedIn ? 'Tempahan' : 'Itinerary'),
                            ),
                            if (!signedIn)
                              const PopupMenuItem(
                                value: AppPage.auth,
                                child: Text('Log masuk'),
                              ),
                          ],
                        )
                      else if (signedIn) ...[
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
                          onTap: () => onNavigate(AppPage.checkout),
                        ),
                        _NavItem(
                          label: 'Mesej',
                          selected: false,
                          onTap: () => onNavigate(AppPage.checkout),
                        ),
                        const SizedBox(width: 13),
                        const _UserAvatar(),
                      ]
                      else ...[
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
                          onTap: () => onNavigate(AppPage.checkout),
                        ),
                        const SizedBox(width: 22),
                        OutlinedButton(
                          onPressed: () => onNavigate(AppPage.auth),
                          child: const Text('Log masuk'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => onNavigate(AppPage.auth),
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
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      decoration: const BoxDecoration(
        color: Color(0xFFF7D7BD),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'A',
        style: TextStyle(
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
