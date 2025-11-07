package com.example.mvvmdemo.network.exception

sealed class NetworkException(
    message: String? = null,
    cause: Throwable? = null
) : Exception(message, cause) {
    class ConnectionError(
        message: String? = "Connection failed",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class TimeoutError(
        message: String? = "Request timeout",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class HttpError(
        val code: Int,
        val errorBody: String? = null,
        message: String? = "HTTP Error $code",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class ParseException(
        message: String? = "Failed to parse response",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class ServerError(
        val code: Int,
        message: String? = "Server error",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class ClientError(
        val code: Int,
        message: String? = "Client error",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    class UnknownError(
        message: String? = "Unknown error occurred",
        cause: Throwable? = null
    ) : NetworkException(message, cause)
}
