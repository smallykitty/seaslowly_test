package com.example.mvvmdemo.network.repository

import com.example.mvvmdemo.data.model.User
import com.example.mvvmdemo.network.api.UserService
import com.example.mvvmdemo.network.config.RetrofitConfig
import io.reactivex.Single

/**
 * 用户信息相关的网络仓库。
 */
class UserNetworkRepository : BaseRepository() {
    private val userService: UserService = RetrofitConfig.getRetrofit()
        .create(UserService::class.java)

    /**
     * 获取指定 ID 的用户信息。
     */
    fun getUser(userId: String): Single<User> {
        return executeRequest(userService.getUser(userId))
    }

    /**
     * 获取所有用户列表。
     */
    fun getAllUsers(): Single<List<User>> {
        return executeRequest(userService.getAllUsers())
    }
}
