package com.example.mvvmdemo.ui.screen

import android.Manifest
import android.app.Activity
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
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
import com.example.mvvmdemo.ui.utils.getResponsivePadding
import com.example.mvvmdemo.ui.utils.getResponsiveSpacing
import com.example.mvvmdemo.ui.utils.getResponsiveValue
import com.example.mvvmdemo.ui.utils.isTablet
import com.example.mvvmdemo.ui.viewmodel.LoginViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(navController: NavController, viewModel: LoginViewModel = viewModel()) {
    val context = LocalContext.current
    val activity = context as? Activity

    val email by viewModel.email.observeAsState("")
    val password by viewModel.password.observeAsState("")
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()
    val loginSuccess by viewModel.loginSuccess.observeAsState()

    var notificationPermissionMessage by remember { mutableStateOf<String?>(null) }
    var pendingLogin by remember { mutableStateOf(false) }

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

    LaunchedEffect(loginSuccess) {
        if (loginSuccess == true) {
            notificationPermissionMessage = null
            navController.navigate(MainActivity.ROUTE_HELLO) {
                popUpTo("login") { inclusive = true }
            }
        }
    }

    val responsivePadding = getResponsivePadding()
    val responsiveSpacing = getResponsiveSpacing()
    //val tablet = isTablet()
    val formMaxWidth = getResponsiveValue(
        small = 320.dp,
        medium = 400.dp,
        large = 500.dp,
        extraLarge = 600.dp
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(responsivePadding),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .verticalScroll(rememberScrollState())
                .widthIn(max = formMaxWidth),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = "Login",
                style = MaterialTheme.typography.headlineMedium,
                modifier = Modifier.padding(bottom = responsiveSpacing * 3)
            )

            OutlinedTextField(
                value = email,
                onValueChange = { viewModel.onEmailChanged(it) },
                label = { Text("Email/Username") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = responsiveSpacing),
                enabled = !isLoading
            )

            OutlinedTextField(
                value = password,
                onValueChange = { viewModel.onPasswordChanged(it) },
                label = { Text("Password") },
                visualTransformation = PasswordVisualTransformation(),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = responsiveSpacing),
                enabled = !isLoading
            )

            errorMessage?.let { message ->
                Text(
                    text = message,
                    color = MaterialTheme.colorScheme.error,
                    modifier = Modifier.padding(bottom = responsiveSpacing),
                    style = MaterialTheme.typography.bodySmall
                )
            }

            notificationPermissionMessage?.let { message ->
                Text(
                    text = message,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = responsiveSpacing),
                    style = MaterialTheme.typography.bodySmall
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
                        viewModel.login()
                    }
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(getResponsiveValue(
                        small = 48.dp,
                        medium = 52.dp,
                        large = 56.dp,
                        extraLarge = 60.dp
                    ))
                    .padding(bottom = responsiveSpacing),
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
}
