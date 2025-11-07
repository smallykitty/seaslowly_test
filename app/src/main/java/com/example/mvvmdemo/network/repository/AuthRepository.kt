package com.example.mvvmdemo.network.repository

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.api.AuthService
import com.example.mvvmdemo.network.config.RetrofitConfig
import io.reactivex.Single

/**
 * 认证相关的网络仓库。
 *
 * 封装 Retrofit 请求，向上层暴露简洁的 RxJava 接口。
 */
class AuthRepository : BaseRepository() {
    private val authService: AuthService = RetrofitConfig.getRetrofit()
        .create(AuthService::class.java)

    /**
     * 调用后端接口注册新用户。
     */
    fun register(request: RegistrationRequest): Single<User> {
        return executeRequest(authService.register(request))
    }

    /**
     * 调用后端接口登录用户。
     */
    fun login(request: LoginRequest): Single<User> {
        return executeRequest(authService.login(request))
    }
}
