# Icon App - AI Development Prompts

This directory contains modular prompts designed to guide AI agents (Cursor, Gemini, etc.) in implementing specific features of the Icon fitness app. Each prompt is focused on a particular aspect of the application and follows the established architecture patterns.

## How to Use These Prompts

### 1. **With Cursor**
- Copy the content of any `.prompt` file
- Use Cursor's built-in prompt system or chat interface
- Paste the prompt and let the AI implement the feature

### 2. **With Other AI Tools**
- Use these prompts with Gemini, Claude, or other AI coding assistants
- Modify prompts as needed for your specific AI tool
- Follow the established patterns and architecture

### 3. **Development Workflow**
1. Start with `project_setup.prompt` for initial setup
2. Use `core_services.prompt` for foundational services
3. Implement features using specific feature prompts
4. Use `testing.prompt` for comprehensive testing
5. Follow up with `integration.prompt` for final integration

## Prompt Categories

### 🏗️ **Foundation Prompts**
- `project_setup.prompt` - Initial project structure and configuration
- `core_services.prompt` - Core service integrations (Supabase, OpenAI, Stripe)
- `env_setup.prompt` - Environment configuration and security
- `navigation.prompt` - Routing and navigation setup

### 🔐 **Authentication & Security**
- `auth_module.prompt` - Complete authentication system with Supabase
- `security.prompt` - Security best practices and implementation

### 🏋️ **Core Features**
- `workout_module.prompt` - Workout management and tracking
- `ai_coach.prompt` - AI coaching integration with OpenAI
- `voice_services.prompt` - Voice interaction (speech-to-text, text-to-speech)
- `subscription_module.prompt` - Stripe subscription management

### 🎨 **UI & UX**
- `ui_components.prompt` - Reusable UI components and design system
- `theming.prompt` - App theming and styling
- `accessibility.prompt` - Accessibility features and compliance

### 🧪 **Testing & Quality**
- `testing.prompt` - Comprehensive testing strategy
- `performance.prompt` - Performance optimization
- `error_handling.prompt` - Error handling and user feedback

### 🔧 **Advanced Features**
- `analytics.prompt` - Analytics and tracking implementation
- `offline_support.prompt` - Offline functionality and data sync
- `localization.prompt` - Internationalization and localization
- `push_notifications.prompt` - Push notification system

### 📱 **Platform Specific**
- `ios_optimization.prompt` - iOS-specific optimizations
- `android_optimization.prompt` - Android-specific optimizations
- `deep_links.prompt` - Deep linking implementation

## Architecture Compliance

All prompts are designed to follow the established architecture:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── models/             # Data models
│   ├── services/           # External services
│   ├── repositories/       # Data access
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── workout/           # Workout management
│   ├── ai_coach/          # AI coaching
│   ├── subscription/      # Subscription management
│   └── settings/          # App settings
└── navigation/            # Navigation
```

## State Management

All prompts follow the Provider pattern:
- Use `ChangeNotifier` for state management
- Implement proper loading states
- Handle errors gracefully
- Follow unidirectional data flow

## Best Practices

### 1. **Code Quality**
- Follow Flutter and Dart best practices
- Use proper error handling
- Implement comprehensive testing
- Maintain code documentation

### 2. **Performance**
- Optimize widget rebuilds
- Use const constructors
- Implement proper caching
- Handle large datasets efficiently

### 3. **Security**
- Never hardcode sensitive data
- Use environment variables
- Implement proper validation
- Secure data transmission

### 4. **User Experience**
- Provide clear feedback
- Handle loading states
- Implement proper error messages
- Consider accessibility

## Customization

Feel free to customize these prompts for your specific needs:

1. **Modify Architecture**: Adjust prompts to match your preferred architecture
2. **Add Features**: Create new prompts for additional features
3. **Update Dependencies**: Modify prompts to use different packages
4. **Platform Specific**: Adapt prompts for specific platform requirements

## Contributing

When adding new prompts:

1. Follow the established naming convention
2. Include clear instructions and examples
3. Reference existing architecture patterns
4. Include testing considerations
5. Update this README with new prompt descriptions

## Support

For questions about using these prompts or the Icon app architecture:

1. Check the main project README.md
2. Review the ARCHITECTURE.md file
3. Examine existing code examples
4. Follow the established patterns in the codebase

---

**Note**: These prompts are designed to work with the existing Icon app codebase. Make sure to review the current implementation before using any prompt to ensure compatibility and avoid conflicts. 