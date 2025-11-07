package com.example.mvvmdemo.network.api

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import retrofit2.http.Body
import retrofit2.http.POST

interface AuthService {
    @POST("auth/register")
    fun register(@Body request: RegistrationRequest): Single<ApiResponse<User>>

    @POST("auth/login")
    fun login(@Body request: LoginRequest): Single<ApiResponse<User>>
}
