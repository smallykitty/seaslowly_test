package com.example.mvvmdemo.data.model

data class User(
    val email: String,
    val password: String
)

data class RegistrationRequest(
    val email: String,
    val password: String,
    val confirmPassword: String
)

data class LoginRequest(
    val email: String,
    val password: String
)