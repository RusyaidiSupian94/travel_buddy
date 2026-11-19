import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class AuthGatePage extends StatelessWidget {
  final VoidCallback onContinue;

  const AuthGatePage({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          return MountainArt(
            style: MountainStyle.auth,
            height: compact ? 690 : 535,
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(compact ? 16 : 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 475),
                  child: _GateCard(onContinue: onContinue),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GateCard extends StatelessWidget {
  final VoidCallback onContinue;

  const _GateCard({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3212384C),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.teal,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Daftar untuk meneruskan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Anda boleh browse sebagai guest.\nLogin atau daftar diperlukan sebelum booking.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onContinue,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.mint,
                    foregroundColor: AppColors.tealDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: const Text('Log masuk'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Daftar akaun'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _AuthInput(hint: 'Email'),
          const SizedBox(height: 9),
          const _AuthInput(hint: 'Kata laluan', obscureText: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text('Log masuk untuk teruskan'),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Maklumat anda akan disimpan dengan selamat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthInput extends StatelessWidget {
  final String hint;
  final bool obscureText;

  const _AuthInput({
    required this.hint,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 11,
      ),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
      ),
    );
  }
}
