import 'package:url_launcher/url_launcher.dart';

/// Service for handling URL operations
class UrlService {
  /// Opens a URL in the default browser
  static Future<bool> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens an email client with a pre-filled email
  static Future<bool> openEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens a phone dialer with a phone number
  static Future<bool> openPhone(String phoneNumber) async {
    try {
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens a feedback email with pre-filled content
  static Future<bool> openFeedbackEmail({
    String? subject,
    String? body,
  }) async {
    return openEmail(
      email: 'support@iconapp.com',
      subject: subject ?? 'App Feedback',
      body: body ?? 'Please provide your feedback here...',
    );
  }

  /// Opens privacy policy URL
  static Future<bool> openPrivacyPolicy() async {
    return openUrl('https://iconapp.com/privacy-policy');
  }

  /// Opens terms of service URL
  static Future<bool> openTermsOfService() async {
    return openUrl('https://iconapp.com/terms-of-service');
  }

  /// Opens help center URL
  static Future<bool> openHelpCenter() async {
    return openUrl('https://iconapp.com/help');
  }

  /// Opens app store rating page
  static Future<bool> openAppStoreRating() async {
    // TODO: Replace with actual app store URL
    return openUrl('https://apps.apple.com/app/icon-fitness/id123456789');
  }

  /// Opens Google Play store rating page
  static Future<bool> openPlayStoreRating() async {
    // TODO: Replace with actual play store URL
    return openUrl('https://play.google.com/store/apps/details?id=com.iconapp.fitness');
  }
} 