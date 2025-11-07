package com.example.mvvmdemo.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import com.example.mvvmdemo.ui.viewmodel.HelloViewModel

/**
 * 欢迎页的 Jetpack Compose 实现。
 *
 * 展示当前登录用户的关键信息，并提供返回登录或跳转注册的操作入口。
 *
 * @param navController 提供返回登录页与进入注册页的导航能力
 * @param viewModel 承载欢迎页展示数据的 [HelloViewModel]
 */
@Composable
fun HelloScreen(navController: NavController, viewModel: HelloViewModel = viewModel()) {
    val userEmail by viewModel.userEmail.observeAsState()

    // 页面启动时尝试填充默认用户邮箱，方便演示效果
    LaunchedEffect(Unit) {
        // 在真实项目中，可从认证仓库或保存的状态中恢复用户邮箱
        if (userEmail.isNullOrBlank()) {
            viewModel.setUserEmail("user@example.com")
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
            text = "Hello!",
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        Text(
            text = "Welcome, ${userEmail ?: "User"}!",
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Text(
            text = "You have successfully logged in to the MVVM Demo app.",
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.padding(bottom = 32.dp)
        )

        Button(
            onClick = { navController.navigate("login") },
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp)
        ) {
            Text("Back to Login")
        }

        OutlinedButton(
            onClick = { navController.navigate("registration") },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Go to Registration")
        }
    }
}
