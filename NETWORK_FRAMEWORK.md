# Retrofit and RxJava2 Network Framework

A comprehensive network request framework for the mvvmdemo Android project, providing advanced features such as automatic retry with exponential backoff, unified exception handling, and seamless ViewModel integration.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Installation](#installation)
5. [Quick Start](#quick-start)
6. [Configuration](#configuration)
7. [Usage Examples](#usage-examples)
8. [Error Handling](#error-handling)
9. [Best Practices](#best-practices)
10. [API Reference](#api-reference)

## Overview

The network framework is built on three main technologies:

- **Retrofit 2.9.0** - Type-safe REST client
- **OkHttp 4.11.0** - HTTP client with interceptors and timeouts
- **RxJava2 2.2.21** - Reactive programming for asynchronous operations

It provides a robust, production-ready solution for making network requests in Android applications with proper error handling, automatic retries, and lifecycle management.

## Features

### ✅ Comprehensive Feature Set

- **Automatic Retry with Exponential Backoff**
  - Max 3 retries by default
  - Initial delay: 1000ms, doubles with each retry
  - Smart retry: skips 4xx errors (client errors)

- **Request/Response Logging**
  - Automatic logging of all requests and responses
  - BODY level logging for debugging
  - Logged to Android Log with "RetrofitConfig" tag

- **Configurable Timeouts**
  - Connection timeout: 10 seconds
  - Read timeout: 30 seconds
  - Write timeout: 30 seconds

- **Type-Safe API Definitions**
  - Interface-based API service definitions
  - Compile-time checking of endpoints
  - Support for various HTTP methods (GET, POST, PUT, DELETE, etc.)

- **Unified Exception Handling**
  - Custom sealed exception classes for different error types
  - Automatic exception transformation
  - User-friendly error messages

- **Lifecycle Management**
  - Automatic subscription management
  - Memory leak prevention
  - Proper disposal in ViewModel.onCleared()

- **Repository Pattern**
  - Base repository class with common logic
  - Easy extension for new services
  - Separation of concerns

- **LiveData Integration**
  - Smooth UI state management
  - ViewModel support for Compose
  - Loading state tracking

## Architecture

### Package Structure

```
com.example.mvvmdemo.network/
├── api/
│   ├── AuthService.kt          # Authentication API interface
│   └── UserService.kt          # User API interface
├── config/
│   └── RetrofitConfig.kt       # Retrofit configuration
├── exception/
│   ├── NetworkException.kt     # Exception classes
│   └── ExceptionHandler.kt     # Exception handling logic
├── repository/
│   ├── BaseRepository.kt       # Base repository with common logic
│   ├── AuthRepository.kt       # Authentication repository
│   └── UserNetworkRepository.kt # User repository
├── response/
│   └── ApiResponse.kt          # Generic response wrapper
└── example/
    └── NetworkFrameworkExample.kt  # Usage examples
```

### Data Flow

```
UI (Composable)
    ↓
ViewModel (LoginViewModel extends BaseNetworkViewModel)
    ↓
Repository (AuthRepository extends BaseRepository)
    ↓
API Service (AuthService interface)
    ↓
Retrofit + OkHttp
    ↓
Network Request
    ↓
Exception Handling & Retry Logic
    ↓
Response Parsing (ApiResponse<T>)
    ↓
Back to ViewModel via Single<T>
    ↓
UI Update via LiveData
```

## Installation

### Dependencies

All dependencies are already added in `app/build.gradle`:

```gradle
// Retrofit and OkHttp
implementation 'com.squareup.retrofit2:retrofit:2.9.0'
implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
implementation 'com.squareup.okhttp3:okhttp:4.11.0'
implementation 'com.squareup.okhttp3:logging-interceptor:4.11.0'

// RxJava2
implementation 'io.reactivex.rxjava2:rxjava:2.2.21'
implementation 'io.reactivex.rxjava2:rxandroid:2.1.1'
implementation 'com.squareup.retrofit2:adapter-rxjava2:2.9.0'

// Gson
implementation 'com.google.gson:gson:2.10.1'
```

### Permissions

Internet permission is required in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Already configured in the project.

## Quick Start

### 1. Define API Service

```kotlin
interface AuthService {
    @POST("auth/login")
    fun login(@Body request: LoginRequest): Single<ApiResponse<User>>
}
```

### 2. Create Repository

```kotlin
class AuthRepository : BaseRepository() {
    private val authService: AuthService = 
        RetrofitConfig.getRetrofit().create(AuthService::class.java)

    fun login(request: LoginRequest): Single<User> {
        return executeRequest(authService.login(request))
    }
}
```

### 3. Use in ViewModel

```kotlin
class LoginViewModel(
    application: Application,
    private val authRepository: AuthRepository = AuthRepository()
) : BaseNetworkViewModel(application) {

    fun login() {
        executeNetworkRequest(
            request = authRepository.login(LoginRequest(email, password)),
            onSuccess = { user ->
                // Handle success
            },
            onError = { exception ->
                // Handle error
            }
        )
    }
}
```

### 4. Observe in UI

```kotlin
@Composable
fun LoginScreen(viewModel: LoginViewModel = viewModel()) {
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()

    Button(
        onClick = { viewModel.login() },
        enabled = !isLoading
    ) {
        Text("Login")
    }

    errorMessage?.let {
        Text(it, color = MaterialTheme.colorScheme.error)
    }
}
```

## Configuration

### Base URL

Update in `RetrofitConfig.kt`:

```kotlin
private const val BASE_URL = "https://api.yourdomain.com/"
```

### Timeouts

```kotlin
private const val CONNECTION_TIMEOUT = 10L    // seconds
private const val READ_TIMEOUT = 30L          // seconds
private const val WRITE_TIMEOUT = 30L         // seconds
```

### Retry Configuration

In `BaseRepository.executeRequest()`:

```kotlin
fun <T> executeRequest(
    request: Single<ApiResponse<T>>,
    maxRetries: Int = 3,
    initialDelay: Long = 1000
): Single<T>
```

### Custom Headers

Add interceptor in `RetrofitConfig.createOkHttpClient()`:

```kotlin
.addInterceptor { chain ->
    val request = chain.request().newBuilder()
        .addHeader("Authorization", "Bearer token")
        .addHeader("X-Custom-Header", "value")
        .build()
    chain.proceed(request)
}
```

## Usage Examples

### Example 1: Simple Login

```kotlin
// ViewModel
fun login() {
    executeNetworkRequest(
        request = authRepository.login(LoginRequest(email, password)),
        onSuccess = { user ->
            _loginSuccess.value = true
        }
    )
}

// UI
Button(onClick = { viewModel.login() }) {
    Text("Login")
}
```

### Example 2: Error Handling with Specific Types

```kotlin
executeNetworkRequest(
    request = userRepository.getUser(userId),
    onSuccess = { user -> /* show user */ },
    onError = { exception ->
        when (exception) {
            is NetworkException.TimeoutError -> 
                showRetryDialog()
            is NetworkException.ConnectionError -> 
                showConnectionError()
            is NetworkException.ClientError -> 
                showValidationError()
            else -> 
                showGenericError(exception.message)
        }
    }
)
```

### Example 3: Loading State Management

```kotlin
val isLoading by viewModel.isLoading.observeAsState(false)

if (isLoading) {
    CircularProgressIndicator()
} else {
    Button(onClick = { viewModel.login() }) {
        Text("Login")
    }
}
```

### Example 4: Multiple Network Calls

```kotlin
// First request
executeNetworkRequest(
    request = repository1.getData(),
    onSuccess = { data1 ->
        // Second request based on first result
        executeNetworkRequest(
            request = repository2.getMoreData(data1.id),
            onSuccess = { data2 ->
                // Handle both results
            }
        )
    }
)
```

## Error Handling

### Exception Types

The framework provides these exception types:

```
NetworkException (sealed class)
├── ConnectionError      - Network connectivity issues
├── TimeoutError        - Request timeout
├── HttpError           - Generic HTTP errors
├── ServerError         - 5xx server errors
├── ClientError         - 4xx client errors
├── ParseException      - JSON parsing failures
└── UnknownError        - Unknown errors
```

### Error Properties

Each exception has:
- `message: String?` - User-friendly error message
- `cause: Throwable?` - Original exception cause

### Retry Behavior

| Error Type | Retried? | Reason |
|-----------|----------|--------|
| TimeoutError | ✅ Yes | Might be temporary |
| ConnectionError | ✅ Yes | Might be temporary |
| ServerError (5xx) | ✅ Yes | Might be temporary |
| ClientError (4xx) | ❌ No | Client error, won't change |
| ParseException | ❌ No | Data format error |
| UnknownError | ✅ Yes | Might be temporary |

### Exponential Backoff

Retry delays follow exponential backoff:

```
Attempt 1: Immediate
Attempt 2: Wait 1000ms (1 second)
Attempt 3: Wait 2000ms (2 seconds)
Attempt 4: Wait 4000ms (4 seconds) - if configured
```

## Best Practices

### 1. Always Extend BaseNetworkViewModel

```kotlin
class MyViewModel(application: Application) 
    : BaseNetworkViewModel(application) {
    // Your code
}
```

### 2. Use executeNetworkRequest() for All Network Calls

```kotlin
executeNetworkRequest(
    request = repository.getData(),
    onSuccess = { data -> /* handle */ },
    onError = { exception -> /* handle */ }
)
```

### 3. Handle Lifecycle Properly

```kotlin
override fun onCleared() {
    super.onCleared()  // Automatically disposes subscriptions
}
```

### 4. Check Loading State Before User Interaction

```kotlin
Button(
    onClick = { viewModel.login() },
    enabled = !isLoading  // Disable while loading
) {
    Text("Login")
}
```

### 5. Display Meaningful Error Messages

```kotlin
errorMessage?.let { 
    Text(it, color = MaterialTheme.colorScheme.error)
}
```

### 6. Use Specific Exception Types in Error Handling

```kotlin
when (exception) {
    is NetworkException.TimeoutError -> handleTimeout()
    is NetworkException.ClientError -> handleClientError()
    else -> handleGenericError()
}
```

## API Reference

### BaseNetworkViewModel

```kotlin
// Properties
val isLoading: LiveData<Boolean>
val networkError: LiveData<NetworkException?>

// Methods
fun <T> executeNetworkRequest(
    request: Single<T>,
    onSuccess: (T) -> Unit,
    onError: (NetworkException) -> Unit = { /* default */ },
    showLoading: Boolean = true
)

fun clearNetworkError()
```

### BaseRepository

```kotlin
protected fun <T> executeRequest(
    request: Single<ApiResponse<T>>,
    maxRetries: Int = 3,
    initialDelay: Long = 1000
): Single<T>
```

### ExceptionHandler

```kotlin
object ExceptionHandler {
    fun handleException(throwable: Throwable): NetworkException
    fun shouldRetry(throwable: Throwable): Boolean
}
```

## Troubleshooting

### Issue: Compilation Errors

**Solution**: Ensure all dependencies are properly added in `build.gradle`.

### Issue: Network Requests Fail

**Solution**: 
1. Check internet permission in `AndroidManifest.xml`
2. Verify base URL in `RetrofitConfig`
3. Check network connectivity

### Issue: Exceptions Not Caught

**Solution**: Ensure repository extends `BaseRepository` and uses `executeRequest()`.

### Issue: Memory Leaks

**Solution**: Ensure ViewModel extends `BaseNetworkViewModel` which automatically disposes subscriptions.

### Issue: Loading State Not Updating

**Solution**: Ensure you're observing `isLoading` in the UI and calling `executeNetworkRequest()`.

## Logging

View network logs:

```bash
adb logcat | grep RetrofitConfig
```

Logs include:
- Request URL, method, headers, body
- Response code, headers, body
- Timing information

## Performance Considerations

- **Connection Pooling**: OkHttp automatically manages connection pooling
- **Response Caching**: Can be configured via OkHttp cache interceptor
- **Thread Safety**: All operations are thread-safe
- **Memory**: CompositeDisposable properly manages subscriptions

## Security Considerations

- Use HTTPS for all API endpoints
- Implement certificate pinning if needed (via OkHttp)
- Store authentication tokens securely
- Implement token refresh mechanism
- Never log sensitive data

## Future Enhancements

Potential improvements:
- Certificate pinning
- Request/response caching
- Authentication token management
- Pagination support
- GraphQL support
- Rate limiting

## Contributing

When adding new features:
1. Extend `BaseRepository` for new services
2. Implement `BaseNetworkViewModel` in ViewModels
3. Add proper error handling
4. Document new features
5. Add examples in `NetworkFrameworkExample.kt`

## License

Part of the mvvmdemo project.

## Support

For questions or issues, refer to:
- `NETWORK_FRAMEWORK_USAGE.md` - Detailed usage guide
- `NetworkFrameworkExample.kt` - Code examples
- Retrofit documentation: https://square.github.io/retrofit/
- RxJava2 documentation: https://reactivex.io/
