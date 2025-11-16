# MVVMDemo

A simple Android demo application showcasing MVVM (Model-View-ViewModel) architecture with Jetpack Compose.

## Features

- **Login Screen**: Email/Username and password input fields with authentication
- **Registration Screen**: User registration with password confirmation
- **Hello Screen**: Welcome screen displayed after successful login/registration
- **Navigation**: Seamless navigation between screens using Jetpack Navigation Compose

## Architecture

This project follows the MVVM architectural pattern:

- **Model Layer**: Data classes and repository for user management
- **View Layer**: Jetpack Compose UI components
- **ViewModel Layer**: Business logic and state management using LiveData

## Technologies Used

- **Kotlin**: Programming language
- **Jetpack Compose**: Modern UI toolkit
- **AndroidX**: Android support libraries
- **ViewModel**: MVVM component for UI state management
- **LiveData**: Observable data holder
- **Navigation Compose**: Screen navigation

## Getting Started

1. Clone the repository
2. Open the project in Android Studio
3. Build and run the application

## Project Structure

```
app/src/main/java/com/example/mvvmdemo/
├── data/
│   ├── model/          # Data models
│   └── repository/     # Data repository
├── ui/
│   ├── screen/         # Compose screens
│   ├── theme/          # App theme and styling
│   └── viewmodel/      # ViewModels
└── MainActivity.kt     # Main activity
```

## iOS Project

An iOS implementation of MVVMDemo is available under the [`ios/`](ios) directory. The project uses the SwiftUI app lifecycle and is configured for Swift and Objective-C interoperability through a bridging header.

### Requirements
- Xcode 14 or later
- iOS 15.0+ deployment target

### Opening and Running the App
1. Open `ios/MVVMDemo.xcodeproj` in Xcode (double-click the project file or run `open ios/MVVMDemo.xcodeproj` from the terminal).
2. Select an iOS simulator or a connected device.
3. Build and run with `⌘ + R`.

The default SwiftUI entry screen demonstrates the Objective-C bridge by displaying a message generated from the `ObjCHelper` class. For more information about the structure and configuration of the iOS project, refer to [`ios/README.md`](ios/README.md).
