package com.example.mvvmdemo.data.repository

import com.example.mvvmdemo.data.model.LoginRequest
import com.example.mvvmdemo.data.model.RegistrationRequest
import com.example.mvvmdemo.data.model.User

class UserRepository {
    private val users = mutableListOf<User>()
    
    suspend fun register(request: RegistrationRequest): Result<User> {
        return try {
            if (request.password != request.confirmPassword) {
                return Result.failure(Exception("Passwords do not match"))
            }
            
            if (users.any { it.email == request.email }) {
                return Result.failure(Exception("User already exists"))
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
    
    suspend fun login(request: LoginRequest): Result<User> {
        return try {
            val user = users.find { 
                it.email == request.email && it.password == request.password 
            }
            
            if (user != null) {
                Result.success(user)
            } else {
                Result.failure(Exception("Invalid email or password"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}