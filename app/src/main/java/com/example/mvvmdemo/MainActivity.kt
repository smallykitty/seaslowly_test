package com.example.mvvmdemo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.mvvmdemo.ui.screen.HelloScreen
import com.example.mvvmdemo.ui.screen.LoginScreen
import com.example.mvvmdemo.ui.screen.RegistrationScreen
import com.example.mvvmdemo.ui.theme.MVVMDemoTheme

/**
 * 应用的入口 Activity，负责托管 Compose 导航容器。
 */
class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 支持从通知直接跳转到欢迎页
        val startDestination = if (intent?.getStringExtra(EXTRA_NAVIGATE_TO) == ROUTE_HELLO) {
            ROUTE_HELLO
        } else {
            ROUTE_LOGIN
        }

        setContent {
            MVVMDemoTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val navController = rememberNavController()

                    NavHost(
                        navController = navController,
                        startDestination = startDestination
                    ) {
                        composable(ROUTE_LOGIN) {
                            LoginScreen(navController = navController)
                        }
                        composable(ROUTE_REGISTRATION) {
                            RegistrationScreen(navController = navController)
                        }
                        composable(ROUTE_HELLO) {
                            HelloScreen(navController = navController)
                        }
                    }
                }
            }
        }
    }

    companion object {
        const val EXTRA_NAVIGATE_TO = "extra_navigate_to"
        private const val ROUTE_LOGIN = "login"
        private const val ROUTE_REGISTRATION = "registration"
        const val ROUTE_HELLO = "hello"
    }
}
