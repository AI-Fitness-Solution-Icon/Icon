# Icon App - Prompts Summary

This document provides an overview of all the prompts available for developing the Icon fitness app with AI assistance.

## 🏗️ Foundation Prompts

### 1. `project_setup.prompt`
**Purpose**: Initial project structure and configuration
**What it creates**:
- Complete folder structure following clean architecture
- Core constants (app constants, API endpoints, strings, themes)
- Main app configuration
- Environment setup
- Dependencies configuration

**Use when**: Starting a new project or restructuring existing codebase

### 2. `core_services.prompt`
**Purpose**: Core service integrations
**What it creates**:
- Supabase service for backend operations
- OpenAI service for AI interactions
- Stripe service for payment processing
- Voice service for speech-to-text and text-to-speech
- Analytics service for tracking

**Use when**: Setting up external service integrations

### 3. `navigation.prompt`
**Purpose**: Routing and navigation setup
**What it creates**:
- Route names and constants
- Go Router configuration
- Navigation service
- Route guards and authentication
- Route transitions and animations

**Use when**: Implementing app navigation and routing

## 🔐 Authentication & Security

### 4. `auth_module.prompt`
**Purpose**: Complete authentication system
**What it creates**:
- User models and data structures
- Authentication repository
- Auth provider with state management
- Login, signup, and profile screens
- Password reset functionality
- Social authentication

**Use when**: Implementing user authentication and profile management

## 🏋️ Core Features

### 5. `workout_module.prompt`
**Purpose**: Workout management and tracking
**What it creates**:
- Workout, exercise, and session models
- Workout repository for data access
- Workout provider for state management
- Workout tracking and progress monitoring
- Exercise library management

**Use when**: Building workout-related features

### 6. `ai_coach.prompt`
**Purpose**: AI coaching integration
**What it creates**:
- AI coach models and data structures
- AI coach repository with OpenAI integration
- AI coach provider for state management
- Voice interaction capabilities
- Personalized recommendations

**Use when**: Implementing AI-powered coaching features

### 7. `voice_services.prompt`
**Purpose**: Voice interaction features
**What it creates**:
- Speech-to-text functionality
- Text-to-speech capabilities
- Voice command processing
- Background voice listening
- Voice mode toggles

**Use when**: Adding voice interaction to the app

### 8. `subscription_module.prompt`
**Purpose**: Subscription management
**What it creates**:
- Subscription models and plans
- Stripe integration for payments
- Subscription provider
- Payment processing
- Subscription status management

**Use when**: Implementing subscription and payment features

## 🎨 UI & UX

### 9. `ui_components.prompt`
**Purpose**: Reusable UI components
**What it creates**:
- Common UI widgets
- Form components
- Loading states
- Error handling components
- Custom buttons and inputs

**Use when**: Building consistent UI components

### 10. `theming.prompt`
**Purpose**: App theming and styling
**What it creates**:
- Material Design 3 theme
- Color schemes
- Typography styles
- Component themes
- Dark/light mode support

**Use when**: Implementing app styling and theming

### 11. `accessibility.prompt`
**Purpose**: Accessibility features
**What it creates**:
- Screen reader support
- Semantic labels
- Accessibility widgets
- Keyboard navigation
- High contrast support

**Use when**: Making the app accessible

## 🧪 Testing & Quality

### 12. `testing.prompt`
**Purpose**: Comprehensive testing strategy
**What it creates**:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests
- Mock data and services
- Test utilities

**Use when**: Implementing testing for the app

### 13. `performance.prompt`
**Purpose**: Performance optimization
**What it creates**:
- Widget optimization
- Memory management
- Image caching
- Lazy loading
- Performance monitoring

**Use when**: Optimizing app performance

### 14. `error_handling.prompt`
**Purpose**: Error handling and user feedback
**What it creates**:
- Error handling utilities
- User-friendly error messages
- Error reporting
- Retry mechanisms
- Fallback strategies

**Use when**: Implementing robust error handling

