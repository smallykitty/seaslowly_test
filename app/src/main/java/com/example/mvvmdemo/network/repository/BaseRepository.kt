package com.example.mvvmdemo.network.repository

import android.util.Log
import com.example.mvvmdemo.network.exception.ExceptionHandler
import com.example.mvvmdemo.network.exception.NetworkException
import com.example.mvvmdemo.network.response.ApiResponse
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

open class BaseRepository {
    private val tag = this::class.simpleName ?: "BaseRepository"

    protected fun <T> executeRequest(
        request: Single<ApiResponse<T>>,
        maxRetries: Int = 3,
        initialDelay: Long = 1000
    ): Single<T> {
        return request
            .retry { retryCount, throwable ->
                val shouldRetry = ExceptionHandler.shouldRetry(throwable) && retryCount < maxRetries
                if (shouldRetry) {
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
