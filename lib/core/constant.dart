// lib/core/constants.dart
class ApiConstants {
  static const String baseUrl = "https://openlibrary.org";
  static const String coversBaseUrl = "https://covers.openlibrary.org";

  static const String coverSmall = "S";
  static const String coverMedium = "M";
  static const String coverLarge = "L";

  // runtime default (updated by SettingsProvider)
  static String defaultCoverSize = coverMedium;

  // Headers
  static const int networkTimeoutSeconds = 10;
}
