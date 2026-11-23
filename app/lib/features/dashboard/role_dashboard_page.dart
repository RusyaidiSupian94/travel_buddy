import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_page.dart';
import '../../core/app_session.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class RoleDashboardPage extends StatefulWidget {
  final AppSession session;
  final DashboardSection? initialSection;
  final ValueChanged<String> onAction;

  const RoleDashboardPage({
    super.key,
    required this.session,
    required this.onAction,
    this.initialSection,
  });

  @override
  State<RoleDashboardPage> createState() => _RoleDashboardPageState();
}

class _RoleDashboardPageState extends State<RoleDashboardPage> {
  late DashboardSection _section;

  @override
  void initState() {
    super.initState();
    _section = _initialSectionForRole();
  }

  @override
  void didUpdateWidget(covariant RoleDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.role != widget.session.role) {
      _section = _initialSectionForRole();
    } else if (oldWidget.initialSection != widget.initialSection &&
        widget.initialSection != null) {
      _section = _initialSectionForRole();
    }
  }

  DashboardSection _initialSectionForRole() {
    final availableSections = _sectionsFor(widget.session.role);
    final requestedSection = widget.initialSection;

    if (requestedSection != null &&
        availableSections.contains(requestedSection)) {
      return requestedSection;
    }

    return _defaultSection(widget.session.role);
  }

  DashboardSection _defaultSection(AppRole role) {
    switch (role) {
      case AppRole.vendor:
        return DashboardSection.vendorOverview;
      case AppRole.admin:
        return DashboardSection.approvalQueue;
      case AppRole.superadmin:
        return DashboardSection.platformOverview;
      case AppRole.customer:
        return DashboardSection.platformOverview;
    }
  }

  List<DashboardSection> _sectionsFor(AppRole role) {
    if (role == AppRole.vendor) {
      return const [
        DashboardSection.vendorOverview,
        DashboardSection.vendorAddService,
        DashboardSection.vendorBookings,
      ];
    }

    if (role == AppRole.admin) {
      return const [
        DashboardSection.platformOverview,
        DashboardSection.approvalQueue,
      ];
    }

    return const [
      DashboardSection.platformOverview,
      DashboardSection.approvalQueue,
      DashboardSection.systemManagement,
    ];
  }

  String _sectionLabel(DashboardSection section) {
    switch (section) {
      case DashboardSection.vendorOverview:
        return 'Workspace';
      case DashboardSection.vendorAddService:
        return 'Tambah service';
      case DashboardSection.vendorBookings:
        return 'Booking & availability';
      case DashboardSection.platformOverview:
        return 'Platform overview';
      case DashboardSection.approvalQueue:
        return 'Approval queue';
      case DashboardSection.systemManagement:
        return 'Users, roles & settings';
    }
  }

  Widget _sectionContent() {
    switch (_section) {
      case DashboardSection.vendorOverview:
        return _VendorOverview(onAction: widget.onAction);
      case DashboardSection.vendorAddService:
        return _VendorAddService(onAction: widget.onAction);
      case DashboardSection.vendorBookings:
        return _VendorBookings(onAction: widget.onAction);
      case DashboardSection.platformOverview:
        return _PlatformOverview(onAction: widget.onAction);
      case DashboardSection.approvalQueue:
        return _ApprovalQueue(onAction: widget.onAction);
      case DashboardSection.systemManagement:
        return _SystemManagement(onAction: widget.onAction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sectionsFor(widget.session.role);

    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DashboardHero(session: widget.session),
          const SizedBox(height: 14),
          _DashboardTabs(
            sections: sections,
            selected: _section,
            labelBuilder: _sectionLabel,
            onSelected: (section) {
              setState(() {
                _section = section;
              });
            },
          ),
          const SizedBox(height: 20),
          _sectionContent(),
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
    final title = session.role == AppRole.vendor
        ? 'Selamat pagi, ${session.displayName}'
        : session.role == AppRole.admin
        ? 'Approval & operations center'
        : 'Platform overview';

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
              title,
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
              style: const TextStyle(color: Color(0xFFD4F2EB), fontSize: 12),
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

class _DashboardTabs extends StatelessWidget {
  final List<DashboardSection> sections;
  final DashboardSection selected;
  final String Function(DashboardSection) labelBuilder;
  final ValueChanged<DashboardSection> onSelected;

  const _DashboardTabs({
    required this.sections,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: sections
            .map(
              (section) => _DashboardTab(
                label: labelBuilder(section),
                selected: selected == section,
                onTap: () => onSelected(section),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DashboardTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? AppColors.ink : Colors.transparent,
        foregroundColor: selected ? Colors.white : AppColors.muted,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
      ),
      child: Text(label),
    );
  }
}

class _VendorOverview extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _VendorOverview({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'Vendor workspace',
          subtitle: 'Maklumat penting untuk operasi service anda.',
          actionLabel: '+ Tambah service',
          onAction: () => onAction('Tambah service vendor'),
        ),
        const SizedBox(height: 16),
        const _MetricGrid(
          metrics: [
            _MetricData(
              label: 'Pendapatan bulan ini',
              value: 'RM4,250',
              detail: '+18% bulan lepas',
              icon: Icons.payments_outlined,
              color: AppColors.teal,
            ),
            _MetricData(
              label: 'Tempahan aktif',
              value: '12',
              detail: '3 menunggu tindakan',
              icon: Icons.calendar_month_outlined,
              color: AppColors.coral,
            ),
            _MetricData(
              label: 'Rating service',
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
            title: 'Booking baharu',
            actionLabel: 'Lihat semua',
            onAction: () => onAction('Senarai booking vendor'),
            children: const [
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Aina Rahman · 2 orang',
                subtitle: 'Private island guide · 12 Jun 2025',
                trailing: 'RM500',
                accent: AppColors.teal,
                status: 'TERIMA',
              ),
            ],
          ),
          second: _DashboardPanel(
            title: 'Service saya',
            actionLabel: 'Urus service',
            onAction: () => onAction('Pengurusan service vendor'),
            children: const [_ServiceGrid()],
          ),
        ),
      ],
    );
  }
}

class _VendorAddService extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _VendorAddService({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'Tambah service baharu',
          subtitle:
              'Lengkapkan maklumat supaya customer mudah memilih pilihan anda.',
        ),
        const SizedBox(height: 16),
        const _StepIndicator(currentStep: 1),
        const SizedBox(height: 16),
        _DashboardPanel(
          title: 'Pilih jenis service',
          children: const [_ServiceTypeSelector()],
        ),
        const SizedBox(height: 14),
        _DashboardPanel(
          title: 'Maklumat asas',
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 620;
                final name = const _DashboardInput(
                  label: 'NAMA SERVICE',
                  hint: 'Contoh: Private island guide',
                  icon: Icons.title_outlined,
                );
                final price = const _DashboardInput(
                  label: 'HARGA / HARI',
                  hint: 'RM250',
                  icon: Icons.payments_outlined,
                );

                if (compact) {
                  return Column(
                    children: [name, const SizedBox(height: 11), price],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: name),
                    const SizedBox(width: 11),
                    Expanded(child: price),
                  ],
                );
              },
            ),
            const SizedBox(height: 11),
            const _DashboardInput(
              label: 'PENERANGAN',
              hint: 'Terangkan pengalaman yang akan customer dapat...',
              icon: Icons.notes_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => onAction('Simpan draft service'),
                icon: const Icon(Icons.save_outlined, size: 16),
                label: const Text('Simpan draft'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VendorBookings extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _VendorBookings({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'Booking & availability',
          subtitle:
              'Pilih tarikh dan pastikan jadual service anda dikemas kini.',
          actionLabel: '+ Update calendar',
          onAction: () => onAction('Update availability calendar'),
        ),
        const SizedBox(height: 16),
        const _StatusTabs(
          labels: [
            'Baharu (3)',
            'Pending (5)',
            'Confirmed (4)',
            'Completed (12)',
          ],
          selectedIndex: 0,
        ),
        const SizedBox(height: 14),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'Booking masuk',
            actionLabel: 'Lihat semua',
            onAction: () => onAction('Booking masuk vendor'),
            children: const [
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Aina Rahman · Private island guide',
                subtitle: '12 Jun 2025 · 2 guests · RM500',
                trailing: 'Confirm',
                accent: AppColors.teal,
                status: 'CONFIRMED',
              ),
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Daniel Wong · Kyoto itinerary',
                subtitle: '15 Jun 2025 · 4 guests · RM720',
                trailing: 'Review',
                accent: AppColors.coral,
                status: 'PENDING',
              ),
            ],
          ),
          second: _CalendarPanel(onAction: onAction),
        ),
      ],
    );
  }
}

