package com.example.mvvmdemo.ui.screen

import android.Manifest
import android.app.Activity
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.core.app.ActivityCompat
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import com.example.mvvmdemo.MainActivity
import com.example.mvvmdemo.R
import com.example.mvvmdemo.ui.viewmodel.LoginViewModel

/**
 * 登录页面的 Jetpack Compose 实现。
 *
 * 通过观察 [LoginViewModel] 暴露的 LiveData 来同步界面状态，并在点击登录按钮时发起网络请求。
 * 该页面同时兼容 Android 13 及以上的通知权限请求逻辑。
 *
 * @param navController 用于跳转到注册页或欢迎页的导航控制器
 * @param viewModel 登录业务所依赖的视图模型，默认通过 [viewModel] 函数注入
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(navController: NavController, viewModel: LoginViewModel = viewModel()) {
    val context = LocalContext.current
    // Activity 引用用于触发运行时权限请求
    val activity = context as? Activity

    // 使用 LiveData 驱动输入框和按钮的 UI 状态
    val email by viewModel.email.observeAsState("")
    val password by viewModel.password.observeAsState("")
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()
    val loginSuccess by viewModel.loginSuccess.observeAsState()

    var notificationPermissionMessage by remember { mutableStateOf<String?>(null) }
    var pendingLogin by remember { mutableStateOf(false) }

    // 通知权限请求启动器，结合 remember 确保只创建一次
    val notificationPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (!pendingLogin) {
            return@rememberLauncherForActivityResult
        }
        pendingLogin = false
        notificationPermissionMessage = when {
            isGranted && viewModel.canPostNotifications() -> null
            isGranted -> context.getString(R.string.notification_permission_disabled_message)
            else -> context.getString(R.string.notification_permission_denied_message)
        }
        viewModel.login()
    }

    // 登录成功后跳转到欢迎页，并清除通知提示文案
    LaunchedEffect(loginSuccess) {
        if (loginSuccess == true) {
            notificationPermissionMessage = null
            navController.navigate(MainActivity.ROUTE_HELLO) {
                popUpTo("login") { inclusive = true }
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Login",
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        OutlinedTextField(
            value = email,
            onValueChange = { viewModel.onEmailChanged(it) },
            label = { Text("Email/Username") },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp),
            enabled = !isLoading
        )

        OutlinedTextField(
            value = password,
            onValueChange = { viewModel.onPasswordChanged(it) },
            label = { Text("Password") },
            visualTransformation = PasswordVisualTransformation(),
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp),
            enabled = !isLoading
        )

        errorMessage?.let { message ->
            Text(
                text = message,
                color = MaterialTheme.colorScheme.error,
                modifier = Modifier.padding(bottom = 16.dp)
            )
        }

        notificationPermissionMessage?.let { message ->
            Text(
                text = message,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier.padding(bottom = 16.dp)
            )
        }

        Button(
            onClick = {
                val notificationsEnabled = viewModel.canPostNotifications()
                val requiresRuntimePermission = Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU

                if (requiresRuntimePermission && !notificationsEnabled) {
                    if (activity == null) {
                        notificationPermissionMessage = context.getString(R.string.notification_permission_disabled_message)
                        viewModel.login()
                        return@Button
                    }

                    // 依据系统策略决定是否展示权限说明弹窗
                    val shouldShowRationale = ActivityCompat.shouldShowRequestPermissionRationale(
                        activity,
                        Manifest.permission.POST_NOTIFICATIONS
                    )

                    notificationPermissionMessage = if (shouldShowRationale) {
                        context.getString(R.string.notification_permission_rationale)
                    } else {
                        null
                    }

                    pendingLogin = true
                    notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                } else {
                    notificationPermissionMessage = if (!notificationsEnabled) {
                        context.getString(R.string.notification_permission_disabled_message)
                    } else {
                        null
                    }
                    // 权限已满足，直接调用登录逻辑
                    viewModel.login()
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp),
            enabled = !isLoading
        ) {
            if (isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(24.dp),
                    color = MaterialTheme.colorScheme.onPrimary
                )
            } else {
                Text("Login")
            }
        }

        TextButton(
            onClick = { navController.navigate("registration") },
            enabled = !isLoading
        ) {
            Text("Don't have an account? Register")
        }
    }
}
