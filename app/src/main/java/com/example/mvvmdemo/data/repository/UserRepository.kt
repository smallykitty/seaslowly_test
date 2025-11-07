package com.example.mvvmdemo.data.repository

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User

/**
 * 本地内存版的用户仓库。
 *
 * 在 Demo 中替代真实数据库，只在应用运行期间保存注册的用户数据。
 */
class UserRepository {
    private val users = mutableListOf<User>()

    /**
     * 注册新用户。
     *
     * - 校验密码一致性
     * - 校验邮箱是否已存在
     * - 将新用户存储到内存中
     */
    suspend fun register(request: RegistrationRequest): Result<User> {
        return try {
            if (request.password != request.confirmPassword) {
                return Result.failure(Exception("两次输入的密码不一致"))
            }

            if (users.any { it.email == request.email }) {
                return Result.failure(Exception("用户已存在"))
            }

            val user = User(
                email = request.email,
                password = request.password
            )
            users.add(user)
            Result.success(user)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * 执行本地登录。
     *
     * @return LoginRequest 对应的用户信息，如果校验失败则返回异常
     */
    suspend fun login(request: LoginRequest): Result<User> {
        return try {
            val user = users.find {
                it.email == request.email && it.password == request.password
            }

            if (user != null) {
                Result.success(user)
            } else {
                Result.failure(Exception("邮箱或密码错误"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
