package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mvvmdemo.R
import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.repository.UserRepository
import com.example.mvvmdemo.network.repository.AuthRepository
import com.example.mvvmdemo.notification.LoginNotificationManager

/**
 * 登录流程的业务 ViewModel。
 *
 * 1. 负责维护登录表单输入状态与错误提示
 * 2. 协调本地仓库与网络仓库，完成登录校验
 * 3. 登录成功后触发欢迎通知
 */
class LoginViewModel(
    application: Application,
    private val localRepository: UserRepository = UserRepository(),
    private val authRepository: AuthRepository = AuthRepository(),
    private val notificationManager: LoginNotificationManager = LoginNotificationManager(application.applicationContext)
) : BaseNetworkViewModel(application) {

    private val _email = MutableLiveData("")
    val email: LiveData<String> = _email

    private val _password = MutableLiveData("")
    val password: LiveData<String> = _password

    private val _errorMessage = MutableLiveData<String?>()
    val errorMessage: LiveData<String?> = _errorMessage

    private val _loginSuccess = MutableLiveData<Boolean>()
    val loginSuccess: LiveData<Boolean> = _loginSuccess

    init {
        // 预先创建通知渠道，确保后续发送登录成功通知不会失败
        notificationManager.ensureNotificationChannel()
    }

    /**
     * 更新用户输入的邮箱。
     */
    fun onEmailChanged(newEmail: String) {
        _email.value = newEmail
    }

    /**
     * 更新用户输入的密码。
     */
    fun onPasswordChanged(newPassword: String) {
        _password.value = newPassword
    }

    /**
     * 判断应用当前是否具备发送通知的能力。
     */
    fun canPostNotifications(): Boolean = notificationManager.canPostNotifications()

    /**
     * 执行登录流程：
     *
     * - 检查输入必填项
     * - 调用网络仓库发起登录请求
     * - 成功后发送通知并更新登录状态
     */
    fun login() {
        val email = _email.value ?: return
        val password = _password.value ?: return
        val appContext = getApplication<Application>()

        if (email.isBlank() || password.isBlank()) {
            _errorMessage.value = appContext.getString(R.string.login_error_empty)
            return
        }

        val loginRequest = LoginRequest(email, password)

        executeNetworkRequest(
            request = authRepository.login(loginRequest),
            onSuccess = { user ->
                notificationManager.showLoginSuccessNotification(user.email)
                _loginSuccess.value = true
            },
            onError = { exception ->
                _errorMessage.value = exception.message ?: appContext.getString(R.string.login_error_failed)
                _networkError.value = exception
            }
        )
    }

    /**
     * 手动清除错误提示，便于用户再次尝试。
     */
    fun clearError() {
        _errorMessage.value = null
    }
}
