package com.example.mvvmdemo.ui.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

/**
 * 欢迎页使用的 ViewModel。
 *
 * 仅承担展示层数据的存取，没有额外业务逻辑，便于未来扩展个性化欢迎文案。
 */
class HelloViewModel : ViewModel() {

    private val _userEmail = MutableLiveData<String?>()
    val userEmail: LiveData<String?> = _userEmail

    /**
     * 更新当前展示的用户邮箱。
     *
     * @param email 需要显示在欢迎页上的邮箱地址
     */
    fun setUserEmail(email: String) {
        _userEmail.value = email
    }
}
