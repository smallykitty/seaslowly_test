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
