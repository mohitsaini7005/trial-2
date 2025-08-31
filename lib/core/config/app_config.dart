/// Centralized app configuration and environment flags.
class AppConfig {
  // Build-time environment: dev/staging/prod
  static const String env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  // Support email, override with: --dart-define=SUPPORT_EMAIL=support@yourdomain.com
  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@example.com',
  );

  // Feature flags (can be toggled via Remote Config in app too)
  static const bool lowEndMapMode = bool.fromEnvironment('LOW_END_MAP', defaultValue: false);

  // Optional: external legal document URLs (if set, pages will open these)
  static const String privacyUrl = String.fromEnvironment('PRIVACY_URL', defaultValue: '');
  static const String termsUrl = String.fromEnvironment('TERMS_URL', defaultValue: '');
}
