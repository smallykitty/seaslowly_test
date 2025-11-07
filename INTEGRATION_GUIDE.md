# Network Framework Integration Guide

This guide explains how the Retrofit and RxJava2 network framework integrates with the mvvmdemo project and how to extend it.

## Architecture Overview

### Component Relationships

```
┌─────────────────────────────────────────────────────────┐
│  UI Layer (Jetpack Compose)                            │
│  - LoginScreen, RegistrationScreen                      │
│  - Observes ViewModel LiveData                          │
└────────────────────┬────────────────────────────────────┘
                     │ Observes
                     ↓
┌─────────────────────────────────────────────────────────┐
│  ViewModel Layer                                         │
│  - LoginViewModel extends BaseNetworkViewModel           │
│  - RegistrationViewModel extends BaseNetworkViewModel    │
│  - Manages UI state and triggers network calls           │
│  - LiveData: isLoading, errorMessage, loginSuccess      │
└────────────────────┬────────────────────────────────────┘
                     │ Calls
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Repository Layer                                        │
│  - AuthRepository extends BaseRepository                 │
│  - UserNetworkRepository extends BaseRepository          │
│  - Executes network requests with retry logic            │
└────────────────────┬────────────────────────────────────┘
                     │ Uses
                     ↓
┌─────────────────────────────────────────────────────────┐
│  API Service Layer (Retrofit Interfaces)                │
│  - AuthService (login, register)                        │
│  - UserService (getUser, getAllUsers)                   │
│  - Type-safe endpoint definitions                       │
└────────────────────┬────────────────────────────────────┘
                     │ Creates
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Retrofit Configuration                                  │
│  - RetrofitConfig singleton                             │
│  - OkHttp client with timeouts                          │
│  - HttpLoggingInterceptor                               │
│  - Gson serialization                                   │
│  - RxJava2 adapter                                      │
└────────────────────┬────────────────────────────────────┘
                     │ Creates HTTP calls
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Network Request                                         │
│  - OkHttp sends request to API                          │
│  - Automatic logging                                    │
│  - Timeout handling                                     │
└────────────────────┬────────────────────────────────────┘
                     │ Response
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Exception Handling & Retry                              │
│  - ExceptionHandler transforms errors                    │
│  - BaseRepository retries with exponential backoff       │
│  - Smart retry (skip 4xx, retry others)                 │
└────────────────────┬────────────────────────────────────┘
                     │ Response or Error
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Response Processing                                     │
│  - ApiResponse<T> unwrapped                             │
│  - Data extracted                                       │
│  - Error message extracted                              │
└────────────────────┬────────────────────────────────────┘
                     │ Single<T>
                     ↓
┌─────────────────────────────────────────────────────────┐
│  Back to ViewModel                                       │
│  - Success: update LiveData                             │
│  - Error: store exception in networkError               │
│  - Loading state updated                                │
└──────────────────────────────────────────────────────────┘
```

## Data Flow Example: Login Request

### Step 1: User Interaction (UI)
```kotlin
Button(onClick = { viewModel.login() }) {
    Text("Login")
}
```

### Step 2: ViewModel Processes Request
```kotlin
// In LoginViewModel
fun login() {
    val loginRequest = LoginRequest(email, password)
    
    executeNetworkRequest(
        request = authRepository.login(loginRequest),
        onSuccess = { user ->
            _loginSuccess.value = true
        },
        onError = { exception ->
            _errorMessage.value = exception.message
        }
    )
}
```

### Step 3: BaseNetworkViewModel Executes Request
```kotlin
// In BaseNetworkViewModel
_isLoading.value = true  // UI shows loading indicator
_networkError.value = null

val disposable = request
    .doFinally { _isLoading.value = false }
    .subscribe(
        { result -> onSuccess(result) },
        { throwable -> onError(handleException(throwable)) }
    )

compositeDisposable.add(disposable)  // Manage lifecycle
```

### Step 4: Repository Makes Network Call
```kotlin
// In AuthRepository
fun login(request: LoginRequest): Single<User> {
    return executeRequest(authService.login(request))
}
```

### Step 5: BaseRepository Handles Retry & Error
```kotlin
// In BaseRepository
fun executeRequest(
    request: Single<ApiResponse<User>>,
    maxRetries: Int = 3,
    initialDelay: Long = 1000
): Single<User> {
    return request
        .retry { retryCount, throwable ->
            val shouldRetry = ExceptionHandler.shouldRetry(throwable) && retryCount < 3
            if (shouldRetry) {
                Thread.sleep((1000 * 2^retryCount).toLong())  // Exponential backoff
            }
            shouldRetry
        }
        .map { response ->
            if (response.success && response.data != null) {
                response.data  // Unwrap data
            } else {
                throw NetworkException.UnknownError(...)
            }
        }
        .onErrorResumeNext { throwable ->
            Single.error(ExceptionHandler.handleException(throwable))
        }
        .subscribeOn(Schedulers.io())        // Background thread
        .observeOn(AndroidSchedulers.mainThread())  // Main thread
}
```

