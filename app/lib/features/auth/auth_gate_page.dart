import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_session.dart';
import '../../core/auth_request.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class AuthGatePage extends StatefulWidget {
  final bool initiallyRegistering;
  final ValueChanged<AppSession> onAuthenticated;
  final Future<AppSession> Function(AuthRequest request) onAuthenticate;
  final ValueChanged<String> onSocialLogin;

  const AuthGatePage({
    super.key,
    required this.onAuthenticated,
    required this.onAuthenticate,
    required this.onSocialLogin,
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
  final _confirmPasswordController = TextEditingController();

  late bool _registering;
  AppRole _selectedRole = AppRole.customer;
  bool _submitting = false;
  String? _errorMessage;

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
    _confirmPasswordController.dispose();
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

  Future<void> _submit() async {
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
      _errorMessage = null;
    });

    try {
      final session = await widget.onAuthenticate(
        AuthRequest(
          registering: _registering,
          displayName: displayName,
          email: email,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          role: _selectedRole,
        ),
      );

      if (!mounted) {
        return;
      }

      widget.onAuthenticated(session);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _submitting = false;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
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
              ? (_registering ? 1050.0 : 900.0)
              : (_registering ? 900.0 : 760.0);

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
            const SizedBox(height: 14),
            _RolePicker(
              selected: _selectedRole,
              onSelected: (role) {
                setState(() {
                  _selectedRole = role;
                });
              },
            ),
            const SizedBox(height: 14),
            const _AuthDivider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SocialLoginButton(
                    mark: '',
                    markColor: Colors.black,
                    label: 'Apple',
                    onTap: () => widget.onSocialLogin('Apple'),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _SocialLoginButton(
                    mark: 'G',
                    markColor: const Color(0xFFDB4437),
                    label: 'Google',
                    onTap: () => widget.onSocialLogin('Google'),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _SocialLoginButton(
                    mark: 'f',
                    markColor: const Color(0xFF1877F2),
                    label: 'Facebook',
                    onTap: () => widget.onSocialLogin('Facebook'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
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
            if (_registering) ...[
              const SizedBox(height: 9),
              _AuthInput(
                controller: _confirmPasswordController,
                label: 'Sahkan kata laluan',
                icon: Icons.lock_reset_outlined,
                obscureText: true,
                validator: (value) {
                  if ((value ?? '').isEmpty) {
                    return 'Sahkan kata laluan anda';
                  }
                  if (value != _passwordController.text) {
                    return 'Kata laluan tidak sepadan';
                  }
                  return null;
                },
              ),
            ],
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5DF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFB95757),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
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

class _RolePicker extends StatelessWidget {
  final AppRole selected;
  final ValueChanged<AppRole> onSelected;

  const _RolePicker({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROLE PREVIEW',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Pilih role untuk melihat UI dashboard.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: AppRole.values
              .map(
                (role) => ChoiceChip(
                  label: Text(role.label),
                  selected: selected == role,
                  onSelected: (_) => onSelected(role),
                  selectedColor: AppColors.mint,
                  backgroundColor: const Color(0xFFF7FAF7),
                  side: BorderSide(
                    color: selected == role
                        ? AppColors.teal
                        : AppColors.border,
                  ),
                  labelStyle: TextStyle(
                    color: selected == role
                        ? AppColors.tealDark
                        : AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'atau teruskan dengan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String mark;
  final Color markColor;
  final String label;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.mark,
    required this.markColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mark,
            style: TextStyle(
              color: markColor,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
    required this.icon,
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
