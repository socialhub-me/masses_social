import 'package:flutter/foundation.dart';

/// App configuration for different environments
/// This will be expanded when adding flavors (dev, staging, prod)
class AppConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Masses Social',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.massessocial.com',
  );

  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  // Environment checks
  static bool get isDevelopment => flavor == 'dev' || kDebugMode;
  static bool get isStaging => flavor == 'staging';
  static bool get isProduction => flavor == 'prod' && kReleaseMode;

  // Feature flags (will integrate with Firebase Remote Config)
  static bool get enableAIRecommendations =>
      isDevelopment || isStaging || isProduction;
  static bool get enableAnalytics => !isDevelopment;
  static bool get enableCrashlytics => !isDevelopment;

  // RSS Configuration
  static int get rssRefreshIntervalMinutes => isDevelopment ? 5 : 15;
  static int get maxRSSItemsPerCreator => 50;

  // Debug settings
  static bool get showDebugInfo => isDevelopment;
  static bool get verboseLogging => isDevelopment;

  @override
  String toString() {
    return 'AppConfig(flavor: $flavor, isDev: $isDevelopment, isStaging: $isStaging, isProd: $isProduction)';
  }
}
