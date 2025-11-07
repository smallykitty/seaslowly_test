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

@Composable
fun HelloScreen(navController: NavController, viewModel: HelloViewModel = viewModel()) {
    val userEmail by viewModel.userEmail.observeAsState()

    LaunchedEffect(Unit) {
        // In a real app, you would get this from a saved state or auth repository
        // For demo purposes, we'll set a default email
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