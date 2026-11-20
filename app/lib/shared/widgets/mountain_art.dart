import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

enum MountainStyle {
  hero,
  sea,
  sunset,
  lavender,
  auth,
}

class MountainArt extends StatelessWidget {
  final MountainStyle style;
  final double height;
  final Widget? child;
  final BorderRadius borderRadius;

  const MountainArt({
    super.key,
    required this.style,
    required this.height,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _MountainPainter(style),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _MountainPainter extends CustomPainter {
  final MountainStyle style;

  const _MountainPainter(this.style);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = _colorsForStyle(style);
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final sunPaint = Paint()..color = _sunColorForStyle(style);
    final radius = math.min(size.width, size.height) * 0.12;
    canvas.drawCircle(
      Offset(size.width * 0.81, size.height * 0.22),
      radius,
      sunPaint,
    );

    final farMountain = Path()
      ..moveTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.58, size.height * 0.39)
      ..lineTo(size.width * 0.72, size.height * 0.78)
      ..lineTo(size.width * 0.82, size.height * 0.55)
      ..lineTo(size.width * 1.08, size.height)
      ..close();
    canvas.drawPath(
      farMountain,
      Paint()..color = _farMountainColorForStyle(style),
    );

    final frontMountain = Path()
      ..moveTo(size.width * 0.02, size.height)
      ..lineTo(size.width * 0.25, size.height * 0.64)
      ..lineTo(size.width * 0.39, size.height * 0.87)
      ..lineTo(size.width * 0.53, size.height * 0.54)
      ..lineTo(size.width * 0.76, size.height)
      ..close();
    canvas.drawPath(
      frontMountain,
      Paint()..color = _frontMountainColorForStyle(style),
    );

    final foreground = Path()
      ..moveTo(0, size.height * 0.9)
      ..lineTo(size.width * 0.18, size.height * 0.72)
      ..lineTo(size.width * 0.33, size.height * 0.92)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..lineTo(size.width * 0.7, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      foreground,
      Paint()..color = _foregroundColorForStyle(style),
    );
  }

  List<Color> _colorsForStyle(MountainStyle value) {
    switch (value) {
      case MountainStyle.hero:
        return const [
          Color(0xFF12364C),
          Color(0xFF137C7E),
          Color(0xFF52CDB7),
        ];
      case MountainStyle.sea:
        return const [
          Color(0xFFBCEBE0),
          Color(0xFF4FA7A0),
          Color(0xFF1D586B),
        ];
      case MountainStyle.sunset:
        return const [
          Color(0xFFF7CE99),
          Color(0xFFE88772),
          Color(0xFF20576B),
        ];
      case MountainStyle.lavender:
        return const [
          Color(0xFFE5E0F7),
          Color(0xFFA48FBE),
          Color(0xFF4C6075),
        ];
      case MountainStyle.auth:
        return const [
          Color(0xFF6E8994),
          Color(0xFF6C9B9D),
          Color(0xFF2E6873),
        ];
    }
  }

  Color _sunColorForStyle(MountainStyle value) {
    if (value == MountainStyle.auth) {
      return const Color(0xFFB9E4D8).withOpacity(0.28);
    }
    return const Color(0xFFFFE4A9);
  }

  Color _farMountainColorForStyle(MountainStyle value) {
    switch (value) {
      case MountainStyle.lavender:
        return const Color(0xFF7775B4).withOpacity(0.76);
      case MountainStyle.sunset:
        return const Color(0xFF41616C).withOpacity(0.82);
      case MountainStyle.auth:
        return const Color(0xFF275E6E).withOpacity(0.62);
      default:
        return const Color(0xFF1E5968).withOpacity(0.78);
    }
  }

  Color _frontMountainColorForStyle(MountainStyle value) {
    switch (value) {
      case MountainStyle.lavender:
        return const Color(0xFF6969AE).withOpacity(0.72);
      case MountainStyle.sunset:
        return const Color(0xFFC56D63).withOpacity(0.72);
      case MountainStyle.auth:
        return const Color(0xFF275D6C).withOpacity(0.66);
      default:
        return const Color(0xFF1D586B).withOpacity(0.78);
    }
  }

  Color _foregroundColorForStyle(MountainStyle value) {
    switch (value) {
      case MountainStyle.lavender:
        return const Color(0xFF555994).withOpacity(0.64);
      case MountainStyle.sunset:
        return const Color(0xFF9C5C58).withOpacity(0.52);
      case MountainStyle.auth:
        return const Color(0xFF245968).withOpacity(0.5);
      case MountainStyle.sea:
        return const Color(0xFF1B6470).withOpacity(0.46);
      default:
        return const Color(0xFF123F53).withOpacity(0.62);
    }
  }

  @override
  bool shouldRepaint(covariant _MountainPainter oldDelegate) {
    return oldDelegate.style != style;
  }
}

class SoftDivider extends StatelessWidget {
  const SoftDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
    );
  }
}
