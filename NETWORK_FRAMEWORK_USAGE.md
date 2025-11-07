# Network Framework Usage Guide

This document describes the comprehensive Retrofit and RxJava2 network framework implemented for mvvmdemo.

## Architecture Overview

The network framework follows the repository pattern with proper separation of concerns:

1. **Network Configuration** (`RetrofitConfig`) - Centralized Retrofit setup
2. **API Services** (`AuthService`) - Type-safe API interface definitions
3. **Exception Handling** (`NetworkException`, `ExceptionHandler`) - Unified exception handling
4. **Base Repository** (`BaseRepository`) - Reusable network request execution with retry logic
5. **Concrete Repositories** (`AuthRepository`) - Domain-specific API access
6. **Base ViewModel** (`BaseNetworkViewModel`) - RxJava2 lifecycle management
7. **Concrete ViewModels** (`LoginViewModel`, `RegistrationViewModel`) - UI logic with network integration

## Key Features

### 1. Retrofit Configuration
- **Base URL**: Configured in `RetrofitConfig`
- **OkHttp Client**: Custom configuration with timeouts
- **Timeouts**:
  - Connection: 10 seconds
  - Read: 30 seconds
  - Write: 30 seconds
- **Interceptors**: Automatic logging of all requests/responses
- **JSON Parsing**: Gson with pretty printing and null serialization
- **RxJava2 Adapter**: Seamless integration with Retrofit

### 2. Automatic Retry Mechanism
- **Max Retries**: 3 attempts by default
- **Exponential Backoff**: Initial delay 1000ms, doubles with each retry
  - Attempt 1: 1000ms delay
  - Attempt 2: 2000ms delay
  - Attempt 3: 4000ms delay
- **Smart Retry**: Skips retry for 4xx client errors (400-499)

### 3. Exception Handling
The framework provides specialized exception types:

```
NetworkException (sealed class)
├── ConnectionError - Network/connectivity failures
├── TimeoutError - Request timeout
├── HttpError - General HTTP errors
├── ServerError - 5xx errors
├── ClientError - 4xx errors
├── ParseException - JSON parsing failures
└── UnknownError - Unknown errors
```

Error messages are user-friendly and available through `exception.message`.

### 4. Response Wrapper
All API responses follow the `ApiResponse<T>` structure:

```json
{
  "success": true,
  "code": 200,
  "message": "Success",
  "data": { /* actual data */ },
  "error": null
}
```

### 5. Repository Pattern

#### Creating a Repository

```kotlin
class AuthRepository : BaseRepository() {
    private val authService: AuthService = 
        RetrofitConfig.getRetrofit().create(AuthService::class.java)

    fun login(request: LoginRequest): Single<User> {
        return executeRequest(authService.login(request))
    }
}
```

#### API Service Definition

```kotlin
interface AuthService {
    @POST("auth/login")
    fun login(@Body request: LoginRequest): Single<ApiResponse<User>>
}
```

### 6. ViewModel Integration

#### Using BaseNetworkViewModel

```kotlin
class LoginViewModel(
    application: Application,
    private val authRepository: AuthRepository = AuthRepository()
) : BaseNetworkViewModel(application) {

    private val _loginSuccess = MutableLiveData<Boolean>()
    val loginSuccess: LiveData<Boolean> = _loginSuccess

    fun login() {
        executeNetworkRequest(
            request = authRepository.login(LoginRequest(email, password)),
            onSuccess = { user ->
                // Handle success
                _loginSuccess.value = true
            },
            onError = { exception ->
                // Handle error - exception message automatically displayed
                _errorMessage.value = exception.message
            }
        )
    }

    override fun onCleared() {
        compositeDisposable.dispose()
        super.onCleared()
    }
}
```

#### Available ViewModel Properties

- `isLoading: LiveData<Boolean>` - Loading state during network request
- `networkError: LiveData<NetworkException?>` - Network error details
- `executeNetworkRequest()` - Execute network call with callbacks

