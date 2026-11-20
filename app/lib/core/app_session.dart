class AppSession {
  final String displayName;
  final String email;

  const AppSession({
    required this.displayName,
    required this.email,
  });

  String get initials {
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      return 'A';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }
}
