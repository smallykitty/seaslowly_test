#!/bin/bash

# MVVM Demo Build Verification Script
# This script verifies that the project can be successfully compiled

set -e

echo "======================================"
echo "MVVM Demo - Build Verification Script"
echo "======================================"
echo ""

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Java
echo "Checking Java installation..."
if java -version 2>&1 | grep -q "openjdk version"; then
    echo -e "${GREEN}✓${NC} Java is installed"
    java -version 2>&1 | head -1
else
    echo -e "${RED}✗${NC} Java is not installed"
    exit 1
fi
echo ""

# Check Android SDK
echo "Checking Android SDK..."
if [ -d "$ANDROID_HOME" ]; then
    echo -e "${GREEN}✓${NC} Android SDK is installed at: $ANDROID_HOME"
else
    echo -e "${RED}✗${NC} Android SDK is not found"
    exit 1
fi
echo ""

# Check if gradlew exists
echo "Checking Gradle wrapper..."
if [ -f "./gradlew" ]; then
    echo -e "${GREEN}✓${NC} Gradle wrapper found"
else
    echo -e "${RED}✗${NC} Gradle wrapper not found"
    exit 1
fi
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
./gradlew clean --no-daemon
echo -e "${GREEN}✓${NC} Clean completed"
echo ""

# Build debug APK
echo "Building debug APK..."
echo "This may take a few minutes..."
echo ""
if ./gradlew assembleDebug --no-daemon; then
    echo ""
    echo -e "${GREEN}✓ BUILD SUCCESSFUL${NC}"
    echo ""
    
    # Check if APK was created
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        APK_SIZE=$(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)
        echo -e "${GREEN}✓${NC} APK file created: app-debug.apk"
        echo "  Size: $APK_SIZE"
        echo "  Location: app/build/outputs/apk/debug/"
        echo ""
        
        # Show APK info
        echo "APK Details:"
        ls -lh app/build/outputs/apk/debug/app-debug.apk
        echo ""
        
        echo -e "${GREEN}======================================"
        echo "BUILD VERIFICATION: PASSED ✓"
        echo "======================================${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Install APK on device: adb install app/build/outputs/apk/debug/app-debug.apk"
        echo "2. Launch app and test functionality"
        echo "3. Check Logcat: adb logcat | grep -i mvvmdemo"
        echo ""
        exit 0
    else
        echo -e "${RED}✗${NC} APK file was not created"
        exit 1
    fi
else
    echo ""
    echo -e "${RED}✗ BUILD FAILED${NC}"
    echo ""
    echo "Please check the error messages above."
    echo ""
    echo -e "${RED}======================================"
    echo "BUILD VERIFICATION: FAILED ✗"
    echo "======================================${NC}"
    exit 1
fi
