import 'package:material_ui/material_ui.dart';

import 'package:flutter_svg/flutter_svg.dart';

class BrandMark extends StatelessWidget {
  final double scale;
  final bool showName;

  const BrandMark({
    super.key,
    this.scale = 1,
    this.showName = true,
  });

  static const _assetPath = 'assets/images/travelbuddylogo.svg';

  @override
  Widget build(BuildContext context) {
    final logo = SvgPicture.asset(
      _assetPath,
      width: 170 * scale,
      height: 51 * scale,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      semanticsLabel: 'Travel Buddy logo',
    );

    if (showName) {
      return logo;
    }

    return ClipRect(
      child: SizedBox(
        width: 45 * scale,
        height: 45 * scale,
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: 170 * scale,
          maxWidth: 170 * scale,
          minHeight: 51 * scale,
          maxHeight: 51 * scale,
          child: logo,
        ),
      ),
    );
  }
}