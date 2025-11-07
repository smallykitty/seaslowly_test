package com.example.mvvmdemo.network.repository

import android.util.Log
import com.example.mvvmdemo.network.exception.ExceptionHandler
import com.example.mvvmdemo.network.exception.NetworkException
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

/**
 * 网络仓库的通用父类。
 *
 * 提供统一的重试、线程切换与异常包装逻辑，降低业务仓库的复杂度。
 */
open class BaseRepository {
    private val tag = this::class.simpleName ?: "BaseRepository"

    /**
     * 执行网络请求并返回业务数据。
     *
     * @param request Retrofit 返回的原始请求
     * @param maxRetries 最大重试次数
     * @param initialDelay 初始重试等待时间，后续指数退避
     */
    protected fun <T> executeRequest(
        request: Single<ApiResponse<T>>,
        maxRetries: Int = 3,
        initialDelay: Long = 1000
    ): Single<T> {
        return request
            .retry { retryCount, throwable ->
                val shouldRetry = ExceptionHandler.shouldRetry(throwable) && retryCount < maxRetries
                if (shouldRetry) {
                    // 指数退避策略：延迟翻倍，避免对服务器造成压力
                    Thread.sleep((initialDelay * Math.pow(2.0, retryCount.toDouble())).toLong())
                    Log.d(tag, "Retrying request, attempt: $retryCount")
                }
                shouldRetry
            }
            .map { response ->
                if (response.success && response.data != null) {
                    response.data
                } else {
                    throw NetworkException.UnknownError(
                        message = response.message ?: "API returned unsuccessful response"
                    )
                }
            }
            .onErrorResumeNext { throwable ->
                Single.error(ExceptionHandler.handleException(throwable))
            }
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
    }
}
