# ------------------------------------------
# Android 框架与 Jetpack 组件
# ------------------------------------------
-keep class android.** { *; }
-dontwarn android.**

-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**
-keep class androidx.activity.** { *; }
-keep class androidx.navigation.** { *; }
-keep class androidx.compose.** { *; }
-dontwarn androidx.compose.**

# 保留所有 ViewModel，避免字段被混淆
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keepclassmembers class * extends androidx.lifecycle.ViewModel { *; }

# LiveData 相关内部类
-keepclassmembers class androidx.lifecycle.LiveData { *; }
-keepclassmembers class androidx.lifecycle.MutableLiveData { *; }

# ------------------------------------------
# Retrofit / OkHttp / RxJava / Gson
# ------------------------------------------
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-dontwarn okio.**

-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }

-dontwarn io.reactivex.**
-keep class io.reactivex.** { *; }
-dontwarn org.reactivestreams.**

-keep class com.google.gson.** { *; }
-keep class com.example.mvvmdemo.data.model.** { *; }
-keep class com.example.mvvmdemo.network.response.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ------------------------------------------
# 应用业务层
# ------------------------------------------
-keep class com.example.mvvmdemo.** { *; }
-dontwarn com.example.mvvmdemo.**
