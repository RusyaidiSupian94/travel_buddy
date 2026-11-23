enum AppRole {
  customer,
  vendor,
  admin,
  superadmin,
}

extension AppRoleDetails on AppRole {
  String get label {
    switch (this) {
      case AppRole.customer:
        return 'Customer';
      case AppRole.vendor:
        return 'Vendor';
      case AppRole.admin:
        return 'Admin';
      case AppRole.superadmin:
        return 'Superadmin';
    }
  }

  bool get canAccessDashboard => this != AppRole.customer;
}

class AppSession {
  final String displayName;
  final String email;
  final AppRole role;
  final String? accessToken;
  final DateTime? accessTokenExpiresAt;

  const AppSession({
    required this.displayName,
    required this.email,
    this.role = AppRole.customer,
    this.accessToken,
    this.accessTokenExpiresAt,
  });

  factory AppSession.fromJson(Map<String, dynamic> json) {
    final rawRole = (json['role'] as String? ?? 'Customer').toLowerCase();
    final role = switch (rawRole) {
      'vendor' => AppRole.vendor,
      'admin' => AppRole.admin,
      'superadmin' => AppRole.superadmin,
      _ => AppRole.customer,
    };

    return AppSession(
      displayName: json['displayName'] as String? ?? 'Travel Buddy',
      email: json['email'] as String? ?? '',
      role: role,
      accessToken: json['accessToken'] as String?,
      accessTokenExpiresAt: DateTime.tryParse(
        json['expiresAtUtc'] as String? ?? '',
      ),
    );
  }

  String get initials {
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      return 'A';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }

  bool get isTokenExpired {
    if (accessToken == null || accessToken!.isEmpty) {
      return false;
    }

    final expiry = accessTokenExpiresAt;
    return expiry == null || !DateTime.now().toUtc().isBefore(expiry);
  }

  AppSession copyWith({
    String? displayName,
    String? email,
    AppRole? role,
    String? accessToken,
    DateTime? accessTokenExpiresAt,
  }) {
    return AppSession(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpiresAt:
          accessTokenExpiresAt ?? this.accessTokenExpiresAt,
    );
  }
}
