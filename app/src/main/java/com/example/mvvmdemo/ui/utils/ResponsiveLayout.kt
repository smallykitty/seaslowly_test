package com.example.mvvmdemo.ui.utils

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Composable
fun getResponsiveValue(
    small: Dp,
    medium: Dp? = null,
    large: Dp? = null,
    extraLarge: Dp? = null
): Dp {
    val screenSize = getScreenSize()
    return when (screenSize) {
        ScreenSize.SMALL -> small
        ScreenSize.MEDIUM -> medium ?: small
        ScreenSize.LARGE -> large ?: medium ?: small
        ScreenSize.EXTRA_LARGE -> extraLarge ?: large ?: medium ?: small
    }
}

@Composable
fun getResponsiveTextScale(): Float {
    val screenSize = getScreenSize()
    return when (screenSize) {
        ScreenSize.SMALL -> 1.0f
        ScreenSize.MEDIUM -> 1.1f
        ScreenSize.LARGE -> 1.2f
        ScreenSize.EXTRA_LARGE -> 1.3f
    }
}

@Composable
fun getResponsivePadding(): Dp {
    return getResponsiveValue(
        small = 16.dp,
        medium = 20.dp,
        large = 24.dp,
        extraLarge = 28.dp
    )
}

@Composable
fun getResponsiveSpacing(): Dp {
    return getResponsiveValue(
        small = 8.dp,
        medium = 12.dp,
        large = 16.dp,
        extraLarge = 20.dp
    )
}

@Composable
fun getResponsiveButtonHeight(): Dp {
    return getResponsiveValue(
        small = 48.dp,
        medium = 52.dp,
        large = 56.dp,
        extraLarge = 60.dp
    )
}

@Composable
fun getMaxFormWidth(): Dp {
    val screenSize = getScreenSize()
    return when (screenSize) {
        ScreenSize.SMALL -> 320.dp
        ScreenSize.MEDIUM -> 400.dp
        ScreenSize.LARGE -> 500.dp
        ScreenSize.EXTRA_LARGE -> 600.dp
    }
}

@Composable
fun getColumnsForGrid(): Int {
    val screenSize = getScreenSize()
    val isLandscape = isLandscape()
    
    return when {
        isLandscape && screenSize == ScreenSize.EXTRA_LARGE -> 4
        isLandscape && screenSize == ScreenSize.LARGE -> 3
        isLandscape && screenSize == ScreenSize.MEDIUM -> 2
        screenSize == ScreenSize.EXTRA_LARGE -> 3
        screenSize == ScreenSize.LARGE -> 2
        else -> 1
    }
}
