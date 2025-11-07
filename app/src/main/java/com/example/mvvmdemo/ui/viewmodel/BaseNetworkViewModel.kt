package com.example.mvvmdemo.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mvvmdemo.network.exception.NetworkException
import io.reactivex.Single
import io.reactivex.disposables.CompositeDisposable

open class BaseNetworkViewModel(application: Application) : AndroidViewModel(application) {
    protected val compositeDisposable = CompositeDisposable()

    val _networkError = MutableLiveData<NetworkException?>()
    val networkError: LiveData<NetworkException?> = _networkError

    private val _isLoading = MutableLiveData(false)
    val isLoading: LiveData<Boolean> = _isLoading

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

    fun clearNetworkError() {
        _networkError.value = null
    }

    override fun onCleared() {
        compositeDisposable.dispose()
        super.onCleared()
    }
}
