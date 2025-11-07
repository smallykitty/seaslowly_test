package com.example.mvvmdemo.ui.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class HelloViewModel : ViewModel() {
    
    private val _userEmail = MutableLiveData<String?>()
    val userEmail: LiveData<String?> = _userEmail
    
    fun setUserEmail(email: String) {
        _userEmail.value = email
    }
}