import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_session.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class AuthGatePage extends StatefulWidget {
  final bool initiallyRegistering;
  final ValueChanged<AppSession> onAuthenticated;

  const AuthGatePage({
    super.key,
    required this.onAuthenticated,
    this.initiallyRegistering = false,
  });

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late bool _registering;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _registering = widget.initiallyRegistering;
  }

  @override
  void didUpdateWidget(covariant AuthGatePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyRegistering != widget.initiallyRegistering) {
      _registering = widget.initiallyRegistering;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectMode(bool registering) {
    if (_registering == registering) {
      return;
    }

    setState(() {
      _registering = registering;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text.trim();
    final enteredName = _nameController.text.trim();
    final displayName = _registering && enteredName.isNotEmpty
        ? enteredName
        : _nameFromEmail(email);

    setState(() {
      _submitting = true;
    });

    widget.onAuthenticated(
      AppSession(
        displayName: displayName,
        email: email,
      ),
    );
  }

  String _nameFromEmail(String email) {
    final prefix = email.split('@').first.trim();
    if (prefix.isEmpty) {
      return 'Travel Buddy';
    }

    return prefix.substring(0, 1).toUpperCase() + prefix.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final height = compact
              ? (_registering ? 735.0 : 670.0)
              : (_registering ? 625.0 : 560.0);

          return MountainArt(
            style: MountainStyle.auth,
            height: height,
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(compact ? 16 : 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 475),
                  child: _buildCard(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
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
      child: Form(
        key: _formKey,
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
                Icons.lock_open_rounded,
                color: AppColors.teal,
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _registering
                  ? 'Daftar untuk meneruskan'
                  : 'Log masuk untuk membayar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Guest boleh browse dahulu. Login atau daftar diperlukan sebelum payment.',
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
                  child: _ModeButton(
                    label: 'Log masuk',
                    selected: !_registering,
                    onTap: () => _selectMode(false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ModeButton(
                    label: 'Daftar akaun',
                    selected: _registering,
                    filled: true,
                    onTap: () => _selectMode(true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_registering) ...[
              _AuthInput(
                controller: _nameController,
                label: 'Nama penuh',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan nama anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 9),
            ],
            _AuthInput(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Masukkan email anda';
                }
                if (!email.contains('@') || !email.contains('.')) {
                  return 'Masukkan email yang sah';
                }
                return null;
              },
            ),
            const SizedBox(height: 9),
            _AuthInput(
              controller: _passwordController,
              label: 'Kata laluan',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if ((value ?? '').length < 6) {
                  return 'Minimum 6 aksara';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  _registering
                      ? 'Daftar & teruskan ke checkout'
                      : 'Log masuk & teruskan ke checkout',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Akaun diperlukan sebelum anda membuat payment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected
            ? (filled ? AppColors.ink : AppColors.mint)
            : const Color(0xFFF7FAF7),
        foregroundColor: selected
            ? (filled ? Colors.white : AppColors.tealDark)
            : AppColors.muted,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      child: Text(label),
    );
  }
}

class _AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthInput({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 11,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 17, color: AppColors.teal),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
      ),
    );
  }
}
