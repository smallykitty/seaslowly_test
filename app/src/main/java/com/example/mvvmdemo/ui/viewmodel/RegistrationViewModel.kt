package com.example.mvvmdemo.ui.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.repository.UserRepository
import kotlinx.coroutines.launch

class RegistrationViewModel(private val repository: UserRepository = UserRepository()) : ViewModel() {
    
    private val _email = MutableLiveData("")
    val email: LiveData<String> = _email
    
    private val _password = MutableLiveData("")
    val password: LiveData<String> = _password
    
    private val _confirmPassword = MutableLiveData("")
    val confirmPassword: LiveData<String> = _confirmPassword
    
    private val _isLoading = MutableLiveData(false)
    val isLoading: LiveData<Boolean> = _isLoading
    
    private val _errorMessage = MutableLiveData<String?>()
    val errorMessage: LiveData<String?> = _errorMessage
    
    private val _registrationSuccess = MutableLiveData<Boolean>()
    val registrationSuccess: LiveData<Boolean> = _registrationSuccess
    
    fun onEmailChanged(newEmail: String) {
        _email.value = newEmail
    }
    
    fun onPasswordChanged(newPassword: String) {
        _password.value = newPassword
    }
    
    fun onConfirmPasswordChanged(newConfirmPassword: String) {
        _confirmPassword.value = newConfirmPassword
    }
    
    fun register() {
        val email = _email.value ?: return
        val password = _password.value ?: return
        val confirmPassword = _confirmPassword.value ?: return
        
        if (email.isBlank() || password.isBlank() || confirmPassword.isBlank()) {
            _errorMessage.value = "Please fill in all fields"
            return
        }
        
        if (password != confirmPassword) {
            _errorMessage.value = "Passwords do not match"
            return
        }
        
        if (password.length < 6) {
            _errorMessage.value = "Password must be at least 6 characters"
            return
        }
        
        _isLoading.value = true
        _errorMessage.value = null
        
        viewModelScope.launch {
            val result = repository.register(RegistrationRequest(email, password, confirmPassword))
            _isLoading.value = false
            
            result.fold(
                onSuccess = { _registrationSuccess.value = true },
                onFailure = { _errorMessage.value = it.message }
            )
        }
    }
    
    fun clearError() {
        _errorMessage.value = null
    }
}