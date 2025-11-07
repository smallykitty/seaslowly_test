package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mvvmdemo.network.exception.NetworkException
import io.reactivex.Single
import io.reactivex.disposables.CompositeDisposable

/**
 * 网络请求类 ViewModel 的基础实现。
 *
 * 统一管理网络请求的生命周期（加载态、错误态、订阅释放），避免各业务 ViewModel 重复编码。
 */
open class BaseNetworkViewModel(application: Application) : AndroidViewModel(application) {
    protected val compositeDisposable = CompositeDisposable()

    private val _networkError = MutableLiveData<NetworkException?>()
    val networkError: LiveData<NetworkException?> = _networkError

    private val _isLoading = MutableLiveData(false)
    val isLoading: LiveData<Boolean> = _isLoading

    /**
     * 执行标准化的网络请求流程。
     *
     * - 自动切换加载状态
     * - 捕获并转换异常为 [NetworkException]
     * - 将成功结果回调给调用方
     *
     * @param request 封装好的请求任务
     * @param onSuccess 请求成功时回传的逻辑
     * @param onError 请求失败时的自定义处理，默认为更新 [_networkError]
     * @param showLoading 是否在请求期间展示加载态
     */
    protected fun <T> executeNetworkRequest(
        request: Single<T>,
        onSuccess: (T) -> Unit,
        onError: (NetworkException) -> Unit = { _networkError.value = it },
        showLoading: Boolean = true
    ) {
        if (showLoading) {
            _isLoading.value = true
        }
        _networkError.value = null

        val disposable = request
            .doFinally {
                if (showLoading) {
                    _isLoading.value = false
                }
            }
            .subscribe(
                { result ->
                    onSuccess(result)
                },
                { throwable ->
                    // 将任意 Throwable 统一包装成 NetworkException 便于上层展示
                    val exception = if (throwable is NetworkException) {
                        throwable
                    } else {
                        NetworkException.UnknownError(
                            message = throwable.message ?: "Unknown error occurred",
                            cause = throwable
                        )
                    }
                    onError(exception)
                }
            )

        compositeDisposable.add(disposable)
    }

    /**
     * 主动清除当前的网络错误提示。
     */
    fun clearNetworkError() {
        _networkError.value = null
    }

    override fun onCleared() {
        compositeDisposable.dispose()
        super.onCleared()
    }
}
