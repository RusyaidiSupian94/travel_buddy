import 'app_session.dart';

class AuthRequest {
  final bool registering;
  final String displayName;
  final String email;
  final String password;
  final String confirmPassword;
  final AppRole role;

  const AuthRequest({
    required this.registering,
    required this.displayName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}
