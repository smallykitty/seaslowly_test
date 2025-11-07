package com.example.mvvmdemo.notification

import android.Manifest
import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.core.graphics.drawable.toBitmap
import com.example.mvvmdemo.MainActivity
import com.example.mvvmdemo.R

class LoginNotificationManager(private val context: Context) {

    private val notificationManager = NotificationManagerCompat.from(context)

    fun canPostNotifications(): Boolean {
        val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
        return hasPermission && notificationManager.areNotificationsEnabled()
    }

    fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                context.getString(R.string.notification_channel_login_name),
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = context.getString(R.string.notification_channel_login_description)
            }
            val manager = context.getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    @SuppressLint("MissingPermission")
    fun showLoginSuccessNotification(userIdentifier: String) {
        if (!canPostNotifications()) return

        ensureNotificationChannel()

        val displayName = userIdentifier.substringBefore('@').ifBlank { userIdentifier }
        val title = context.getString(R.string.notification_login_success_title)
        val message = context.getString(R.string.notification_login_success_message, displayName)

        val contentIntent = createContentIntent()

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_login_success)
            .setContentTitle(title)
            .setContentText(message)
            .setAutoCancel(true)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(contentIntent)
            .setColor(ContextCompat.getColor(context, R.color.notification_accent))
            .setStyle(
                NotificationCompat.BigTextStyle()
                    .setBigContentTitle(title)
                    .bigText(message)
            )

        ContextCompat.getDrawable(context, R.drawable.ic_login_success)?.mutate()?.let { drawable ->
            DrawableCompat.setTint(drawable, ContextCompat.getColor(context, R.color.notification_accent))
            builder.setLargeIcon(drawable.toBitmap())
        }

        builder.addAction(
            0,
            context.getString(R.string.notification_login_success_action_view),
            contentIntent
        )

        notificationManager.notify(NOTIFICATION_ID_LOGIN_SUCCESS, builder.build())
    }

    private fun createContentIntent(): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra(MainActivity.EXTRA_NAVIGATE_TO, MainActivity.ROUTE_HELLO)
        }

        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0

        return PendingIntent.getActivity(context, 0, intent, flags)
    }

    companion object {
        const val CHANNEL_ID = "login_notifications_channel"
        const val NOTIFICATION_ID_LOGIN_SUCCESS = 1001
    }
}
