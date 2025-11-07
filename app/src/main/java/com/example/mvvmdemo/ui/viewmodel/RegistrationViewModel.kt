package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mvvmdemo.R
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.repository.UserRepository
import com.example.mvvmdemo.network.repository.AuthRepository

/**
 * 注册流程的业务 ViewModel。
 *
 * 提供表单状态、输入校验与网络注册请求，供界面层直接调用。
 */
class RegistrationViewModel(
    application: Application,
    private val localRepository: UserRepository = UserRepository(),
    private val authRepository: AuthRepository = AuthRepository()
) : BaseNetworkViewModel(application) {

    private val _email = MutableLiveData("")
    val email: LiveData<String> = _email

    private val _password = MutableLiveData("")
    val password: LiveData<String> = _password

    private val _confirmPassword = MutableLiveData("")
    val confirmPassword: LiveData<String> = _confirmPassword

    private val _errorMessage = MutableLiveData<String?>()
    val errorMessage: LiveData<String?> = _errorMessage

    private val _registrationSuccess = MutableLiveData<Boolean>()
    val registrationSuccess: LiveData<Boolean> = _registrationSuccess

    /**
     * 更新邮箱输入。
     */
    fun onEmailChanged(newEmail: String) {
        _email.value = newEmail
    }

    /**
     * 更新密码输入。
     */
    fun onPasswordChanged(newPassword: String) {
        _password.value = newPassword
    }

    /**
     * 更新确认密码输入。
     */
    fun onConfirmPasswordChanged(newConfirmPassword: String) {
        _confirmPassword.value = newConfirmPassword
    }

    /**
     * 执行注册流程，包含本地校验与网络请求：
     *
     * - 校验表单是否完整
     * - 校验两次密码是否一致及长度要求
     * - 调用网络仓库完成注册
     */
    fun register() {
        val email = _email.value ?: return
        val password = _password.value ?: return
        val confirmPassword = _confirmPassword.value ?: return
        val appContext = getApplication<Application>()

        if (email.isBlank() || password.isBlank() || confirmPassword.isBlank()) {
            _errorMessage.value = appContext.getString(R.string.register_error_empty)
            return
        }

        if (password != confirmPassword) {
            _errorMessage.value = appContext.getString(R.string.register_error_password_mismatch)
            return
        }

        if (password.length < 6) {
            _errorMessage.value = appContext.getString(R.string.register_error_password_short)
            return
        }

        val registrationRequest = RegistrationRequest(email, password, confirmPassword)

        executeNetworkRequest(
            request = authRepository.register(registrationRequest),
            onSuccess = {
                _registrationSuccess.value = true
            },
            onError = { exception ->
                _errorMessage.value = exception.message ?: appContext.getString(R.string.register_error_failed)
                _networkError.value = exception
            }
        )
    }

    /**
     * 清除错误提示。
     */
    fun clearError() {
        _errorMessage.value = null
    }
}