### Step 6: Retrofit Makes HTTP Request
```kotlin
// In AuthService
@POST("auth/login")
fun login(@Body request: LoginRequest): Single<ApiResponse<User>>

// HTTP Request sent via OkHttp:
// POST https://api.example.com/auth/login
// Body: { "email": "user@example.com", "password": "..." }
```

### Step 7: Response Processing
```
Response received: 200 OK
Body: { "success": true, "code": 200, "data": { "email": "user@example.com" } }
↓
Response mapped to ApiResponse<User>
↓
Data extracted: User(email: "user@example.com")
↓
Returns Single<User> back to ViewModel
↓
onSuccess callback invoked in ViewModel
↓
_loginSuccess.value = true
↓
UI navigates to HelloScreen
```

## Error Handling Flow

### Scenario 1: Network Timeout
```
Network Request → Timeout after 30 seconds
    ↓
SocketTimeoutException thrown
    ↓
BaseRepository.retry() checks shouldRetry()
    ↓
ExceptionHandler.shouldRetry() returns true
    ↓
Wait 1000ms (exponential backoff: 1s)
    ↓
Retry request
    ↓
(repeat for max 3 attempts)
    ↓
If all retries fail:
    ExceptionHandler.handleException()
    ↓
    Create TimeoutError
    ↓
    Return to ViewModel
    ↓
    _errorMessage.value = "Request timed out"
    ↓
    UI shows error message
```

### Scenario 2: 4xx Client Error (No Retry)
```
Network Request → 400 Bad Request
    ↓
HttpException(400) thrown
    ↓
BaseRepository.retry() checks shouldRetry()
    ↓
ExceptionHandler.shouldRetry() returns false (4xx error)
    ↓
No retry!
    ↓
ExceptionHandler.handleException()
    ↓
    Create ClientError(code: 400)
    ↓
    Return to ViewModel
    ↓
    _errorMessage.value = "Client Error: 400"
    ↓
    UI shows error message
```

## Lifecycle Management

### ViewModel Creation
1. ViewModel created by Compose
2. `BaseNetworkViewModel.__init__()` called
3. `CompositeDisposable` initialized
4. Ready to execute network requests

### Network Request Execution
1. `executeNetworkRequest()` called
2. Subscription created
3. Added to `CompositeDisposable`
4. Request executes on IO thread
5. Response received on Main thread
6. Callback invoked

### ViewModel Destruction
1. Screen/Activity destroyed
2. `ViewModel.onCleared()` called
3. `BaseNetworkViewModel.onCleared()` called
4. `compositeDisposable.dispose()` called
5. All subscriptions disposed
6. Memory freed
7. No memory leak!

## Thread Management

### Retrofit Request Thread
```
Schedulers.io()
    ↓
Background thread pool
    ↓
Safe for long-running operations
    ↓
Network I/O, Database access, etc.
```

### Response Delivery Thread
```
AndroidSchedulers.mainThread()
    ↓
Main UI thread
    ↓
Safe for LiveData updates
    ↓
Safe for UI changes
```

### ViewModel Callbacks
```kotlin
executeNetworkRequest(
    request = repository.getData(),  // Executed on IO thread
    onSuccess = { data ->             // Executed on Main thread
        _uiState.value = data         // Update LiveData (safe)
    },
    onError = { exception ->          // Executed on Main thread
        _errorMessage.value = exception.message  // Update LiveData (safe)
    }
)
```

## Adding New Endpoints

### Step 1: Define API Service
```kotlin
// app/src/main/java/com/example/mvvmdemo/network/api/ProductService.kt
interface ProductService {
    @GET("products")
    fun getProducts(): Single<ApiResponse<List<Product>>>

    @GET("products/{id}")
    fun getProduct(@Path("id") id: String): Single<ApiResponse<Product>>

    @POST("products")
    fun createProduct(@Body product: Product): Single<ApiResponse<Product>>
}
```

### Step 2: Create Repository
```kotlin
// app/src/main/java/com/example/mvvmdemo/network/repository/ProductRepository.kt
class ProductRepository : BaseRepository() {
    private val productService: ProductService = 
        RetrofitConfig.getRetrofit().create(ProductService::class.java)

    fun getProducts(): Single<List<Product>> {
        return executeRequest(productService.getProducts())
    }

    fun getProduct(id: String): Single<Product> {
        return executeRequest(productService.getProduct(id))
    }

    fun createProduct(product: Product): Single<Product> {
        return executeRequest(productService.createProduct(product))
    }
}
```

