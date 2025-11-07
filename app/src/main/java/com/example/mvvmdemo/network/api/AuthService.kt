package com.example.mvvmdemo.network.api

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import retrofit2.http.Body
import retrofit2.http.POST

/**
 * 认证相关的网络接口定义。
 */
interface AuthService {

    /**
     * 注册新用户。
     */
    @POST("auth/register")
    fun register(@Body request: RegistrationRequest): Single<ApiResponse<User>>

    /**
     * 登录已注册用户。
     */
    @POST("auth/login")
    fun login(@Body request: LoginRequest): Single<ApiResponse<User>>
}
