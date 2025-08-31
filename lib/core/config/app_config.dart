/// Centralized app configuration and environment flags for Tribal & Tourism SaaS Platform
class AppConfig {
  // App Identity
  static const String appName = 'TribalConnect';
  static const String appTagline = 'Discover, Connect, Experience Tribal Culture';
  static const String appDescription = 'Your gateway to authentic tribal experiences, heritage tours, and cultural immersion';
  
  // Build-time environment: dev/staging/prod
  static const String env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  // Contact Information
  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@tribalconnect.com',
  );
  static const String businessEmail = 'business@tribalconnect.com';
  static const String adminEmail = 'admin@tribalconnect.com';

  // Feature flags (can be toggled via Remote Config in app too)
  static const bool lowEndMapMode = bool.fromEnvironment('LOW_END_MAP', defaultValue: false);
  static const bool enableSocialFeatures = bool.fromEnvironment('ENABLE_SOCIAL', defaultValue: true);
  static const bool enableMarketplace = bool.fromEnvironment('ENABLE_MARKETPLACE', defaultValue: true);
  static const bool enableAIFeatures = bool.fromEnvironment('ENABLE_AI', defaultValue: true);
  static const bool enableARFeatures = bool.fromEnvironment('ENABLE_AR', defaultValue: false);
  
  // SaaS Configuration
  static const bool enableMultiTenant = bool.fromEnvironment('ENABLE_MULTI_TENANT', defaultValue: true);
  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  static const bool enableNotifications = bool.fromEnvironment('ENABLE_NOTIFICATIONS', defaultValue: true);

  // External URLs (if set, pages will open these)
  static const String privacyUrl = String.fromEnvironment('PRIVACY_URL', defaultValue: '');
  static const String termsUrl = String.fromEnvironment('TERMS_URL', defaultValue: '');
  static const String aboutUrl = String.fromEnvironment('ABOUT_URL', defaultValue: '');
  
  // API Configuration
  static const String baseApiUrl = String.fromEnvironment(
    'API_BASE_URL', 
    defaultValue: env == 'prod' 
      ? 'https://api.tribalconnect.com' 
      : 'https://api-dev.tribalconnect.com'
  );
  
  // Payment Configuration
  static const String razorpayKeyId = String.fromEnvironment('RAZORPAY_KEY_ID', defaultValue: '');
  static const String stripePublishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  
  // Social Media & Marketing
  static const String facebookUrl = 'https://facebook.com/tribalconnect';
  static const String instagramUrl = 'https://instagram.com/tribalconnect';
  static const String twitterUrl = 'https://twitter.com/tribalconnect';
  static const String linkedinUrl = 'https://linkedin.com/company/tribalconnect';
  
  // App Store URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.tribalconnect.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/tribalconnect/id123456789';
  
  // Business Configuration
  static const double commissionRate = 0.1; // 10% commission
  static const int maxBookingsPerUser = 10;
  static const int maxWishlistItems = 50;
  static const double freeShippingThreshold = 1000.0; // ₹1000
}
