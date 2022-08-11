package com.cronolab.cronolab;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

public class MyAppWidgetProvider extends AppWidgetProvider {


    MyAppWidgetProvider(){

    }
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds){
        final int n = appWidgetIds.length;
        System.out.print(n);

        for(int i=0; i<n; i++){


        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);

        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);
        views.setOnClickPendingIntent(R.id.bt_update, pendingIntent);
        appWidgetManager.updateAppWidget(appWidgetIds[i],views);
    }}
}
