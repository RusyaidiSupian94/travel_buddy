import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';

enum SweetAlertType {
  success,
  info,
  warning,
  error,
}

Future<void> showAppSweetAlert({
  required BuildContext context,
  required SweetAlertType type,
  required String title,
  required String message,
  String buttonLabel = 'Tutup',
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Notification',
    barrierColor: const Color(0x990E2738),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _SweetAlertDialog(
        type: type,
        title: title,
        message: message,
        buttonLabel: buttonLabel,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return ScaleTransition(
        scale: curvedAnimation,
        child: child,
      );
    },
  );
}

class _SweetAlertDialog extends StatelessWidget {
  final SweetAlertType type;
  final String title;
  final String message;
  final String buttonLabel;

  const _SweetAlertDialog({
    required this.type,
    required this.title,
    required this.message,
    required this.buttonLabel,
  });

  Color get _accent {
    switch (type) {
      case SweetAlertType.success:
        return AppColors.teal;
      case SweetAlertType.info:
        return AppColors.ink;
      case SweetAlertType.warning:
        return const Color(0xFFE29A45);
      case SweetAlertType.error:
        return AppColors.coral;
    }
  }

  Color get _iconBackground {
    switch (type) {
      case SweetAlertType.success:
        return AppColors.mint;
      case SweetAlertType.info:
        return const Color(0xFFE7EFF5);
      case SweetAlertType.warning:
        return const Color(0xFFFFF0D9);
      case SweetAlertType.error:
        return const Color(0xFFFFE5DF);
    }
  }

  IconData get _icon {
    switch (type) {
      case SweetAlertType.success:
        return Icons.check_rounded;
      case SweetAlertType.info:
        return Icons.info_outline_rounded;
      case SweetAlertType.warning:
        return Icons.priority_high_rounded;
      case SweetAlertType.error:
        return Icons.close_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 25, 24, 21),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x5512384C),
                  blurRadius: 26,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icon,
                    color: _accent,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(buttonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
