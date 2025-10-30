/// ملف الإعدادات والثوابت الأساسية للتطبيق
class AppConfig {
  // معلومات التطبيق
  static const String appName = 'Vertex';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // معلومات الشركة
  static const String companyName = 'Ripo Labs';
  static const String supportEmail = 'support@vertex.app';
  static const String websiteUrl = 'https://vertex.app';
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.vertex.app/v1';
  static const String apiTimeout = '30'; // seconds
  
  // Stripe Configuration (سيتم تحديثها لاحقاً)
  static const String stripePublishableKey = 'pk_test_YOUR_KEY_HERE';
  static const String stripeMerchantId = 'merchant.com.ripolabs.vertex';
  
  // Firebase Configuration (سيتم إضافتها بعد إعداد Firebase)
  // سيتم تحميلها تلقائياً من google-services.json / GoogleService-Info.plist
  
  // Storage Keys (للتخزين المحلي)
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  
  // Subscription Plans
  static const double primePriceMonthly = 10.0;
  static const double primePrice Yearly = 100.0;
  static const double proPriceMonthly = 15.0;
  static const double proPriceYearly = 150.0;
  
  // Platform Fees
  static const double platformFeePercentage = 0.30; // 30%
  static const double sellerPercentage = 0.70; // 70%
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int submissionsPerPage = 10;
  
  // File Upload Limits
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 50;
  static const int maxFileSizeMB = 100;
  
  // Challenge Settings
  static const int challengeDurationDays = 7;
  static const int votingDurationDays = 3;
  
  // Social Media Links
  static const String twitterUrl = 'https://twitter.com/VertexApp';
  static const String instagramUrl = 'https://instagram.com/vertexapp';
  static const String facebookUrl = 'https://facebook.com/vertexapp';
  
  // Legal Links
  static const String privacyPolicyUrl = 'https://vertex.app/privacy';
  static const String termsOfServiceUrl = 'https://vertex.app/terms';
  static const String communityGuidelinesUrl = 'https://vertex.app/guidelines';
  
  // Feature Flags (للتحكم في الميزات)
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;
  static const bool enableSocialSharing = true;
  static const bool enableInAppPurchases = true;
  
  // Debug Mode
  static const bool isDebugMode = true; // سيتم تغييرها إلى false في الإنتاج
}
