package com.example.mvvmdemo.network.api

import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import retrofit2.http.GET
import retrofit2.http.Path

/**
 * 用户信息相关的网络接口。
 */
interface UserService {

    /**
     * 获取指定用户信息。
     */
    @GET("users/{id}")
    fun getUser(@Path("id") userId: String): Single<ApiResponse<User>>

    /**
     * 获取全部用户列表。
     */
    @GET("users")
    fun getAllUsers(): Single<ApiResponse<List<User>>>
}
