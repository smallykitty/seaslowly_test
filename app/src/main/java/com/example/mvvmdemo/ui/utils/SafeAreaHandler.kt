package com.example.mvvmdemo.ui.utils

import android.os.Build
import android.view.WindowInsets
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

data class SafeAreaPadding(
    val top: Dp = 0.dp,
    val bottom: Dp = 0.dp,
    val start: Dp = 0.dp,
    val end: Dp = 0.dp
)

@Composable
fun rememberSafeAreaPadding(): SafeAreaPadding {
    val view = LocalView.current
    
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        val windowInsets = view.rootWindowInsets
        if (windowInsets != null) {
            val statusBars = windowInsets.getInsets(WindowInsets.Type.statusBars())
            val navigationBars = windowInsets.getInsets(WindowInsets.Type.navigationBars())
            val displayCutout = windowInsets.getInsets(WindowInsets.Type.displayCutout())
            
            return SafeAreaPadding(
                top = (statusBars.top + displayCutout.top).toFloat().dp,
                bottom = (navigationBars.bottom + displayCutout.bottom).toFloat().dp,
                start = displayCutout.left.toFloat().dp,
                end = displayCutout.right.toFloat().dp
            )
        }
    }
    
    return SafeAreaPadding()
}

fun Modifier.safeAreaPadding(padding: SafeAreaPadding): Modifier {
    return this.padding(
        top = padding.top,
        bottom = padding.bottom,
        start = padding.start,
        end = padding.end
    )
}

@Composable
fun Modifier.safeArea(): Modifier {
    val safeAreaPadding = rememberSafeAreaPadding()
    return this.safeAreaPadding(safeAreaPadding)
}
