# Deep Link Implementation Guide

## Overview

The Icon App supports deep linking through both custom URL schemes (`icon://`) and universal links (`https://icon.com`). This implementation allows users to navigate directly to specific screens within the app from external sources like emails, web links, or other apps.

## Supported URL Schemes

### 1. Custom Scheme: `icon://`
- **Format**: `icon://open/path?parameters`
- **Example**: `icon://open/profile?userId=123&section=badges`

### 2. Universal Links: `https://icon.com`
- **Format**: `https://icon.com/path?parameters`
- **Example**: `https://icon.com/profile?userId=123&section=badges`

## Supported Paths and Parameters

### Profile Navigation
```
icon://open/profile?userId=123&section=badges
https://icon.com/profile?userId=123&section=badges
```
- `userId` (optional): User ID to view
- `section` (optional): Profile section to display (badges, settings, etc.)

### Settings Navigation
```
icon://open/settings?section=notifications
https://icon.com/settings?section=notifications
```
- `section` (optional): Settings section to display

### Badge Navigation
```
icon://open/badge?badgeId=456&action=view
https://icon.com/badge?badgeId=456&action=view
```
- `badgeId` (required): Badge ID to display
- `action` (optional): Action to perform (view, claim, etc.)

### Feedback Navigation
```
icon://open/feedback?type=bug&subject=app_crash
https://icon.com/feedback?type=bug&subject=app_crash
```
- `type` (optional): Feedback type (bug, feature, general)
- `subject` (optional): Subject line for the feedback

### Help Navigation
```
icon://open/help?topic=getting_started
https://icon.com/help?topic=getting_started
```
- `topic` (optional): Help topic to display

### Legal Pages
```
https://icon.com/privacy
https://icon.com/terms
```

## Implementation Details

### 1. Platform Configuration

#### iOS (Info.plist)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.icon.app</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>icon</string>
        </array>
    </dict>
</array>
```

#### Android (AndroidManifest.xml)
```xml
<!-- Custom scheme -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="icon" android:host="open" pathPrefix="/" />
</intent-filter>

<!-- Universal links -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="icon.com" android:pathPrefix="/" />
</intent-filter>
```

### 2. Flutter Implementation

#### DeepLinkService
The `DeepLinkService` class handles all deep link processing:

```dart
// Initialize the service
await DeepLinkService().initialize();

// Generate deep links
String link = DeepLinkService.generateDeepLink(
  path: '/profile',
  queryParameters: {'userId': '123'},
  useHttps: false, // Use icon:// scheme
);
```

#### URL Handling
The service automatically:
- Listens for incoming deep links
- Parses URL parameters
- Routes to appropriate screens
- Logs all deep link activity

### 3. Testing

#### Test Screen
Use the `DeepLinkTestScreen` to test deep link functionality:

```dart
// Navigate to test screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DeepLinkTestScreen(),
  ),
);
```

#### Test Links
Predefined test links are available:
- Profile links with various parameters
- Settings navigation
- Badge viewing
- Feedback submission
- Help topics

## Usage Examples

### 1. Sharing Profile Links
```dart
String profileLink = DeepLinkService.generateDeepLink(
  path: '/profile',
  queryParameters: {'userId': user.id, 'section': 'badges'},
  useHttps: true, // Use universal links for sharing
);
```

### 2. Email Deep Links
```dart
String feedbackLink = DeepLinkService.generateDeepLink(
  path: '/feedback',
  queryParameters: {'type': 'bug', 'subject': 'login_issue'},
);
```

### 3. Web Integration
```html
<a href="https://icon.com/profile?userId=123">View Profile</a>
<a href="https://icon.com/badge?badgeId=456">View Badge</a>
```

## Best Practices

### 1. URL Structure
- Use descriptive paths (`/profile`, `/settings`)
- Include relevant parameters
- Keep URLs clean and readable

### 2. Error Handling
- Always validate URL parameters
- Provide fallback navigation
- Log deep link errors for debugging

### 3. User Experience
- Show loading states during navigation
- Provide feedback for successful/failed links
- Handle cases where the app is not installed

### 4. Security
- Validate all incoming parameters
- Sanitize user input
- Implement proper authentication checks

## Troubleshooting

### Common Issues

1. **Links not opening the app**
   - Verify platform configuration
   - Check URL scheme registration
   - Test on physical devices

2. **Navigation not working**
   - Ensure DeepLinkService is initialized
   - Check route configuration
   - Verify parameter parsing

3. **Universal links not working**
   - Verify domain ownership
   - Check Apple App Site Association file
   - Test on iOS devices

### Debugging

1. **Enable logging**
   ```dart
   Logger.level = Level.debug;
   ```

2. **Test with adb (Android)**
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "icon://open/profile?userId=123" com.example.icon_app
   ```

3. **Test with xcrun (iOS)**
   ```bash
   xcrun simctl openurl booted "icon://open/profile?userId=123"
   ```

## Future Enhancements

1. **Analytics Integration**
   - Track deep link usage
   - Monitor conversion rates
   - Analyze user journey

2. **Dynamic Links**
   - Firebase Dynamic Links integration
   - Custom link domains
   - Link analytics

3. **Advanced Routing**
   - Deep link with authentication
   - Conditional navigation
   - A/B testing support

## Dependencies

- `app_links: ^6.4.0` - Deep link handling
- `url_launcher: ^6.3.1` - URL launching
- `logger: ^2.6.1` - Logging

## Files

- `lib/core/services/deep_link_service.dart` - Main deep link service
- `lib/features/deep_links/screens/deep_link_test_screen.dart` - Test screen
- `ios/Runner/Info.plist` - iOS configuration
- `android/app/src/main/AndroidManifest.xml` - Android configuration
- `lib/main.dart` - Service initialization 