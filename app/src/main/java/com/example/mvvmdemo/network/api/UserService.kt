package com.example.mvvmdemo.network.api

import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import retrofit2.http.GET
import retrofit2.http.Path

interface UserService {
    @GET("users/{id}")
    fun getUser(@Path("id") userId: String): Single<ApiResponse<User>>

    @GET("users")
    fun getAllUsers(): Single<ApiResponse<List<User>>>
}
