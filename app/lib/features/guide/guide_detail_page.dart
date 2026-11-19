import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class GuideDetailPage extends StatelessWidget {
  final VoidCallback onBook;

  const GuideDetailPage({
    super.key,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MountainArt(
            style: MountainStyle.sea,
            height: 184,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'GUIDE · LANGKAWI',
                    style: TextStyle(
                      color: Color(0xFFE2F7F1),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Private island guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Meneroka tempat pilihan · hidden gems',
                    style: TextStyle(
                      color: Color(0xFFD4F2EB),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _VendorCard(),
          const SizedBox(height: 25),
          const Text(
            'Tentang service',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Terokai Langkawi bersama guide tempatan yang mengetahui tempat terbaik, budaya dan lokasi yang kurang sesak.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Termasuk',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const _IncludedLine(text: 'Guide 8 jam · BM & English'),
          const _IncludedLine(text: 'Pick-up dipersetujui'),
          const _IncludedLine(text: 'Cadangan lokasi hidden gem'),
          const SizedBox(height: 22),
          _PricePanel(onBook: onBook),
        ],
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  const _VendorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9F0EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFF7D7BD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFFB07162),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmad Travel Services',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '✓ Verified vendor · ★ 4.9 (126 reviews)',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.muted,
            size: 19,
          ),
        ],
      ),
    );
  }
}

class _IncludedLine extends StatelessWidget {
  final String text;

  const _IncludedLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 15,
            color: AppColors.teal,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricePanel extends StatelessWidget {
  final VoidCallback onBook;

  const _PricePanel({required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5E0CA)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;
          final price = const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HARGA BERMULA',
                style: TextStyle(
                  color: Color(0xFF9A6B2C),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'RM250 / hari',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          );
          final note = const Text(
            'Harga boleh berubah mengikut availability.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10,
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                price,
                const SizedBox(height: 9),
                note,
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _BookButton(onBook: onBook),
                ),
              ],
            );
          }

          return Row(
            children: [
              price,
              const Spacer(),
              note,
              const SizedBox(width: 17),
              _BookButton(onBook: onBook),
            ],
          );
        },
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final VoidCallback onBook;

  const _BookButton({required this.onBook});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onBook,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.coral,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
      ),
      child: const Text('Pilih tarikh & tempah sekarang'),
    );
  }
}
