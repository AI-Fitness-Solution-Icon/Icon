#!/bin/bash

# Splash Screen Management Script for Icon App
# This script helps you manage splash screen generation and updates

echo "🎨 Icon App Splash Screen Manager"
echo "=================================="

# Function to generate splash screen
generate_splash() {
    echo "🔄 Generating splash screen..."
    flutter pub get
    flutter pub run flutter_native_splash:create
    echo "✅ Splash screen generated successfully!"
}

# Function to remove splash screen
remove_splash() {
    echo "🗑️  Removing splash screen..."
    flutter pub run flutter_native_splash:remove
    echo "✅ Splash screen removed successfully!"
}

# Function to update splash screen
update_splash() {
    echo "🔄 Updating splash screen..."
    flutter pub run flutter_native_splash:create
    echo "✅ Splash screen updated successfully!"
}

# Function to show help
show_help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  generate  - Generate splash screen for the first time"
    echo "  update    - Update existing splash screen"
    echo "  remove    - Remove splash screen"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 generate"
    echo "  $0 update"
    echo "  $0 remove"
}

# Main script logic
case "$1" in
    "generate")
        generate_splash
        ;;
    "update")
        update_splash
        ;;
    "remove")
        remove_splash
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac 