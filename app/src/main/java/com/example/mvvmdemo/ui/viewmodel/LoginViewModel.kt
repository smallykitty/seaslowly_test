package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.repository.UserRepository
import com.example.mvvmdemo.notification.LoginNotificationManager
import kotlinx.coroutines.launch

class LoginViewModel(
    application: Application,
    private val repository: UserRepository = UserRepository(),
    private val notificationManager: LoginNotificationManager = LoginNotificationManager(application.applicationContext)
) : AndroidViewModel(application) {

    private val _email = MutableLiveData("")
    val email: LiveData<String> = _email

    private val _password = MutableLiveData("")
    val password: LiveData<String> = _password

    private val _isLoading = MutableLiveData(false)
    val isLoading: LiveData<Boolean> = _isLoading

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

        _isLoading.value = true
        _errorMessage.value = null
        _loginSuccess.value = false

        viewModelScope.launch {
            val result = repository.login(LoginRequest(email, password))
            _isLoading.value = false

            result.fold(
                onSuccess = {
                    notificationManager.showLoginSuccessNotification(it.email)
                    _loginSuccess.value = true
                },
                onFailure = { _errorMessage.value = it.message }
            )
        }
    }

    fun clearError() {
        _errorMessage.value = null
    }
}
