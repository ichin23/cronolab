package com.cronolab.cronolab

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.cronolab.cronolab.MyAppWidgetProvider.Companion.APPWIDGET_UPDATE
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "cronolab.cronolab/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{call, result->
            if(call.method=="update"){

                val context: Context = applicationContext
                val widgetManager = AppWidgetManager.getInstance(context)
                val widgetComponent = ComponentName(context, MyAppWidgetProvider::class.java)
                val widgetIds = widgetManager.getAppWidgetIds(widgetComponent)
                val update = Intent()
                update.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
                update.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                context.sendBroadcast(update)

                result.success(true)
            }else{
                result.notImplemented()
            }
        }
    }
}
