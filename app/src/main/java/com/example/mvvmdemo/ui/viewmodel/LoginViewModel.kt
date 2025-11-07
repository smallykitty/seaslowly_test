package com.example.mvvmdemo.ui.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.repository.UserRepository
import kotlinx.coroutines.launch

class LoginViewModel(private val repository: UserRepository = UserRepository()) : ViewModel() {
    
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
    
    fun onEmailChanged(newEmail: String) {
        _email.value = newEmail
    }
    
    fun onPasswordChanged(newPassword: String) {
        _password.value = newPassword
    }
    
    fun login() {
        val email = _email.value ?: return
        val password = _password.value ?: return
        
        if (email.isBlank() || password.isBlank()) {
            _errorMessage.value = "Please fill in all fields"
            return
        }
        
        _isLoading.value = true
        _errorMessage.value = null
        
        viewModelScope.launch {
            val result = repository.login(LoginRequest(email, password))
            _isLoading.value = false
            
            result.fold(
                onSuccess = { _loginSuccess.value = true },
                onFailure = { _errorMessage.value = it.message }
            )
        }
    }
    
    fun clearError() {
        _errorMessage.value = null
    }
}