package com.example.mvvmdemo.network.response

import com.google.gson.annotations.SerializedName

/**
 * 后端统一响应模型。
 *
 * @param success 接口是否调用成功
 * @param code 业务状态码
 * @param message 描述信息
 * @param data 业务数据主体
 * @param error 错误详情
 */
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
