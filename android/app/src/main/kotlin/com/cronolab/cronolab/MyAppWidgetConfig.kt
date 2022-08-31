package com.cronolab.cronolab

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.widget.RemoteViews
import android.widget.TextView
import io.flutter.Log

class MyAppWidgetConfig : Activity() {
    var mAppWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID
    var textWidget: TextView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setResult(RESULT_CANCELED)

        setContentView(R.layout.widget_layout)

        val intent:Intent = getIntent()
        val extras: Bundle? = intent.extras

        if(extras!=null){
            mAppWidgetId = extras.getInt(
                AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID);
        }
        if (mAppWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish();
        }

        val resultValue = Intent()

        Log.d("Add Widget", mAppWidgetId.toString())

        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, mAppWidgetId)

        setResult(RESULT_OK, resultValue)

        finish()

    }
}