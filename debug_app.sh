#!/bin/bash

# WalletFlow Debug Launcher Script
# This script helps debug shell errors and provides fallback mechanisms

echo "🚀 Starting WalletFlow Debug Session..."

# Check Flutter environment
echo "📱 Checking Flutter environment..."
flutter doctor --android-licenses > /dev/null 2>&1 || echo "⚠️  Android licenses may need acceptance"

# Check for common issues
echo "🔍 Checking for common issues..."

# Check if Android SDK is properly configured
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME not set"
fi

# Check for device/emulator
echo "📲 Checking connected devices..."
flutter devices

# Build and run with detailed logging
echo "🔨 Building app with debug info..."
flutter clean
flutter pub get

echo "🏃 Running app with enhanced error reporting..."
flutter run --debug --verbose --enable-software-rendering 2>&1 | tee debug_log.txt

echo "📝 Debug session complete. Check debug_log.txt for details."
