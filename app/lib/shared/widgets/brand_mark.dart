import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class BrandMark extends StatelessWidget {
  final double scale;
  final bool showName;

  const BrandMark({
    super.key,
    this.scale = 1,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 23 * scale,
          height: 23 * scale,
          decoration: const BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.navigation_rounded,
            color: Colors.white,
            size: 13 * scale,
          ),
        ),
        if (showName) ...[
          SizedBox(width: 7 * scale),
          Text(
            'travelbuddy',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 12 * scale,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ],
    );
  }
}
