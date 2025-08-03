# Icon - AI-Powered Fitness App

Icon is a comprehensive AI-powered fitness platform built with Flutter, designed to provide personalized workout experiences through intelligent coaching and advanced tracking capabilities.

## Features

- **AI-Powered Coaching**: Personalized workout recommendations and real-time guidance
- **Voice Interaction**: Natural language communication with AI coach
- **Workout Tracking**: Comprehensive exercise and progress monitoring
- **Subscription Management**: Flexible subscription plans with Stripe integration
- **Cross-Platform**: Native mobile experience on iOS and Android

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **AI Services**: OpenAI API
- **Voice Services**: Speech-to-Text and Text-to-Speech
- **Payments**: Stripe
- **State Management**: Provider
- **Navigation**: Go Router

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and configuration
│   ├── models/             # Data models
│   ├── services/           # External service integrations
│   └── utils/              # Utility functions and helpers
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── workout/           # Workout management
│   ├── ai_coach/          # AI coaching
│   ├── subscription/      # Subscription management
│   └── settings/          # App settings
└── navigation/            # Navigation configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd icon_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure environment variables:
   - Create a `.env` file in the root directory
   - Add your API keys for Supabase, OpenAI, and Stripe

4. Run the app:
   ```bash
   flutter run
   ```

## Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# Supabase Configuration
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key

# OpenAI Configuration
OPENAI_API_KEY=your-openai-api-key

# Stripe Configuration
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key

# Voice Synthesis API Configuration
VOICE_API_KEY=your-voice-api-key
```

## Development

### Code Style

This project follows Flutter's recommended coding standards and uses `flutter_lints` for code quality enforcement.

### Testing

Run tests with:
```bash
flutter test
```

### Building

Build for production:
```bash
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.
