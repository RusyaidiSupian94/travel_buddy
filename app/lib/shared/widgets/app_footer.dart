import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'brand_mark.dart';

class AppFooter extends StatelessWidget {
  final ValueChanged<AppPage> onNavigate;

  const AppFooter({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 14,
              spacing: 20,
              children: [
                const BrandMark(scale: 0.9),
                const Text(
                  'Plan less. Experience more.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    _FooterLink(
                      label: 'Jelajah',
                      onTap: () => onNavigate(AppPage.home),
                    ),
                    _FooterLink(
                      label: 'Guide',
                      onTap: () => onNavigate(AppPage.guide),
                    ),
                    _FooterLink(
                      label: 'Itinerary',
                      onTap: () => onNavigate(AppPage.checkout),
                    ),
                    const _FooterLink(label: 'Bantuan'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FooterLink({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    );
  }
}
