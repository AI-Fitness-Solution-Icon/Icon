# Splash Screen Management

This document explains how to manage splash screens in the Icon app using the `flutter_native_splash` package.

## Overview

The Icon app uses `flutter_native_splash` to create native splash screens that display while the app is loading. This provides a better user experience compared to Flutter-based splash screens.

## Setup

### Prerequisites

- Flutter SDK installed
- `flutter_native_splash` package (already added to dev_dependencies)

### Configuration

The splash screen is configured in `flutter_native_splash.yaml` in the project root. The current configuration includes:

- **Background Color**: Dark theme (`#1E1E1E`)
- **Logo Image**: `assets/images/splash_logo.png`
- **Image Size**: 120x120 pixels
- **Fullscreen Mode**: Enabled
- **Multi-platform Support**: iOS, Android, Web, Windows, macOS, Linux
- **Android 12+ Support**: Configured for modern Android devices

## Usage

### Quick Commands

Use the provided script for easy splash screen management:

```bash
# Generate splash screen for the first time
./scripts/splash_screen.sh generate

# Update existing splash screen
./scripts/splash_screen.sh update

# Remove splash screen
./scripts/splash_screen.sh remove

# Show help
./scripts/splash_screen.sh help
```

### Manual Commands

If you prefer to run commands directly:

```bash
# Generate splash screen
flutter pub run flutter_native_splash:create

# Remove splash screen
flutter pub run flutter_native_splash:remove
```

## Customization

### Changing the Logo

1. Replace `assets/images/splash_logo.png` with your new logo
2. Ensure the image is:
   - PNG format
   - Square aspect ratio (recommended: 512x512 or higher)
   - Transparent background (optional)
3. Run: `./scripts/splash_screen.sh update`

### Changing Background Color

Edit `flutter_native_splash.yaml`:

```yaml
flutter_native_splash:
  background_color: "#YOUR_COLOR_HERE"
  android_12:
    background_color: "#YOUR_COLOR_HERE"
```

Then run: `./scripts/splash_screen.sh update`

### Adding Background Image

Edit `flutter_native_splash.yaml`:

```yaml
flutter_native_splash:
  background_image: "assets/images/splash_bg.png"
```

Then run: `./scripts/splash_screen.sh update`

### Dark Mode Support

To add dark mode support, edit `flutter_native_splash.yaml`:

```yaml
flutter_native_splash:
  image: "assets/images/splash_logo.png"
  image_dark: "assets/images/splash_logo_dark.png"
  android_12:
    image: "assets/images/splash_logo.png"
    image_dark: "assets/images/splash_logo_dark.png"
```

### Adding Branding

To add a branding image below the main logo:

```yaml
flutter_native_splash:
  branding: "assets/images/branding.png"
  branding_mode: bottom
```

## Platform-Specific Configuration

### Android

The configuration includes Android 12+ support with:
- Adaptive icons
- Splash screen API
- Proper theming

### iOS

iOS splash screens are automatically generated with:
- Proper scaling for different devices
- Safe area handling
- Status bar integration

### Web

Web splash screens include:
- Responsive design
- Loading indicators
- Browser compatibility

## Troubleshooting

### Common Issues

1. **Splash screen not updating**
   - Run `flutter clean` before generating
   - Ensure assets are properly referenced

2. **Image not displaying**
   - Check image path in `flutter_native_splash.yaml`
   - Verify image format (PNG recommended)
   - Ensure image exists in assets directory

3. **Build errors**
   - Run `flutter pub get` before generating
   - Check for syntax errors in `flutter_native_splash.yaml`

### Debugging

To debug splash screen issues:

```bash
# Clean and rebuild
flutter clean
flutter pub get
./scripts/splash_screen.sh update

# Check generated files
ls android/app/src/main/res/drawable*
ls ios/Runner/Assets.xcassets/LaunchImage.imageset/
```

## Best Practices

1. **Image Quality**: Use high-resolution images (512x512 or higher)
2. **File Size**: Keep images under 1MB for faster loading
3. **Consistency**: Use the same logo across all platforms
4. **Testing**: Test on multiple devices and orientations
5. **Performance**: Optimize images for web and mobile

## File Structure

```
icon_app/
├── flutter_native_splash.yaml    # Configuration file
├── scripts/
│   └── splash_screen.sh         # Management script
├── assets/
│   └── images/
│       ├── splash_logo.png      # Main logo
│       └── splash_bg.png        # Background (optional)
└── docs/
    └── SPLASH_SCREEN.md         # This documentation
```

## Version History

- **v1.0**: Initial setup with dark theme and basic logo support
- **v1.1**: Added Android 12+ support and management script
- **v1.2**: Added comprehensive documentation and troubleshooting guide 