class _PlatformOverview extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _PlatformOverview({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'Platform overview',
          subtitle:
              'Pantau prestasi marketplace dan operasi keseluruhan platform.',
          actionLabel: 'Export report',
          onAction: () => onAction('Export platform report'),
        ),
        const SizedBox(height: 16),
        const _MetricGrid(
          metrics: [
            _MetricData(
              label: 'Total users',
              value: '1,245',
              detail: '+8.2% bulan ini',
              icon: Icons.people_alt_outlined,
              color: AppColors.teal,
            ),
            _MetricData(
              label: 'Vendor aktif',
              value: '86',
              detail: '12 pending approval',
              icon: Icons.storefront_outlined,
              color: AppColors.coral,
            ),
            _MetricData(
              label: 'Bookings',
              value: '1,248',
              detail: '94% completed',
              icon: Icons.receipt_long_outlined,
              color: Color(0xFF9A6B2C),
            ),
            _MetricData(
              label: 'Gross sales',
              value: 'RM58.4k',
              detail: '+14% bulan ini',
              icon: Icons.trending_up_rounded,
              color: Color(0xFF2F9E62),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _AttentionSection(),
        const SizedBox(height: 18),
        _DashboardColumns(
          first: const _ActivityPanel(),
          second: _DashboardPanel(
            title: 'Quick links',
            actionLabel: 'Buka semua',
            onAction: () => onAction('Platform quick links'),
            children: [
              _QuickAction(
                icon: Icons.person_search_outlined,
                label: 'Review vendor approval',
                detail: '12 vendor menunggu review',
                onTap: () => onAction('Vendor approval'),
              ),
              _QuickAction(
                icon: Icons.report_problem_outlined,
                label: 'Semak dispute',
                detail: '8 dispute memerlukan tindakan',
                onTap: () => onAction('Semak dispute'),
              ),
              _QuickAction(
                icon: Icons.settings_outlined,
                label: 'Platform settings',
                detail: 'Roles, commission dan security',
                onTap: () => onAction('Platform settings'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApprovalQueue extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _ApprovalQueue({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'Approval queue',
          subtitle:
              'Semak vendor dan service sebelum dipaparkan kepada customer.',
          actionLabel: '+ Add validation rule',
          onAction: () => onAction('Add validation rule'),
        ),
        const SizedBox(height: 16),
        const _StatusTabs(
          labels: ['Pending (12)', 'Approved (86)', 'Rejected (4)'],
          selectedIndex: 0,
        ),
        const SizedBox(height: 14),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'Vendor review',
            actionLabel: 'Refresh',
            onAction: () => onAction('Refresh vendor review'),
            children: const [
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Ahmad Travel Services',
                subtitle: 'Vendor baru · submitted 2 hours ago',
                trailing: 'PENDING',
                accent: AppColors.coral,
                status: 'PENDING',
              ),
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Mia Travel',
                subtitle: 'Vendor baru · submitted yesterday',
                trailing: 'PENDING',
                accent: Color(0xFF9A6B2C),
                status: 'PENDING',
              ),
              _DashboardRow(
                icon: Icons.person_outline,
                title: 'Bali local guide',
                subtitle: 'Service update · submitted 3 days ago',
                trailing: 'REVIEW',
                accent: AppColors.teal,
                status: 'REVIEW',
              ),
            ],
          ),
          second: _ApprovalDetail(onAction: onAction),
        ),
      ],
    );
  }
}

class _SystemManagement extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _SystemManagement({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardTitle(
          title: 'System management',
          subtitle: 'Urus users, admin access, commission dan audit platform.',
          actionLabel: 'Save settings',
          onAction: () => onAction('Save system settings'),
        ),
        const SizedBox(height: 16),
        const _StatusTabs(
          labels: [
            'Users',
            'Admin roles',
            'Permission',
            'Audit log',
            'Settings',
          ],
          selectedIndex: 0,
        ),
        const SizedBox(height: 14),
        _DashboardPanel(
          title: 'User management',
          actionLabel: 'Add user',
          onAction: () => onAction('Add platform user'),
          children: const [_UserTable()],
        ),
        const SizedBox(height: 14),
        _DashboardColumns(
          first: _DashboardPanel(
            title: 'Platform rules',
            actionLabel: 'Edit rules',
            onAction: () => onAction('Edit platform rules'),
            children: const [
              _RuleRow(
                label: 'Platform commission',
                value: '5.0%',
                detail: 'Applied to every completed booking',
                icon: Icons.percent_outlined,
                color: AppColors.teal,
              ),
              _RuleRow(
                label: 'Vendor payout',
                value: 'T+2 days',
                detail: 'After customer confirmation',
                icon: Icons.account_balance_outlined,
                color: Color(0xFF9A6B2C),
              ),
            ],
          ),
          second: _DashboardPanel(
            title: 'Security settings',
            actionLabel: 'Manage security',
            onAction: () => onAction('Manage security settings'),
            children: const [
              _RuleRow(
                label: '2FA untuk admin',
                value: 'Required',
                detail: 'All admin accounts must enable 2FA',
                icon: Icons.security_outlined,
                color: Color(0xFF7B61B8),
              ),
              _RuleRow(
                label: 'Audit retention',
                value: '365 days',
                detail: 'All role changes are recorded',
                icon: Icons.history_outlined,
                color: AppColors.teal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _DashboardTitle({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        );

        final action = actionLabel == null || onAction == null
            ? null
            : FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: Text(actionLabel!),
              );

        if (compact && action != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 12), action],
          );
        }

        return Row(
          children: [
            Expanded(child: heading),
            ?action,
          ],
        );
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const labels = ['Jenis service', 'Maklumat', 'Review'];

    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: index <= currentStep
                              ? AppColors.teal
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  labels[index],
                  style: TextStyle(
                    color: index <= currentStep
                        ? AppColors.tealDark
                        : AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (index < labels.length - 1) const SizedBox(width: 7),
        ],
      ],
    );
  }
}

class _ServiceTypeSelector extends StatelessWidget {
  const _ServiceTypeSelector();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final guide = _ServiceTypeCard(
          title: 'Guide',
          subtitle: 'Guide tempatan untuk pengalaman peribadi.',
          icon: Icons.explore_outlined,
          selected: true,
        );
        final itinerary = _ServiceTypeCard(
          title: 'Itinerary',
          subtitle: 'Susun perjalanan lengkap untuk customer.',
          icon: Icons.map_outlined,
          selected: false,
        );

        if (compact) {
          return Column(
            children: [guide, const SizedBox(height: 10), itinerary],
          );
        }

        return Row(
          children: [
            Expanded(child: guide),
            const SizedBox(width: 11),
            Expanded(child: itinerary),
          ],
        );
      },
    );
  }
}

