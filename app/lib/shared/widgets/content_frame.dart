import 'package:material_ui/material_ui.dart';

class ContentFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ContentFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 24,
    ),
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
