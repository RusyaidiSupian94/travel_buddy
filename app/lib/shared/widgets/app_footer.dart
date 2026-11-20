import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'brand_mark.dart';

class AppFooter extends StatelessWidget {
  final ValueChanged<AppPage> onNavigate;
  final VoidCallback onOpenCheckout;

  const AppFooter({
    super.key,
    required this.onNavigate,
    required this.onOpenCheckout,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              spacing: 14,
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
                  spacing: 2,
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
                      onTap: onOpenCheckout,
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    );
  }
}