class _ServiceTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;

  const _ServiceTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: selected ? AppColors.mint : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.teal : AppColors.border,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? AppColors.teal : AppColors.muted),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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
          if (selected)
            const Icon(Icons.check_circle, color: AppColors.teal, size: 17),
        ],
      ),
    );
  }
}

class _DashboardInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _DashboardInput({
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.ink, fontSize: 11),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.teal, size: 17),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;

  const _StatusTabs({required this.labels, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: labels
            .asMap()
            .entries
            .map(
              (entry) => TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: entry.key == selectedIndex
                      ? AppColors.ink
                      : Colors.transparent,
                  foregroundColor: entry.key == selectedIndex
                      ? Colors.white
                      : AppColors.muted,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(entry.value),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CalendarPanel extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _CalendarPanel({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return _DashboardPanel(
      title: 'Calendar · Jun 2025',
      actionLabel: 'Edit',
      onAction: () => onAction('Edit availability calendar'),
      children: const [
        _CalendarGrid(),
        SizedBox(height: 10),
        Row(
          children: [
            _CalendarLegend(color: AppColors.teal, label: 'Confirmed'),
            SizedBox(width: 10),
            _CalendarLegend(color: AppColors.coral, label: 'Pending'),
            SizedBox(width: 10),
            _CalendarLegend(color: AppColors.border, label: 'Available'),
          ],
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const dates = <int?>[
      null,
      null,
      null,
      null,
      null,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 4.0;
        final cellWidth = (constraints.maxWidth - (gap * 6)) / 7;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            ...weekdays.map(
              (weekday) => SizedBox(
                width: cellWidth,
                height: 18,
                child: Text(
                  weekday,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            ...dates.map(
              (date) => SizedBox(
                width: cellWidth,
                height: 29,
                child: _CalendarCell(date: date),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CalendarCell extends StatelessWidget {
  final int? date;

  const _CalendarCell({required this.date});

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const SizedBox.shrink();
    }

    final confirmed = date == 12 || date == 21;
    final pending = date == 14 || date == 25;
    final color = confirmed
        ? AppColors.teal
        : pending
        ? AppColors.coral
        : AppColors.border;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: confirmed
            ? AppColors.mint
            : pending
            ? const Color(0xFFFFE7E1)
            : const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(
        '$date',
        style: TextStyle(
          color: confirmed || pending ? color : AppColors.muted,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _CalendarLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 8),
        ),
      ],
    );
  }
}

class _AttentionSection extends StatelessWidget {
  const _AttentionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Needs attention',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 9),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            const gap = 10.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: const [
                _AttentionCard(
                  width: 0,
                  title: 'Vendor verification',
                  value: '8 pending',
                  action: 'Buka',
                  color: AppColors.coral,
                ),
                _AttentionCard(
                  width: 0,
                  title: 'Disputed bookings',
                  value: '15 open',
                  action: 'Buka',
                  color: Color(0xFF7B61B8),
                ),
                _AttentionCard(
                  width: 0,
                  title: 'Refund requests',
                  value: '4 pending',
                  action: 'Buka',
                  color: Color(0xFFB95757),
                ),
              ].map((card) => SizedBox(width: width, child: card)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AttentionCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String action;
  final Color color;

  const _AttentionCard({
    required this.width,
    required this.title,
    required this.value,
    required this.action,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Text(
            action,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking activity',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            height: 145,
            width: double.infinity,
            child: CustomPaint(painter: _ActivityChartPainter()),
          ),
          const SizedBox(height: 7),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('May 01', style: _TinyTextStyle.style),
              Text('May 15', style: _TinyTextStyle.style),
              Text('May 30', style: _TinyTextStyle.style),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyTextStyle {
  static const style = TextStyle(color: AppColors.muted, fontSize: 8);
}

class _ActivityChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var index = 1; index < 4; index++) {
      final y = size.height * index / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = [
      Offset(0, size.height * 0.76),
      Offset(size.width * 0.12, size.height * 0.70),
      Offset(size.width * 0.24, size.height * 0.72),
      Offset(size.width * 0.36, size.height * 0.55),
      Offset(size.width * 0.48, size.height * 0.61),
      Offset(size.width * 0.60, size.height * 0.43),
      Offset(size.width * 0.72, size.height * 0.48),
      Offset(size.width * 0.84, size.height * 0.22),
      Offset(size.width, size.height * 0.29),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      path.lineTo(points[index].dx, points[index].dy);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ApprovalDetail extends StatelessWidget {
  final ValueChanged<String> onAction;

  const _ApprovalDetail({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return _DashboardPanel(
      title: 'Ahmad Travel Services',
      actionLabel: 'View profile',
      onAction: () => onAction('View vendor profile'),
      children: [
        const _DetailLine(label: 'Owner', value: 'Ahmad bin Rahman'),
        const _DetailLine(label: 'Email', value: 'ahmad@travelservices.my'),
        const _DetailLine(label: 'Documents', value: '3 files attached'),
        const _DetailLine(label: 'Service category', value: 'Guide · Langkawi'),
        const SizedBox(height: 8),
        const Text(
          'Decision',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            FilledButton(
              onPressed: () => onAction('Approve vendor'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: const Text('Approve'),
            ),
            OutlinedButton(
              onPressed: () => onAction('Request vendor changes'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: const Text('Request changes'),
            ),
            TextButton(
              onPressed: () => onAction('Reject vendor'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.coral,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: const Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }
}

class _UserTable extends StatelessWidget {
  const _UserTable();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['Aina Rahman', 'Customer', 'Active', 'Today, 10:21'],
      ['Ahmad Travel Services', 'Vendor', 'Review', 'Yesterday'],
      ['Mia Travel', 'Admin', 'Active', '12 Jun 2025'],
    ];

    return Column(
      children: [
        const _UserTableRow(
          name: 'NAME',
          role: 'ROLE',
          status: 'STATUS',
          lastSeen: 'LAST ACTIVE',
          header: true,
        ),
        const Divider(color: AppColors.border, height: 1),
        ...rows.map(
          (row) => _UserTableRow(
            name: row[0],
            role: row[1],
            status: row[2],
            lastSeen: row[3],
          ),
        ),
      ],
    );
  }
}

class _UserTableRow extends StatelessWidget {
  final String name;
  final String role;
  final String status;
  final String lastSeen;
  final bool header;

  const _UserTableRow({
    required this.name,
    required this.role,
    required this.status,
    required this.lastSeen,
    this.header = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: header ? AppColors.muted : AppColors.ink,
      fontSize: header ? 8 : 10,
      fontWeight: header ? FontWeight.w900 : FontWeight.w700,
      letterSpacing: header ? 0.5 : 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(role, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: header
                    ? AppColors.muted
                    : status == 'Active'
                    ? AppColors.teal
                    : AppColors.coral,
                fontSize: header ? 8 : 10,
                fontWeight: FontWeight.w800,
                letterSpacing: header ? 0.5 : 0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lastSeen,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          if (!header)
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 17),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const _RuleRow({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 430;
        final first = const _MiniServiceCard(
          name: 'Private island guide',
          price: 'RM250 / hari',
          style: MountainStyle.sea,
        );
        final second = const _MiniServiceCard(
          name: 'Kyoto city travel',
          price: 'RM340 / hari',
          style: MountainStyle.sunset,
        );

        if (compact) {
          return Column(children: [first, const SizedBox(height: 10), second]);
        }

        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 10),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _MiniServiceCard extends StatelessWidget {
  final String name;
  final String price;
  final MountainStyle style;

  const _MiniServiceCard({
    required this.name,
    required this.price,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 54,
            child: MountainArt(
              style: style,
              height: 54,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GUIDE',
                  style: TextStyle(
                    color: AppColors.teal,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.ink,
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(
          children: [
            const Icon(Icons.chevron_right, color: AppColors.teal, size: 18),
            Container(
              width: 31,
              height: 31,
              decoration: const BoxDecoration(
                color: AppColors.mint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.tealDark, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.muted, fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  const _DashboardColumns({required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 780) {
          return Column(children: [first, const SizedBox(height: 14), second]);
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

  const _StatusPill({required this.label, required this.color});

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
