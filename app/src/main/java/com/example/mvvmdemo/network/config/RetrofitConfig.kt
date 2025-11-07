package com.example.mvvmdemo.network.config

import android.util.Log
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

/**
 * Retrofit 全局配置中心。
 *
 * 负责创建 Retrofit、OkHttpClient 与 Gson 的实例，保证网络请求配置一致。
 */
object RetrofitConfig {
    private const val BASE_URL = "https://api.example.com/"
    private const val CONNECTION_TIMEOUT = 10L
    private const val READ_TIMEOUT = 30L
    private const val WRITE_TIMEOUT = 30L
    private const val TAG = "RetrofitConfig"

    private lateinit var retrofit: Retrofit

    /**
     * 提供单例 Retrofit 实例，避免重复创建。
     */
    fun getRetrofit(): Retrofit {
        if (!::retrofit.isInitialized) {
            retrofit = createRetrofit()
        }
        return retrofit
    }

    /**
     * 创建 Retrofit，并挂载统一的转换器与调用适配器。
     */
    private fun createRetrofit(): Retrofit {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .client(createOkHttpClient())
            .addConverterFactory(GsonConverterFactory.create(createGson()))
            .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
            .build()
    }

    /**
     * 配置 OkHttpClient，统一超时与日志策略。
     */
    private fun createOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS)
            .readTimeout(READ_TIMEOUT, TimeUnit.SECONDS)
            .writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS)
            .addInterceptor(createLoggingInterceptor())
            .build()
    }

    /**
     * 创建日志拦截器，打印请求与响应体，便于排查问题。
     */
    private fun createLoggingInterceptor(): HttpLoggingInterceptor {
        return HttpLoggingInterceptor { message ->
            Log.d(TAG, message)
        }.apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
    }

    /**
     * 创建统一的 Gson 实例，开启 null 序列化并格式化输出，方便调试。
     */
    private fun createGson(): Gson {
        return GsonBuilder()
            .serializeNulls()
            .setPrettyPrinting()
            .create()
    }
}
