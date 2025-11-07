package com.example.mvvmdemo.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import com.example.mvvmdemo.ui.utils.getResponsivePadding
import com.example.mvvmdemo.ui.utils.getResponsiveSpacing
import com.example.mvvmdemo.ui.utils.getResponsiveValue
import com.example.mvvmdemo.ui.viewmodel.HelloViewModel

@Composable
fun HelloScreen(navController: NavController, viewModel: HelloViewModel = viewModel()) {
    val userEmail by viewModel.userEmail.observeAsState()

    LaunchedEffect(Unit) {
        if (userEmail.isNullOrBlank()) {
            viewModel.setUserEmail("user@example.com")
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
                text = "Hello!",
                style = MaterialTheme.typography.headlineMedium,
                modifier = Modifier.padding(bottom = responsiveSpacing * 2)
            )

            Text(
                text = "Welcome, ${userEmail ?: "User"}!",
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier.padding(bottom = responsiveSpacing * 2),
                textAlign = TextAlign.Center
            )

            Text(
                text = "You have successfully logged in to the MVVM Demo app.",
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier
                    .padding(bottom = responsiveSpacing * 3)
                    .fillMaxWidth(),
                textAlign = TextAlign.Center
            )

            Button(
                onClick = { navController.navigate("login") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(getResponsiveValue(
                        small = 48.dp,
                        medium = 52.dp,
                        large = 56.dp,
                        extraLarge = 60.dp
                    ))
                    .padding(bottom = responsiveSpacing)
            ) {
                Text("Back to Login")
            }

            OutlinedButton(
                onClick = { navController.navigate("registration") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(getResponsiveValue(
                        small = 48.dp,
                        medium = 52.dp,
                        large = 56.dp,
                        extraLarge = 60.dp
                    ))
            ) {
                Text("Go to Registration")
            }
        }
    }
}