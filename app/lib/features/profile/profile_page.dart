import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_session.dart';
import '../../shared/widgets/content_frame.dart';

class ProfilePage extends StatefulWidget {
  final AppSession session;
  final ValueChanged<AppSession> onSave;
  final VoidCallback onLogout;
  final VoidCallback? onDashboard;

  const ProfilePage({
    super.key,
    required this.session,
    required this.onSave,
    required this.onLogout,
    this.onDashboard,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.session.displayName);
    _emailController = TextEditingController(text: widget.session.email);
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session != widget.session) {
      _nameController.text = widget.session.displayName;
      _emailController.text = widget.session.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSave(
      widget.session.copyWith(
        displayName: _nameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil saya',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Urus maklumat ${widget.session.role.label.toLowerCase()} account dan tetapan anda.',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 21),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final summary = _ProfileSummary(session: widget.session);
              final details = _ProfileDetails(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                onSave: _saveProfile,
                onLogout: widget.onLogout,
                onDashboard: widget.onDashboard,
              );

              if (compact) {
                return Column(
                  children: [
                    summary,
                    const SizedBox(height: 16),
                    details,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: summary),
                  const SizedBox(width: 20),
                  Expanded(flex: 6, child: details),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  final AppSession session;

  const _ProfileSummary({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFF7D7BD),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              session.initials,
              style: const TextStyle(
                color: Color(0xFF8D5A51),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 19),
          Text(
            '${session.role.label.toUpperCase()} ACCOUNT',
            style: const TextStyle(
              color: Color(0xFFA8D9D1),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            session.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            session.email,
            style: const TextStyle(
              color: Color(0xFFB9DDD7),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFFA8D9D1),
                  size: 17,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    session.role.canAccessDashboard
                        ? 'Akaun ${session.role.label} aktif untuk mengurus operasi anda.'
                        : 'Akaun aktif untuk membuat tempahan dan payment.',
                    style: const TextStyle(
                      color: Color(0xFFD8F0EB),
                      fontSize: 10,
                      height: 1.35,
                    ),
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

class _ProfileDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onSave;
  final VoidCallback onLogout;
  final VoidCallback? onDashboard;

  const _ProfileDetails({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.onSave,
    required this.onLogout,
    required this.onDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maklumat akaun',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Pastikan nama anda sentiasa dikemas kini.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 17),
            _ProfileInput(
              controller: nameController,
              label: 'Nama penuh',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 11),
            _ProfileInput(
              controller: emailController,
              label: 'Email login',
              icon: Icons.email_outlined,
              readOnly: true,
            ),
            const SizedBox(height: 7),
            const Text(
              'Email digunakan untuk login dan tidak boleh diubah di sini.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_outlined, size: 17),
                label: const Text('Simpan perubahan'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
            if (onDashboard != null) ...[
              const SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onDashboard,
                  icon: const Icon(Icons.dashboard_outlined, size: 16),
                  label: const Text('Buka dashboard role'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(43),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Log keluar'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(43),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final String? Function(String?)? validator;

  const _ProfileInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 12,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppColors.teal),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F5F2) : null,
      ),
    );
  }
}
