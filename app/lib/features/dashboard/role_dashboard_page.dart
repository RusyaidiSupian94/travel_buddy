import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_session.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class RoleDashboardPage extends StatelessWidget {
  final AppSession session;
  final ValueChanged<String> onAction;

  const RoleDashboardPage({
    super.key,
    required this.session,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DashboardHero(session: session),
          const SizedBox(height: 20),
          _RoleDashboardContent(
            role: session.role,
            onAction: onAction,
          ),
        ],
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final AppSession session;

  const _DashboardHero({required this.session});

  @override
  Widget build(BuildContext context) {
    return MountainArt(
      style: MountainStyle.hero,
      height: 165,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${session.role.label.toUpperCase()} WORKSPACE',
              style: const TextStyle(
                color: Color(0xFFC9EEE6),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dashboard ${session.role.label}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _roleDescription(session.role),
              style: const TextStyle(
                color: Color(0xFFD4F2EB),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _roleDescription(AppRole role) {
  switch (role) {
    case AppRole.customer:
      return 'Ruang dashboard tidak tersedia untuk customer.';
    case AppRole.vendor:
      return 'Urus service, tempahan, availability dan earnings anda.';
    case AppRole.admin:
      return 'Pantau marketplace, vendor approval dan operasi harian.';
    case AppRole.superadmin:
      return 'Kawal sistem, akses admin, permission dan audit platform.';
  }
}

class _RoleDashboardContent extends StatelessWidget {
  final AppRole role;
  final ValueChanged<String> onAction;

  const _RoleDashboardContent({
    required this.role,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case AppRole.customer:
        return const _DashboardAccessNotice();
      case AppRole.vendor:
        return _VendorDashboard(onAction: onAction);
      case AppRole.admin:
        return _AdminDashboard(onAction: onAction);
      case AppRole.superadmin:
        return _SuperadminDashboard(onAction: onAction);
    }
  }
}

class _VendorDashboard extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _VendorDashboard({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MetricGrid(
          metrics: [
            _MetricData(
              label: 'Jualan bulan ini',
              value: 'RM8,420',
              detail: '+18% dari bulan lepas',
              icon: Icons.payments_outlined,
              color: AppColors.teal,
            ),
            _MetricData(
              label: 'Tempahan aktif',
              value: '24',
              detail: '8 menunggu tindakan',
              icon: Icons.calendar_month_outlined,
              color: AppColors.coral,
            ),
            _MetricData(
              label: 'Service aktif',
              value: '12',
              detail: '2 perlu dikemas kini',
              icon: Icons.storefront_outlined,
              color: Color(0xFF9A6B2C),
            ),
            _MetricData(
              label: 'Rating purata',
              value: '4.9',
              detail: '126 reviews',
              icon: Icons.star_outline_rounded,
              color: Color(0xFF7B61B8),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'Tempahan terkini',
            actionLabel: 'Lihat semua',
            onAction: () => onAction('Senarai tempahan vendor'),
            children: const [
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Aina Rahman',
                subtitle: 'Private island guide · 12 Jun 2025',
                trailing: 'RM500',
                accent: AppColors.teal,
              ),
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Daniel Lee',
                subtitle: 'Langkawi island hopping · 15 Jun 2025',
                trailing: 'RM680',
                accent: AppColors.coral,
              ),
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Sofia Karim',
                subtitle: 'Sunset beach tour · 20 Jun 2025',
                trailing: 'RM420',
                accent: Color(0xFF9A6B2C),
              ),
            ],
          ),
          second: _DashboardPanel(
            title: 'Service anda',
            actionLabel: 'Urus service',
            onAction: () => onAction('Pengurusan service vendor'),
            children: const [
              _DashboardRow(
                icon: Icons.landscape_outlined,
                title: 'Private island guide',
                subtitle: '12 booking bulan ini',
                trailing: 'Aktif',
                accent: AppColors.teal,
                status: 'AKTIF',
              ),
              _DashboardRow(
                icon: Icons.directions_boat_outlined,
                title: 'Langkawi island hopping',
                subtitle: '8 booking bulan ini',
                trailing: 'Aktif',
                accent: AppColors.teal,
                status: 'AKTIF',
              ),
              _DashboardRow(
                icon: Icons.beach_access_outlined,
                title: 'Sunset beach tour',
                subtitle: 'Availability perlu dikemas kini',
                trailing: 'Semak',
                accent: AppColors.coral,
                status: 'TINDAKAN',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _AdminDashboard({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MetricGrid(
          metrics: [
            _MetricData(
              label: 'GMV bulan ini',
              value: 'RM128k',
              detail: '+12.4% dari bulan lepas',
              icon: Icons.trending_up_rounded,
              color: AppColors.teal,
            ),
            _MetricData(
              label: 'Vendor pending',
              value: '12',
              detail: 'Perlu review admin',
              icon: Icons.how_to_reg_outlined,
              color: AppColors.coral,
            ),
            _MetricData(
              label: 'Booking hari ini',
              value: '86',
              detail: '94% berjaya diproses',
              icon: Icons.receipt_long_outlined,
              color: Color(0xFF9A6B2C),
            ),
            _MetricData(
              label: 'Open dispute',
              value: '8',
              detail: '3 melebihi 24 jam',
              icon: Icons.report_problem_outlined,
              color: Color(0xFFB95757),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'Vendor menunggu approval',
            actionLabel: 'Lihat semua',
            onAction: () => onAction('Vendor approval'),
            children: const [
              _DashboardRow(
                icon: Icons.storefront_outlined,
                title: 'Rimba Travel Co.',
                subtitle: 'Dokumen lengkap · dihantar 2 jam lalu',
                trailing: 'Review',
                accent: AppColors.coral,
                status: 'PENDING',
              ),
              _DashboardRow(
                icon: Icons.storefront_outlined,
                title: 'Island Soul Guide',
                subtitle: 'Menunggu pengesahan lesen',
                trailing: 'Review',
                accent: Color(0xFF9A6B2C),
                status: 'PENDING',
              ),
              _DashboardRow(
                icon: Icons.storefront_outlined,
                title: 'Borneo Hidden Gems',
                subtitle: 'Profil vendor perlu dilengkapkan',
                trailing: 'Review',
                accent: AppColors.coral,
                status: 'PENDING',
              ),
            ],
          ),
          second: _DashboardPanel(
            title: 'Moderation queue',
            actionLabel: 'Buka moderation',
            onAction: () => onAction('Moderation queue'),
            children: const [
              _DashboardRow(
                icon: Icons.rate_review_outlined,
                title: 'Review pelanggan dilaporkan',
                subtitle: 'Private island guide · 15 min lalu',
                trailing: '3',
                accent: AppColors.coral,
              ),
              _DashboardRow(
                icon: Icons.payments_outlined,
                title: 'Dispute payment',
                subtitle: 'Booking TB-2025-0612 · 2 jam lalu',
                trailing: '2',
                accent: Color(0xFF9A6B2C),
              ),
              _DashboardRow(
                icon: Icons.flag_outlined,
                title: 'Service flagged',
                subtitle: 'Maklumat service tidak lengkap',
                trailing: '1',
                accent: Color(0xFFB95757),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuperadminDashboard extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _SuperadminDashboard({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MetricGrid(
          metrics: [
            _MetricData(
              label: 'Total users',
              value: '12,540',
              detail: '+438 bulan ini',
              icon: Icons.people_alt_outlined,
              color: AppColors.teal,
            ),
            _MetricData(
              label: 'Vendor aktif',
              value: '286',
              detail: '12 menunggu approval',
              icon: Icons.storefront_outlined,
              color: AppColors.coral,
            ),
            _MetricData(
              label: 'Admin accounts',
              value: '18',
              detail: '2 role changes pending',
              icon: Icons.admin_panel_settings_outlined,
              color: Color(0xFF7B61B8),
            ),
            _MetricData(
              label: 'System uptime',
              value: '99.98%',
              detail: '30 hari terakhir',
              icon: Icons.monitor_heart_outlined,
              color: Color(0xFF2F9E62),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'System overview',
            actionLabel: 'System settings',
            onAction: () => onAction('System settings'),
            children: const [
              _DashboardRow(
                icon: Icons.cloud_done_outlined,
                title: 'API services',
                subtitle: 'Semua service beroperasi normal',
                trailing: 'Healthy',
                accent: Color(0xFF2F9E62),
                status: 'LIVE',
              ),
              _DashboardRow(
                icon: Icons.storage_outlined,
                title: 'Database',
                subtitle: 'Backup terakhir 18 min lalu',
                trailing: 'Healthy',
                accent: Color(0xFF2F9E62),
                status: 'LIVE',
              ),
              _DashboardRow(
                icon: Icons.payment_outlined,
                title: 'Payment gateway',
                subtitle: 'Monitoring transaksi aktif',
                trailing: 'Monitor',
                accent: AppColors.teal,
                status: 'LIVE',
              ),
            ],
          ),
          second: _DashboardPanel(
            title: 'Access & audit',
            actionLabel: 'Lihat audit log',
            onAction: () => onAction('Audit log'),
            children: const [
              _DashboardRow(
                icon: Icons.manage_accounts_outlined,
                title: 'Admin management',
                subtitle: '18 admin · 2 perubahan pending',
                trailing: 'Urus',
                accent: Color(0xFF7B61B8),
              ),
              _DashboardRow(
                icon: Icons.policy_outlined,
                title: 'Role & permission',
                subtitle: '4 role policy sedang digunakan',
                trailing: 'Semak',
                accent: AppColors.teal,
              ),
              _DashboardRow(
                icon: Icons.history_outlined,
                title: 'Recent audit activity',
                subtitle: 'Admin Aina kemas kini vendor policy',
                trailing: '10 min',
                accent: Color(0xFF9A6B2C),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardAccessNotice extends StatelessWidget {
  const _DashboardAccessNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFF5E0CA)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Color(0xFF9A6B2C)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dashboard ini hanya tersedia untuk Vendor, Admin dan Superadmin.',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final List<_MetricData> metrics;

  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1120
            ? 4
            : constraints.maxWidth >= 660
                ? 2
                : 1;
        const gap = 12.0;
        final cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: cardWidth,
                  child: _MetricCard(metric: metric),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _MetricData metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(metric.icon, color: metric.color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  metric.value,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  metric.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: metric.color,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const _MetricData({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });
}

class _DashboardColumns extends StatelessWidget {
  final Widget first;
  final Widget second;

  const _DashboardColumns({
    required this.first,
    required this.second,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 780) {
          return Column(
            children: [
              first,
              const SizedBox(height: 14),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<Widget> children;

  const _DashboardPanel({
    required this.title,
    required this.children,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (actionLabel != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: Text(actionLabel!),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DashboardRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;
  final String? status;

  const _DashboardRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.accent,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: accent, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailing,
                style: TextStyle(
                  color: accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (status != null) ...[
                const SizedBox(height: 4),
                _StatusPill(label: status!, color: accent),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 7,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
