package com.example.mvvmdemo.network.repository

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.api.AuthService
import com.example.mvvmdemo.network.config.RetrofitConfig
import io.reactivex.Single

class AuthRepository : BaseRepository() {
    private val authService: AuthService = RetrofitConfig.getRetrofit()
        .create(AuthService::class.java)

    fun register(request: RegistrationRequest): Single<User> {
        return executeRequest(authService.register(request))
    }

    fun login(request: LoginRequest): Single<User> {
        return executeRequest(authService.login(request))
    }
}
