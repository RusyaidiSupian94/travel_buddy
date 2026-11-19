import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import 'app_footer.dart';
import 'app_header.dart';

class AppShell extends StatelessWidget {
  final AppPage currentPage;
  final ValueChanged<AppPage> onNavigate;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentPage,
    required this.onNavigate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(
                currentPage: currentPage,
                onNavigate: onNavigate,
              ),
              child,
              AppFooter(onNavigate: onNavigate),
            ],
          ),
        ),
      ),
    );
  }
}
