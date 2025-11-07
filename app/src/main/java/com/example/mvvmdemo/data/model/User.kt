package com.example.mvvmdemo.data.model

/**
 * 用户账号信息。
 *
 * 在 Demo 环境下仅包含邮箱与密码字段，方便展示注册与登录逻辑。
 */
data class User(
    val email: String,
    val password: String
)

/**
 * 注册请求体。
 *
 * 同时包含确认密码，方便在客户端做二次校验。
 */
data class RegistrationRequest(
    val email: String,
    val password: String,
    val confirmPassword: String
)

/**
 * 登录请求体。
 */
data class LoginRequest(
    val email: String,
    val password: String
)
