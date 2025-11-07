package com.example.mvvmdemo.network.exception

import io.reactivex.exceptions.CompositeException
import retrofit2.HttpException
import java.io.IOException
import java.net.SocketTimeoutException
import java.net.ConnectException

object ExceptionHandler {
    fun handleException(throwable: Throwable): NetworkException {
        return when (throwable) {
            is NetworkException -> throwable
            is HttpException -> {
                val code = throwable.code()
                val message = throwable.message()
                val errorBody = throwable.response()?.errorBody()?.string()
                
                when {
                    code in 400..499 -> NetworkException.ClientError(
                        code = code,
                        message = message ?: "Client Error: $code"
                    )
                    code in 500..599 -> NetworkException.ServerError(
                        code = code,
                        message = message ?: "Server Error: $code"
                    )
                    else -> NetworkException.HttpError(
                        code = code,
                        errorBody = errorBody,
                        message = message ?: "HTTP Error: $code"
                    )
                }
            }
            is SocketTimeoutException -> NetworkException.TimeoutError(
                message = "Request timed out",
                cause = throwable
            )
            is ConnectException -> NetworkException.ConnectionError(
                message = "Connection failed: ${throwable.message}",
                cause = throwable
            )
            is IOException -> NetworkException.ConnectionError(
                message = "Network error: ${throwable.message}",
                cause = throwable
            )
            is CompositeException -> {
                val first = throwable.exceptions.firstOrNull()
                if (first != null) {
                    handleException(first)
                } else {
                    NetworkException.UnknownError(
                        message = "Composite error occurred",
                        cause = throwable
                    )
                }
            }
            else -> NetworkException.UnknownError(
                message = "Unknown error: ${throwable.message}",
                cause = throwable
            )
        }
    }

    fun shouldRetry(throwable: Throwable): Boolean {
        val exception = if (throwable is NetworkException) throwable else handleException(throwable)
        return when (exception) {
            is NetworkException.ClientError -> false
            is NetworkException.HttpError -> {
                exception.code !in 400..499
            }
            else -> true
        }
    }
}
