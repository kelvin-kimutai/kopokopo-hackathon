import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get k2BaseUrl => dotenv.env['K2_BASE_URL'] ?? 'sandbox.kopokopo.com';
  static String get k2ClientId => dotenv.env['K2_CLIENT_ID'] ?? '';
  static String get k2ClientSecret => dotenv.env['K2_CLIENT_SECRET'] ?? '';
  static String get k2ApiKey => dotenv.env['K2_API_KEY'] ?? '';
  static String get k2TillNumber => dotenv.env['K2_TILL_NUMBER'] ?? '';
  static String get k2CallbackUrl => dotenv.env['K2_CALLBACK_URL'] ?? '';

  static bool get isConfigured {
    return k2ClientId.isNotEmpty &&
        k2ClientSecret.isNotEmpty &&
        k2ApiKey.isNotEmpty &&
        k2TillNumber.isNotEmpty &&
        k2CallbackUrl.isNotEmpty;
  }

  static const String conferenceTitle = 'FlutterConKE25';
  static const String conferenceSubtitle = 'The First FlutterCon in Africa';
  static const String conferenceDates = '5th - 7th November 2025';
  static const String conferenceVenue = 'Golden Tulip Westlands Nairobi';
}

