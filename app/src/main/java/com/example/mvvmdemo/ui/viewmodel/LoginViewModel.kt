package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.repository.UserRepository
import com.example.mvvmdemo.network.exception.NetworkException
import com.example.mvvmdemo.network.repository.AuthRepository
import com.example.mvvmdemo.notification.LoginNotificationManager

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
        notificationManager.ensureNotificationChannel()
    }

    fun onEmailChanged(newEmail: String) {
        _email.value = newEmail
    }

    fun onPasswordChanged(newPassword: String) {
        _password.value = newPassword
    }

    fun canPostNotifications(): Boolean = notificationManager.canPostNotifications()

    fun login() {
        val email = _email.value ?: return
        val password = _password.value ?: return

        if (email.isBlank() || password.isBlank()) {
            _errorMessage.value = "Please fill in all fields"
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
                _errorMessage.value = exception.message ?: "Login failed"
            }
        )
    }

    fun clearError() {
        _errorMessage.value = null
    }
}
