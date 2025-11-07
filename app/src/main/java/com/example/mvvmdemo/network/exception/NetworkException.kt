package com.example.mvvmdemo.network.exception

/**
 * 网络层统一异常定义。
 *
 * 通过不同子类区分常见错误场景，便于上层根据类型展示友好提示。
 */
sealed class NetworkException(
    message: String? = null,
    cause: Throwable? = null
) : Exception(message, cause) {
    /** 网络未连接、DNS 失败等连接问题 */
    class ConnectionError(
        message: String? = "Connection failed",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** 请求超时 */
    class TimeoutError(
        message: String? = "Request timeout",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** 其他 HTTP 层的通用错误 */
    class HttpError(
        val code: Int,
        val errorBody: String? = null,
        message: String? = "HTTP Error $code",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** JSON 解析或序列化失败 */
    class ParseException(
        message: String? = "Failed to parse response",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** 服务器 5xx 错误 */
    class ServerError(
        val code: Int,
        message: String? = "Server error",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** 客户端 4xx 错误 */
    class ClientError(
        val code: Int,
        message: String? = "Client error",
        cause: Throwable? = null
    ) : NetworkException(message, cause)

    /** 未知异常兜底 */
    class UnknownError(
        message: String? = "Unknown error occurred",
        cause: Throwable? = null
    ) : NetworkException(message, cause)
}
