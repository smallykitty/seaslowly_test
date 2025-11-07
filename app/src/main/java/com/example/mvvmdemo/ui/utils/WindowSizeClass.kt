package com.example.mvvmdemo.ui.utils

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

data class WindowSize(
    val width: Dp,
    val height: Dp
)

enum class ScreenSize {
    SMALL,      // Phones, 4.5-5.5 inches
    MEDIUM,     // Large phones, 5.5-6.5 inches
    LARGE,      // Tablets, 7-10 inches
    EXTRA_LARGE // Large tablets, 10+ inches
}

@Composable
fun rememberWindowSize(): WindowSize {
    val configuration = LocalConfiguration.current
    return WindowSize(
        width = configuration.screenWidthDp.dp,
        height = configuration.screenHeightDp.dp
    )
}

@Composable
fun getScreenSize(): ScreenSize {
    val configuration = LocalConfiguration.current
    val screenWidthDp = configuration.screenWidthDp
    val screenHeightDp = configuration.screenHeightDp
    
    val smallestWidth = minOf(screenWidthDp, screenHeightDp)
    
    return when {
        smallestWidth >= 720 -> ScreenSize.EXTRA_LARGE
        smallestWidth >= 600 -> ScreenSize.LARGE
        screenWidthDp >= 600 -> ScreenSize.LARGE
        screenWidthDp >= 500 -> ScreenSize.MEDIUM
        else -> ScreenSize.SMALL
    }
}

@Composable
fun isLandscape(): Boolean {
    val configuration = LocalConfiguration.current
    return configuration.screenWidthDp > configuration.screenHeightDp
}

@Composable
fun isTablet(): Boolean {
    val screenSize = getScreenSize()
    return screenSize == ScreenSize.LARGE || screenSize == ScreenSize.EXTRA_LARGE
}
