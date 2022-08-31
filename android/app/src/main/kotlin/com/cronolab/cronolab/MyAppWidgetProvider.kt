package com.cronolab.cronolab

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import android.widget.Toast
import io.flutter.Log
import java.security.AccessController.getContext


class MyAppWidgetProvider : AppWidgetProvider() {



    companion object {
        val TOAST_ACTION = "com.cronolab.cronolab.listview.TOAST_ACTION"
        val EXTRA_ITEM = "com.cronolab.cronolab.listview.EXTRA_ITEM"
        val APPWIDGET_UPDATE = "com.cronolab.listview.UPDATE"
        val ACTION_REFRESH = "refresh"
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray ) {
        appWidgetIds.forEach { appWidgetId ->

            Log.d("UPDAtE", "update on widget")

            updateAppWidget(context, appWidgetManager, appWidgetId)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.listView)

        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager,
                                appWidgetId: Int) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        var serviceIntent = Intent(context, WidgetService::class.java)
        serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        serviceIntent.setData((Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))))

        var intent:Intent = Intent(context, MainActivity::class.java)
        var pendingIntent: PendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

        views.setRemoteAdapter(R.id.listView, serviceIntent)
        views.setOnClickPendingIntent(R.id.linearLayout, pendingIntent)

        appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.listView)
        appWidgetManager.updateAppWidget(appWidgetId, views)


    }

    override fun onReceive(context: Context?, intent: Intent) {

        if (ACTION_REFRESH == intent.action) {
            //io.flutter.Log.d("REFRESH", "refreshing")
            val appWidgetId = intent.getIntArrayExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID
            )
            io.flutter.Log.d("AppWidgetsIds", appWidgetId.toString())
            var appWidgetManager =AppWidgetManager.getInstance(context)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.listView)
            var viewIndex = intent.getIntExtra(EXTRA_ITEM, 0)
            Toast.makeText(context, "TOuch view "+viewIndex, Toast.LENGTH_SHORT)

        }
        super.onReceive(context, intent)
    }

}