## 🔧 Advanced Features

### 15. `analytics.prompt`
**Purpose**: Analytics and tracking
**What it creates**:
- Event tracking
- User analytics
- Performance metrics
- Conversion tracking
- Analytics dashboard

**Use when**: Adding analytics to the app

### 16. `offline_support.prompt`
**Purpose**: Offline functionality
**What it creates**:
- Offline data storage
- Sync mechanisms
- Conflict resolution
- Offline indicators
- Data persistence

**Use when**: Implementing offline capabilities

### 17. `localization.prompt`
**Purpose**: Internationalization
**What it creates**:
- Multi-language support
- Localized strings
- RTL support
- Cultural adaptations
- Translation management

**Use when**: Adding multi-language support

### 18. `push_notifications.prompt`
**Purpose**: Push notification system
**What it creates**:
- Notification handling
- Push token management
- Notification scheduling
- Deep linking from notifications
- Notification preferences

**Use when**: Implementing push notifications

## 📱 Platform Specific

### 19. `ios_optimization.prompt`
**Purpose**: iOS-specific optimizations
**What it creates**:
- iOS-specific configurations
- Platform-specific UI
- iOS permissions
- App Store optimization
- iOS-specific features

**Use when**: Optimizing for iOS

### 20. `android_optimization.prompt`
**Purpose**: Android-specific optimizations
**What it creates**:
- Android-specific configurations
- Platform-specific UI
- Android permissions
- Play Store optimization
- Android-specific features

**Use when**: Optimizing for Android

### 21. `deep_links.prompt`
**Purpose**: Deep linking implementation
**What it creates**:
- URL scheme handling
- Universal links
- Deep link routing
- Link validation
- Link analytics

**Use when**: Implementing deep linking

## 🚀 Development Workflow

### Recommended Order of Implementation:

1. **Start with Foundation**:
   - `project_setup.prompt`
   - `core_services.prompt`
   - `navigation.prompt`

2. **Add Authentication**:
   - `auth_module.prompt`

3. **Implement Core Features**:
   - `workout_module.prompt`
   - `ai_coach.prompt`
   - `voice_services.prompt`
   - `subscription_module.prompt`

4. **Enhance UI/UX**:
   - `ui_components.prompt`
   - `theming.prompt`
   - `accessibility.prompt`

5. **Add Quality Assurance**:
   - `testing.prompt`
   - `performance.prompt`
   - `error_handling.prompt`

6. **Implement Advanced Features**:
   - `analytics.prompt`
   - `offline_support.prompt`
   - `localization.prompt`
   - `push_notifications.prompt`

7. **Platform Optimization**:
   - `ios_optimization.prompt`
   - `android_optimization.prompt`
   - `deep_links.prompt`

## 📋 Usage Instructions

### For Cursor:
1. Copy the content of any `.prompt` file
2. Use Cursor's built-in prompt system
3. Paste the prompt and let AI implement the feature

### For Other AI Tools:
1. Modify prompts as needed for your specific AI tool
2. Follow the established patterns and architecture
3. Ensure compatibility with existing codebase

### Best Practices:
1. **Review Existing Code**: Check current implementation before using prompts
2. **Follow Architecture**: Maintain clean architecture patterns
3. **Test Thoroughly**: Test all implemented features
4. **Document Changes**: Update documentation as needed
5. **Iterate**: Refine implementations based on feedback

## 🎯 Success Metrics

After using these prompts, you should have:
- ✅ Complete project structure
- ✅ All core features implemented
- ✅ Proper state management
- ✅ Comprehensive testing
- ✅ Performance optimization
- ✅ Platform-specific features
- ✅ Production-ready codebase

## 📞 Support

For questions about using these prompts:
1. Check the main project README.md
2. Review the ARCHITECTURE.md file
3. Examine existing code examples
4. Follow the established patterns

---

**Note**: These prompts are designed to work with the existing Icon app codebase. Always review current implementation before using any prompt to ensure compatibility and avoid conflicts. 