### Step 3: Create ViewModel
```kotlin
// app/src/main/java/com/example/mvvmdemo/ui/viewmodel/ProductViewModel.kt
class ProductViewModel(
    application: Application,
    private val productRepository: ProductRepository = ProductRepository()
) : BaseNetworkViewModel(application) {

    private val _products = MutableLiveData<List<Product>>()
    val products: LiveData<List<Product>> = _products

    private val _errorMessage = MutableLiveData<String?>()
    val errorMessage: LiveData<String?> = _errorMessage

    fun loadProducts() {
        executeNetworkRequest(
            request = productRepository.getProducts(),
            onSuccess = { products ->
                _products.value = products
            },
            onError = { exception ->
                _errorMessage.value = exception.message
            }
        )
    }
}
```

### Step 4: Use in UI
```kotlin
@Composable
fun ProductScreen(viewModel: ProductViewModel = viewModel()) {
    val products by viewModel.products.observeAsState()
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()

    LaunchedEffect(Unit) {
        viewModel.loadProducts()
    }

    when {
        isLoading -> CircularProgressIndicator()
        errorMessage != null -> Text(errorMessage!!)
        products != null -> ProductList(products!!)
        else -> Text("No products")
    }
}
```

## Testing the Framework

### Test Retrofit Configuration
```kotlin
@Test
fun testRetrofitInitialization() {
    val retrofit = RetrofitConfig.getRetrofit()
    assertNotNull(retrofit)
    
    val authService = retrofit.create(AuthService::class.java)
    assertNotNull(authService)
}
```

### Mock Network Responses
```kotlin
@Test
fun testLoginSuccess() {
    val mockRepository = mock<AuthRepository>()
    val mockUser = User(email = "test@test.com")
    `when`(mockRepository.login(any())).thenReturn(Single.just(mockUser))
    
    val viewModel = LoginViewModel(
        app,
        authRepository = mockRepository
    )
    viewModel.login()
    
    assertEquals("test@test.com", viewModel.user)
}
```

## Common Issues & Solutions

### Issue: "Retrofit instance not initialized"
**Solution**: Ensure `RetrofitConfig.getRetrofit()` is called at least once before using services.

### Issue: "Network requests never complete"
**Solution**: Check that `AndroidSchedulers` is used for observing (add `implementation 'io.reactivex.rxjava2:rxandroid'`).

### Issue: "Memory leak - subscriptions not disposed"
**Solution**: Ensure ViewModel extends `BaseNetworkViewModel` which automatically disposes in `onCleared()`.

### Issue: "No internet permission error"
**Solution**: Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Issue: "Timeout always occurs"
**Solution**: Check timeouts in `RetrofitConfig` and increase if needed:
```kotlin
private const val READ_TIMEOUT = 60L  // Increase to 60s
```

## Performance Considerations

### Connection Pooling
- OkHttp automatically manages connection pooling
- Reuses connections for better performance
- No configuration needed

### Caching
- Add caching interceptor if needed:
```kotlin
.addInterceptor(HttpCacheInterceptor())
```

### Request/Response Logging
- Logging is enabled by default (BODY level)
- Disable in production by setting level to NONE:
```kotlin
.level = HttpLoggingInterceptor.Level.NONE
```

## Security Recommendations

1. **Use HTTPS only**: All API endpoints should use HTTPS
2. **Certificate Pinning**: For sensitive data:
   ```kotlin
   .certificatePinner(
       CertificatePinner.Builder()
           .add("api.example.com", "sha256/...")
           .build()
   )
   ```
3. **Token Management**: Store auth tokens securely
4. **Disable Logging in Production**: Remove logging interceptor in production builds

## Next Steps

1. ✅ Review the implementation
2. ✅ Understand the architecture
3. ✅ Update API base URL in `RetrofitConfig`
4. ✅ Add custom headers if needed
5. ✅ Create domain-specific repositories
6. ✅ Create domain-specific ViewModels
7. ✅ Integrate with UI screens
8. ✅ Test with real API
9. ✅ Deploy to production

## Support Resources

- `NETWORK_FRAMEWORK.md` - Complete documentation
- `NETWORK_FRAMEWORK_USAGE.md` - Usage guide
- `NetworkFrameworkExample.kt` - Code examples
- `IMPLEMENTATION_SUMMARY.md` - Implementation details
- This file - Integration guide

---

**Status**: Ready for integration and deployment.
