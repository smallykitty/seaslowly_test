package com.example.mvvmdemo.network.example

/**
 * Example: Making Network Requests with the Framework
 *
 * This file demonstrates how to use the network framework in various scenarios.
 * These are NOT compiled - they are examples for reference.
 */

// ============================================================================
// EXAMPLE 1: Basic Network Request in ViewModel
// ============================================================================
/*
class ProfileViewModel(
    application: Application,
    private val userRepository: UserNetworkRepository = UserNetworkRepository()
) : BaseNetworkViewModel(application) {

    private val _user = MutableLiveData<User?>()
    val user: LiveData<User?> = _user

    fun loadUserProfile(userId: String) {
        executeNetworkRequest(
            request = userRepository.getUser(userId),
            onSuccess = { user ->
                _user.value = user
            },
            onError = { exception ->
                // Exception is automatically handled
                // exception.message contains user-friendly error message
            }
        )
    }
}
*/

// ============================================================================
// EXAMPLE 2: Network Request with Retry Handling
// ============================================================================
/*
class ListViewModel(
    application: Application,
    private val userRepository: UserNetworkRepository = UserNetworkRepository()
) : BaseNetworkViewModel(application) {

    private val _users = MutableLiveData<List<User>>()
    val users: LiveData<List<User>> = _users

    fun loadUsers() {
        executeNetworkRequest(
            request = userRepository.getAllUsers(),
            onSuccess = { users ->
                _users.value = users
            },
            onError = { exception ->
                when (exception) {
                    is NetworkException.TimeoutError -> {
                        // Handle timeout - user can retry
                    }
                    is NetworkException.ConnectionError -> {
                        // Handle connection error
                    }
                    is NetworkException.ServerError -> {
                        // Handle server error (5xx)
                    }
                    is NetworkException.ClientError -> {
                        // Handle client error (4xx) - won't be retried
                    }
                    else -> {
                        // Handle other errors
                    }
                }
            }
        )
    }
}
*/

// ============================================================================
// EXAMPLE 3: Creating a New Repository with Custom Logic
// ============================================================================
/*
class CustomRepository : BaseRepository() {
    private val authService: AuthService = RetrofitConfig.getRetrofit()
        .create(AuthService::class.java)

    fun loginWithTimeout(request: LoginRequest): Single<User> {
        return executeRequest(
            request = authService.login(request),
            maxRetries = 2,  // Override retry count
            initialDelay = 500  // Override initial delay
        )
    }
}
*/

// ============================================================================
// EXAMPLE 4: Handling Different Error Types
// ============================================================================
/*
fun handleNetworkError(exception: NetworkException) {
    val errorMessage = when (exception) {
        is NetworkException.ConnectionError ->
            "Unable to connect. Please check your internet connection."
        is NetworkException.TimeoutError ->
            "Request timed out. Please try again."
        is NetworkException.HttpError ->
            "HTTP Error ${exception.code}: ${exception.message}"
        is NetworkException.ServerError ->
            "Server error. Please try again later."
        is NetworkException.ClientError ->
            "Invalid request. ${exception.message}"
        is NetworkException.ParseException ->
            "Failed to parse response data."
        is NetworkException.UnknownError ->
            "An unexpected error occurred."
    }
    // Show error to user
    showErrorDialog(errorMessage)
}
*/

// ============================================================================
// EXAMPLE 5: Observable Loading and Error States in UI
// ============================================================================
/*
@Composable
fun UserProfileScreen(viewModel: ProfileViewModel = viewModel()) {
    val isLoading by viewModel.isLoading.observeAsState(false)
    val user by viewModel.user.observeAsState()
    val networkError by viewModel.networkError.observeAsState()

    LaunchedEffect(Unit) {
        viewModel.loadUserProfile("user123")
    }

    when {
        isLoading -> {
            CircularProgressIndicator()
        }
        networkError != null -> {
            Column {
                Text(
                    text = networkError!!.message ?: "An error occurred",
                    color = MaterialTheme.colorScheme.error
                )
                Button(onClick = { viewModel.loadUserProfile("user123") }) {
                    Text("Retry")
                }
            }
        }
        user != null -> {
            UserProfileContent(user!!)
        }
        else -> {
            Text("No user data")
        }
    }
}
*/

// ============================================================================
// EXAMPLE 6: Retry Mechanism in Action
// ============================================================================
/*
// When makeRequest() is called and network fails:
//
// Attempt 1: immediate request
//           └─> fails with timeout
//
// Attempt 2: wait 1000ms
//           └─> request
//           └─> fails with connection error
//
// Attempt 3: wait 2000ms
//           └─> request
//           └─> succeeds!
//
// If attempt 3 fails with 4xx error:
//   └─> no more retries (client error)
//   └─> error returned to user

fun demonstrateRetryMechanism() {
    // The retry logic is automatic in BaseRepository.executeRequest()
    // Configured with:
    // - maxRetries = 3
    // - initialDelay = 1000ms
    // - exponential backoff: delay * 2^(attemptNumber)
    // - skips retry for 4xx errors
}
*/

// ============================================================================
// EXAMPLE 7: Manual Error Clearing
// ============================================================================
/*
class LoginViewModel(
    application: Application,
    private val authRepository: AuthRepository = AuthRepository()
) : BaseNetworkViewModel(application) {

    private val _loginSuccess = MutableLiveData<Boolean>()
    val loginSuccess: LiveData<Boolean> = _loginSuccess

    fun login(email: String, password: String) {
        // Clear previous errors
        clearNetworkError()

        executeNetworkRequest(
            request = authRepository.login(LoginRequest(email, password)),
            onSuccess = { user ->
                _loginSuccess.value = true
            },
            onError = { exception ->
                // Error automatically stored in networkError
            }
        )
    }

    fun dismissError() {
        clearNetworkError()
    }
}
*/

// ============================================================================
// EXAMPLE 8: Configuration Updates
// ============================================================================
/*
// To update network configuration, modify RetrofitConfig:

object RetrofitConfig {
    private const val BASE_URL = "https://api.yourdomain.com/"
    private const val CONNECTION_TIMEOUT = 10L
    private const val READ_TIMEOUT = 30L
    private const val WRITE_TIMEOUT = 30L

    // Add custom headers:
    private fun createOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS)
            .readTimeout(READ_TIMEOUT, TimeUnit.SECONDS)
            .writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS)
            .addInterceptor(createLoggingInterceptor())
            .addInterceptor { chain ->
                val request = chain.request().newBuilder()
                    .addHeader("Authorization", "Bearer token")
                    .addHeader("X-App-Version", "1.0")
                    .build()
                chain.proceed(request)
            }
            .build()
    }
}
*/
