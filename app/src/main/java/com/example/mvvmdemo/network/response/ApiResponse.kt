package com.example.mvvmdemo.network.response

import com.google.gson.annotations.SerializedName

data class ApiResponse<T>(
    @SerializedName("success")
    val success: Boolean = false,
    
    @SerializedName("code")
    val code: Int = 0,
    
    @SerializedName("message")
    val message: String? = null,
    
    @SerializedName("data")
    val data: T? = null,
    
    @SerializedName("error")
    val error: String? = null
)
