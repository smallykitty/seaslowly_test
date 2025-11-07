package com.example.mvvmdemo.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import com.example.mvvmdemo.MainActivity
import com.example.mvvmdemo.ui.utils.getResponsivePadding
import com.example.mvvmdemo.ui.utils.getResponsiveSpacing
import com.example.mvvmdemo.ui.utils.getResponsiveValue
import com.example.mvvmdemo.ui.viewmodel.RegistrationViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RegistrationScreen(navController: NavController, viewModel: RegistrationViewModel = viewModel()) {
    val email by viewModel.email.observeAsState("")
    val password by viewModel.password.observeAsState("")
    val confirmPassword by viewModel.confirmPassword.observeAsState("")
    val isLoading by viewModel.isLoading.observeAsState(false)
    val errorMessage by viewModel.errorMessage.observeAsState()
    val registrationSuccess by viewModel.registrationSuccess.observeAsState()

    LaunchedEffect(registrationSuccess) {
        if (registrationSuccess == true) {
            navController.navigate(MainActivity.ROUTE_HELLO) {
                popUpTo("login") { inclusive = true }
            }
        }
    }

    val responsivePadding = getResponsivePadding()
    val responsiveSpacing = getResponsiveSpacing()
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
                text = "Register",
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

            OutlinedTextField(
                value = confirmPassword,
                onValueChange = { viewModel.onConfirmPasswordChanged(it) },
                label = { Text("Confirm Password") },
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

            Button(
                onClick = { 
                    viewModel.register()
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
                    Text("Register")
                }
            }

            TextButton(
                onClick = { navController.navigateUp() },
                enabled = !isLoading
            ) {
                Text("Already have an account? Login")
            }
        }
    }
}