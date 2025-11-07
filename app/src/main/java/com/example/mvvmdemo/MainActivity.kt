package com.example.mvvmdemo

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
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

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Configure display cutout (notch) handling
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.attributes.apply {
                layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
            }
        }
        
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
