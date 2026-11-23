abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://friendly-fiesta-756j5x6gw6rfpwgp-5073.app.github.dev/',
  );
}
