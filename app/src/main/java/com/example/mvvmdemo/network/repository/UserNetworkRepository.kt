package com.example.mvvmdemo.network.repository

import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.api.UserService
import com.example.mvvmdemo.network.config.RetrofitConfig
import io.reactivex.Single

class UserNetworkRepository : BaseRepository() {
    private val userService: UserService = RetrofitConfig.getRetrofit()
        .create(UserService::class.java)

    fun getUser(userId: String): Single<User> {
        return executeRequest(userService.getUser(userId))
    }

    fun getAllUsers(): Single<List<User>> {
        return executeRequest(userService.getAllUsers())
    }
}
