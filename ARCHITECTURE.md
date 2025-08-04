# Icon App Architecture

This document outlines the architecture of the Icon app, a comprehensive AI-powered fitness platform. The goal of this architecture is to create a scalable, maintainable, and testable codebase.

## Core Principles

The architecture is guided by the following principles:

- **Modularity**: The app is divided into independent feature modules, each responsible for a specific domain. This promotes separation of concerns and allows for parallel development.
- **Scalability**: The architecture is designed to accommodate future growth, making it easy to add new features and scale existing ones.
- **Maintainability**: A clear and consistent project structure, along with a well-defined architecture, makes the codebase easy to understand, modify, and debug.
- **Testability**: The architecture is designed to be easily testable, with a clear separation between UI, business logic, and data layers.

## Architectural Pattern

The app follows a **feature-based architecture** with a layered approach. The main layers are:

- **Core Layer**: Contains the foundational code that is shared across all features. This includes constants, models, services, and utilities.
- **Features Layer**: Contains the individual feature modules, such as authentication, workout management, and AI coaching. Each feature is self-contained and has its own UI, business logic, and data access components.
- **Navigation Layer**: Manages the routing and navigation within the app.

## Project Structure

The project is structured as follows:

```
lib/
├── core/
│   ├── constants/          # App-wide constants (e.g., API keys, routes)
│   ├── models/             # Data models (e.g., User, Workout)
│   ├── services/           # External service integrations (e.g., Supabase, OpenAI)
│   ├── repositories/       # Data access layer (e.g., AuthRepository, WorkoutRepository)
│   └── utils/              # Utility functions and helpers
├── features/
│   ├── auth/
│   │   ├── data/           # Data sources (e.g., API client, local storage)
│   │   ├── domain/         # Business logic (e.g., use cases, providers)
│   │   └── presentation/   # UI components (e.g., screens, widgets)
│   ├── workout/
│   ├── ai_coach/
│   ├── subscription/
│   └── settings/
└── navigation/
    ├── app_router.dart     # Go Router configuration
    ├── bottom_nav_bar.dart # Bottom navigation bar
    └── route_names.dart    # Route names and paths
```

## Data Flow

The data flow in the app follows a unidirectional pattern:

1.  **UI Layer (Presentation)**: The UI components (widgets and screens) are responsible for displaying the data and capturing user input. They use `Provider` to listen for state changes and trigger actions.
2.  **Business Logic Layer (Domain)**: The business logic is handled by `ChangeNotifierProvider`s, which contain the state and the business logic for a specific feature. They interact with the data layer to fetch and update data.
3.  **Data Layer (Data)**: The data layer is responsible for fetching and storing data. It consists of repositories that abstract the data sources (e.g., API, local database).

## State Management

The app uses the `Provider` package for state management. `ChangeNotifierProvider` is used to manage the state of each feature.

- Each feature should have its own `ChangeNotifierProvider` to manage its state.
- The UI components should use `Consumer` or `context.watch` to listen for state changes and rebuild when the state changes.
- The UI components should use `context.read` to call methods on the provider to update the state.

## UI and Theming

The app should have a consistent look and feel, which is achieved through a design system.

- **Theme**: The app should have a well-defined theme that includes colors, typography, and other UI elements.
- **Widgets**: Reusable UI components should be created as widgets and placed in a `widgets` directory within each feature.
- **Styling**: The UI should be styled using the `ThemeData` and the design system.

## Testing

The app should have a comprehensive test suite that includes:

- **Unit Tests**: Test the business logic in the providers and the data layer.
- **Widget Tests**: Test the UI components in isolation.
- **Integration Tests**: Test the integration between the different layers of the app.

Tests should be placed in the `test` directory, following the same structure as the `lib` directory.

## Code Style and Conventions

The project follows the official Flutter and Dart code style guidelines. The `flutter_lints` package is used to enforce these guidelines.

- **File Naming**: Files should be named using `snake_case.dart`.
- **Class Naming**: Classes should be named using `PascalCase`.
- **Variable Naming**: Variables should be named using `camelCase`.
- **Imports**: Imports should be organized and sorted.

By following this architecture, we can ensure that the Icon app is a high-quality, scalable, and maintainable product.