### 7. UI Integration Example

```kotlin
@Composable
fun LoginScreen(viewModel: LoginViewModel = viewModel()) {
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()
    val networkError by viewModel.networkError.observeAsState()

    if (isLoading) {
        CircularProgressIndicator()
    }

    errorMessage?.let {
        Text(it, color = MaterialTheme.colorScheme.error)
    }

    Button(
        onClick = { viewModel.login() },
        enabled = !isLoading
    ) {
        Text("Login")
    }
}
```

## Thread Management

All network requests are automatically:
- **Executed on**: `Schedulers.io()` (background thread)
- **Observed on**: `AndroidSchedulers.mainThread()` (UI thread)

No need to manually manage threads in ViewModels.

## Lifecycle Management

The `BaseNetworkViewModel` handles:
- Automatic subscription management using `CompositeDisposable`
- Automatic disposal of subscriptions in `onCleared()`
- Prevention of memory leaks

## Best Practices

1. **Always extend BaseNetworkViewModel** in view models that use network requests
2. **Use executeNetworkRequest()** for all network calls - ensures proper lifecycle management
3. **Handle exceptions in onError callback** - get type-safe exception details
4. **Dispose subscriptions** - automatically done by BaseNetworkViewModel
5. **Check loading state** - disable UI interactions during requests
6. **Implement proper error UI** - show meaningful messages to users

## Configuration

To customize the network configuration, edit `RetrofitConfig`:

```kotlin
object RetrofitConfig {
    private const val BASE_URL = "https://api.example.com/"
    private const val CONNECTION_TIMEOUT = 10L
    private const val READ_TIMEOUT = 30L
    private const val WRITE_TIMEOUT = 30L
}
```

## Example: Adding a New API Endpoint

1. Add method to API service:
```kotlin
interface UserService {
    @GET("users/{id}")
    fun getUser(@Path("id") userId: String): Single<ApiResponse<User>>
}
```

2. Create repository:
```kotlin
class UserRepository : BaseRepository() {
    private val userService = RetrofitConfig.getRetrofit()
        .create(UserService::class.java)

    fun getUser(id: String): Single<User> {
        return executeRequest(userService.getUser(id))
    }
}
```

3. Use in ViewModel:
```kotlin
executeNetworkRequest(
    request = userRepository.getUser(userId),
    onSuccess = { user -> /* handle */ },
    onError = { exception -> /* handle */ }
)
```

## Error Scenarios Handled

- ✅ Network timeout - Retries with exponential backoff
- ✅ Connection failure - Retries with exponential backoff
- ✅ 4xx errors - No retry (client error)
- ✅ 5xx errors - Retries with exponential backoff
- ✅ JSON parsing errors - Converts to ParseException
- ✅ Unknown errors - Converts to UnknownError with original cause
- ✅ Composite exceptions - Extracts and handles first exception

## Logging

All network requests and responses are automatically logged using Android's Log class with tag "RetrofitConfig" and level BODY (includes request/response bodies).

To view logs:
```bash
adb logcat | grep RetrofitConfig
```

## Observable vs Single

The framework uses `Single` from RxJava2 because:
- Network requests have a single response (no streaming)
- Proper lifecycle management
- Error handling built-in
- Seamless integration with Android lifecycle

## Custom Headers

To add custom headers, extend `BaseRepository` and override network calls:

```kotlin
class CustomRepository : BaseRepository() {
    fun makeRequestWithHeaders(request: Single<ApiResponse<T>>): Single<T> {
        return request.map { /* add header logic */ }
    }
}
```

Or modify `RetrofitConfig` to add a request interceptor:

```kotlin
.addInterceptor { chain ->
    val request = chain.request().newBuilder()
        .addHeader("X-Custom-Header", "value")
        .build()
    chain.proceed(request)
}
```
