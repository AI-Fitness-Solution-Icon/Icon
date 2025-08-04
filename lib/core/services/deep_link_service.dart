import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

import 'package:logger/logger.dart';

/// Service for handling deep links and app links
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  final Logger _logger = Logger();
  GoRouter? _router;
  
  /// Stream of incoming deep links
  Stream<Uri> get linkStream => _appLinks.uriLinkStream;
  
  /// Stream of incoming app links
  Stream<Uri> get appLinkStream => _appLinks.uriLinkStream;
  
  /// Stream of all incoming links (deep links + app links)
  Stream<Uri> get allLinkStream => _appLinks.uriLinkStream;

  /// Set the router instance for navigation
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// Initialize the deep link service
  Future<void> initialize() async {
    try {
      // Get the initial link if the app was launched from a deep link
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _logger.i('Initial deep link: $initialLink');
        _handleDeepLink(initialLink);
      }

      // Listen for incoming deep links
      _appLinks.uriLinkStream.listen((Uri uri) {
        _logger.i('Deep link received: $uri');
        _handleDeepLink(uri);
      });

      _logger.i('Deep link service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize deep link service: $e');
    }
  }

  /// Handle incoming deep links
  void _handleDeepLink(Uri uri) {
    try {
      _logger.i('Processing deep link: $uri');
      
      // Parse the deep link and route accordingly
              // final path = uri.path;
        // final queryParameters = uri.queryParameters;
      
      switch (uri.scheme) {
        case 'icon':
          _handleCustomScheme(uri);
          break;
        case 'https':
          _handleHttpsScheme(uri);
          break;
        default:
          _logger.w('Unknown scheme: ${uri.scheme}');
      }
    } catch (e) {
      _logger.e('Error handling deep link: $e');
    }
  }

  /// Handle custom icon:// scheme links
  void _handleCustomScheme(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;
    
    switch (path) {
      case '/profile':
        _navigateToProfile(queryParams);
        break;
      case '/settings':
        _navigateToSettings(queryParams);
        break;
      case '/badge':
        _navigateToBadge(queryParams);
        break;
      case '/feedback':
        _navigateToFeedback(queryParams);
        break;
      case '/help':
        _navigateToHelp(queryParams);
        break;
      default:
        _logger.w('Unknown custom scheme path: $path');
    }
  }

  /// Handle https://icon.com scheme links
  void _handleHttpsScheme(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;
    
    switch (path) {
      case '/profile':
        _navigateToProfile(queryParams);
        break;
      case '/settings':
        _navigateToSettings(queryParams);
        break;
      case '/badge':
        _navigateToBadge(queryParams);
        break;
      case '/feedback':
        _navigateToFeedback(queryParams);
        break;
      case '/help':
        _navigateToHelp(queryParams);
        break;
      case '/privacy':
        _navigateToPrivacyPolicy();
        break;
      case '/terms':
        _navigateToTermsOfService();
        break;
      default:
        _logger.w('Unknown HTTPS scheme path: $path');
    }
  }

  /// Navigate to profile screen
  void _navigateToProfile(Map<String, String> queryParams) {
    final userId = queryParams['userId'];
    final section = queryParams['section'];
    
    _logger.i('Navigating to profile - userId: $userId, section: $section');
    
    if (_router != null) {
      final path = '/profile${userId != null ? '/$userId' : ''}${section != null ? '?section=$section' : ''}';
      _router!.go(path);
    } else {
      _logger.w('Router not set, cannot navigate to profile');
    }
  }

  /// Navigate to settings screen
  void _navigateToSettings(Map<String, String> queryParams) {
    final section = queryParams['section'];
    
    _logger.i('Navigating to settings - section: $section');
    
    if (_router != null) {
      final path = '/settings${section != null ? '?section=$section' : ''}';
      _router!.go(path);
    } else {
      _logger.w('Router not set, cannot navigate to settings');
    }
  }

  /// Navigate to badge screen
  void _navigateToBadge(Map<String, String> queryParams) {
    final badgeId = queryParams['badgeId'];
    final action = queryParams['action'];
    
    _logger.i('Navigating to badge - badgeId: $badgeId, action: $action');
    
    if (_router != null) {
      final path = '/badge${badgeId != null ? '/$badgeId' : ''}${action != null ? '?action=$action' : ''}';
      _router!.go(path);
    } else {
      _logger.w('Router not set, cannot navigate to badge');
    }
  }

  /// Navigate to feedback screen
  void _navigateToFeedback(Map<String, String> queryParams) {
    final type = queryParams['type'];
    final subject = queryParams['subject'];
    
    _logger.i('Navigating to feedback - type: $type, subject: $subject');
    
    if (_router != null) {
      final path = '/feedback${type != null ? '?type=$type' : ''}${subject != null ? '&subject=$subject' : ''}';
      _router!.go(path);
    } else {
      _logger.w('Router not set, cannot navigate to feedback');
    }
  }

  /// Navigate to help screen
  void _navigateToHelp(Map<String, String> queryParams) {
    final topic = queryParams['topic'];
    
    _logger.i('Navigating to help - topic: $topic');
    
    if (_router != null) {
      final path = '/help${topic != null ? '?topic=$topic' : ''}';
      _router!.go(path);
    } else {
      _logger.w('Router not set, cannot navigate to help');
    }
  }

  /// Navigate to privacy policy
  void _navigateToPrivacyPolicy() {
    _logger.i('Navigating to privacy policy');
    
    if (_router != null) {
      _router!.go('/privacy-policy');
    } else {
      _logger.w('Router not set, cannot navigate to privacy policy');
    }
  }

  /// Navigate to terms of service
  void _navigateToTermsOfService() {
    _logger.i('Navigating to terms of service');
    
    if (_router != null) {
      _router!.go('/terms-of-service');
    } else {
      _logger.w('Router not set, cannot navigate to terms of service');
    }
  }

  /// Generate a deep link URL for the app
  static String generateDeepLink({
    required String path,
    Map<String, String>? queryParameters,
    bool useHttps = false,
  }) {
    // final scheme = useHttps ? 'https://icon.com' : 'icon://';
    final uri = Uri(
      scheme: useHttps ? 'https' : 'icon',
      host: useHttps ? 'icon.com' : 'open',
      path: path,
      queryParameters: queryParameters,
    );
    
    return uri.toString();
  }

  /// Test deep link examples
  static List<String> getTestDeepLinks() {
    return [
      'icon://profile?userId=123&section=badges',
      'icon://settings?section=notifications',
      'icon://badge?badgeId=456&action=view',
      'icon://feedback?type=bug&subject=app_crash',
      'icon://help?topic=getting_started',
      'https://icon.com/profile?userId=123&section=badges',
      'https://icon.com/settings?section=notifications',
      'https://icon.com/badge?badgeId=456&action=view',
      'https://icon.com/feedback?type=bug&subject=app_crash',
      'https://icon.com/help?topic=getting_started',
      'https://icon.com/privacy',
      'https://icon.com/terms',
    ];
  }
} 