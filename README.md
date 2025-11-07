# MVVMDemo

A simple Android demo application showcasing MVVM (Model-View-ViewModel) architecture with Jetpack Compose, network integration, and adaptive screen layouts.

## Features

- **Login Screen**: Email/Username and password input with authentication
- **Registration Screen**: User registration with password confirmation and validation
- **Hello Screen**: Welcome screen displayed after successful login/registration
- **Navigation**: Seamless navigation between screens using Jetpack Navigation Compose
- **Network Layer**: Retrofit + RxJava2 integration with comprehensive error handling
- **Notifications**: Login success notifications with permission handling (Android 13+)
- **Screen Adaptation**: Responsive layouts for phones and tablets (portrait/landscape)
- **Material Design 3**: Modern UI following Material Design guidelines

## Architecture

This project follows the MVVM architectural pattern:

- **Model Layer**: Data classes, network models, and repositories for user management
- **View Layer**: Jetpack Compose UI components with responsive layouts
- **ViewModel Layer**: Business logic and state management using LiveData and RxJava2
- **Network Layer**: Retrofit2 with RxJava2 adapters and custom exception handling
- **Repository Pattern**: Separation of data sources (network, local storage)

## Technologies Used

- **Kotlin 1.9.20**: Programming language
- **Jetpack Compose**: Modern declarative UI toolkit
- **Material3**: Material Design 3 components
- **AndroidX**: Android support libraries
- **ViewModel & LiveData**: MVVM components for UI state management
- **Navigation Compose**: Type-safe screen navigation
- **Retrofit2**: HTTP client for network requests
- **RxJava2**: Reactive programming for async operations
- **OkHttp3**: HTTP client with logging interceptor
- **Gson**: JSON serialization/deserialization
- **SharedPreferences**: Local data persistence

## Build Requirements

- **Android Studio**: Arctic Fox or later
- **JDK**: 17 or later
- **Android SDK**: API 34
- **Min SDK**: API 24 (Android 7.0)
- **Target SDK**: API 34 (Android 14)

## Getting Started

### Option 1: Using Android Studio
1. Clone the repository
2. Open the project in Android Studio
3. Sync Gradle files
4. Build and run the application

### Option 2: Using Command Line
1. Clone the repository
2. Set environment variables:
   ```bash
   export JAVA_HOME=/path/to/jdk-17
   export ANDROID_HOME=/path/to/android-sdk
   ```
3. Run the build verification script:
   ```bash
   ./verify-build.sh
   ```
4. Or build manually:
   ```bash
   ./gradlew assembleDebug
   ```

## Build Verification

A build verification script is included to ensure the project compiles successfully:

```bash
./verify-build.sh
```

This script will:
- ✓ Check Java installation
- ✓ Verify Android SDK setup
- ✓ Clean previous builds
- ✓ Build debug APK
- ✓ Verify APK creation

See [VERIFICATION_REPORT.md](VERIFICATION_REPORT.md) for detailed build verification results.

## Project Structure

```
app/src/main/java/com/example/mvvmdemo/
├── data/
│   ├── model/              # Data models (User, LoginRequest, etc.)
│   └── repository/         # Local data repository (SharedPreferences)
├── network/
│   ├── api/                # Retrofit API services
│   ├── exception/          # Custom exception handling
│   ├── repository/         # Network repositories
│   └── response/           # API response wrappers
├── notification/           # Notification manager
├── ui/
│   ├── screen/             # Compose screens (Login, Registration, Hello)
│   ├── theme/              # App theme and styling (Material3)
│   ├── utils/              # UI utilities (responsive layouts, screen adaptation)
│   └── viewmodel/          # ViewModels with network integration
└── MainActivity.kt         # Main activity with navigation setup
```

## Installation & Testing

### Installing the APK
```bash
# Install on connected device/emulator
adb install app/build/outputs/apk/debug/app-debug.apk

# Or use Gradle
./gradlew installDebug
```

### Viewing Logs
```bash
# View all app logs
adb logcat | grep -i mvvmdemo

# View only errors
adb logcat *:E | grep -i mvvmdemo
```

## Usage

### Login Flow
1. Launch the app (opens Login screen)
2. Enter email/username and password
3. On Android 13+, notification permission will be requested
4. Tap "Login" button
5. On success, navigate to Hello screen

### Registration Flow
1. From Login screen, tap "Don't have an account? Register"
2. Enter email/username, password, and confirm password
3. Password must be at least 6 characters
4. Passwords must match
5. Tap "Register" button
6. On success, navigate to Hello screen

### Logout
1. From Hello screen, tap "Logout" button
2. Navigate back to Login screen

## Screen Adaptation

The app automatically adapts to different screen sizes and orientations:

- **Phones (< 600dp)**: Optimized compact layout
- **Tablets (600-720dp)**: Medium-sized layout with adjusted spacing
- **Large Tablets (> 720dp)**: Wide layout with maximum form width
- **Landscape Mode**: Adjusted padding and layout constraints
- **Notch/Cutout Support**: Proper handling for modern devices

## Network Configuration

The app uses Retrofit with RxJava2 for network operations. Currently configured with mock implementations for demonstration purposes.

To connect to a real backend:
1. Update `NetworkConfig.kt` with your API base URL
2. Implement real API endpoints in `AuthService.kt` and `UserService.kt`
3. Update repository implementations to use real network calls

## Documentation

- [VERIFICATION_REPORT.md](VERIFICATION_REPORT.md) - Build verification results
- [NETWORK_FRAMEWORK.md](NETWORK_FRAMEWORK.md) - Network layer documentation
- [SCREEN_ADAPTATION.md](SCREEN_ADAPTATION.md) - Screen adaptation guide
- [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - Integration instructions

## License

This is a demo project for educational purposes.
