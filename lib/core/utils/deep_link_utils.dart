import 'package:share_plus/share_plus.dart';
import '../services/deep_link_service.dart';
import '../services/url_service.dart';

/// Utility functions for working with deep links
class DeepLinkUtils {
  /// Share a profile link
  static Future<void> shareProfile({
    required String userId,
    String? section,
    String? title,
    String? text,
  }) async {
    // final link = DeepLinkService.generateDeepLink(
    //   path: '/profile',
    //   queryParameters: {
    //     'userId': userId,
    //     if (section != null) 'section': section,
    //   },
    //   useHttps: true, // Use universal links for sharing
    // );

    await Share.share(
      text ?? 'Check out this profile!',
      subject: title ?? 'Icon App Profile',
    );
  }

  /// Share a badge link
  static Future<void> shareBadge({
    required String badgeId,
    String? action,
    String? title,
    String? text,
  }) async {
    // final link = DeepLinkService.generateDeepLink(
    //   path: '/badge',
    //   queryParameters: {
    //     'badgeId': badgeId,
    //     if (action != null) 'action': action,
    //   },
    //   useHttps: true,
    // );

    await Share.share(
      text ?? 'Check out this badge!',
      subject: title ?? 'Icon App Badge',
    );
  }

  /// Generate a feedback link
  static String generateFeedbackLink({
    String? type,
    String? subject,
  }) {
    return DeepLinkService.generateDeepLink(
      path: '/feedback',
      queryParameters: {
        if (type != null) 'type': type,
        if (subject != null) 'subject': subject,
      },
    );
  }

  /// Generate a help link
  static String generateHelpLink({String? topic}) {
    return DeepLinkService.generateDeepLink(
      path: '/help',
      queryParameters: {
        if (topic != null) 'topic': topic,
      },
    );
  }

  /// Generate a settings link
  static String generateSettingsLink({String? section}) {
    return DeepLinkService.generateDeepLink(
      path: '/settings',
      queryParameters: {
        if (section != null) 'section': section,
      },
    );
  }

  /// Open privacy policy
  static Future<bool> openPrivacyPolicy() async {
    return UrlService.openUrl('https://icon.com/privacy');
  }

  /// Open terms of service
  static Future<bool> openTermsOfService() async {
    return UrlService.openUrl('https://icon.com/terms');
  }

  /// Open help center
  static Future<bool> openHelpCenter() async {
    return UrlService.openUrl('https://icon.com/help');
  }

  /// Generate a deep link for email sharing
  static String generateEmailDeepLink({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    return DeepLinkService.generateDeepLink(
      path: path,
      queryParameters: queryParameters,
      useHttps: true, // Use universal links for email
    );
  }

  /// Generate a deep link for social media sharing
  static String generateSocialDeepLink({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    return DeepLinkService.generateDeepLink(
      path: path,
      queryParameters: queryParameters,
      useHttps: true, // Use universal links for social media
    );
  }

  /// Generate a deep link for SMS sharing
  static String generateSmsDeepLink({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    return DeepLinkService.generateDeepLink(
      path: path,
      queryParameters: queryParameters,
      useHttps: false, // Use custom scheme for SMS
    );
  }

  /// Validate a deep link URL
  static bool isValidDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'icon' || 
             (uri.scheme == 'https' && uri.host == 'icon.com');
    } catch (e) {
      return false;
    }
  }

  /// Extract parameters from a deep link URL
  static Map<String, String> extractParameters(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters;
    } catch (e) {
      return {};
    }
  }

  /// Get the path from a deep link URL
  static String? extractPath(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.path;
    } catch (e) {
      return null;
    }
  }

  /// Check if a URL is a custom scheme link
  static bool isCustomScheme(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'icon';
    } catch (e) {
      return false;
    }
  }

  /// Check if a URL is a universal link
  static bool isUniversalLink(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https' && uri.host == 'icon.com';
    } catch (e) {
      return false;
    }
  }
} 