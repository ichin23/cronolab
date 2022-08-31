package com.cronolab.cronolab

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.os.Bundle
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import java.text.SimpleDateFormat
import java.util.*

class DataProviderTeste : RemoteViewsService.RemoteViewsFactory {
    var lista = mutableListOf<MutableMap<String, String>>()
    var appWidgetId:Int
    var context: Context

    constructor(context:Context, intent: Intent?){
        this.context=context
        appWidgetId= intent!!.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
    }
    override fun onCreate() {
        initData()
    }

    override fun onDataSetChanged() {
        io.flutter.Log.d("DATACHANGED", "Updating")
        lista.clear()

        var databasePath:String =context.getDatabasePath("mydatabase.db").absolutePath
        val db: SQLiteDatabase =
            SQLiteDatabase.openDatabase(databasePath, null, SQLiteDatabase.OPEN_READONLY)

        var query: Cursor = db.rawQuery("SELECT dever.title, turma.nome,materia.nome, dever.data FROM dever INNER JOIN turma ON dever.turmaID=turma.id INNER JOIN materia ON dever.materiaID=materia.id  ORDER BY data", null)

        if(query.moveToFirst()){
            do {
                var queryMap:MutableMap<String, String> = mutableMapOf()
                queryMap["title"] = query.getString(0)
                queryMap["turma"] = query.getString(1)
                queryMap["materia"] = query.getString(2)
                queryMap["data"] = query.getLong(3).toString()
                lista.add(queryMap);
            } while (query.moveToNext())
        }
    }

    override fun onDestroy() {
        TODO("Not yet implemented")
    }

    override fun getCount(): Int {
        return lista.size
    }

    override fun getViewAt(p0: Int): RemoteViews {
        var dateFormat:SimpleDateFormat = SimpleDateFormat("dd/MM - hh:mm")
        var calendar:Calendar = Calendar.getInstance()
        calendar.setTimeInMillis(lista.get(p0)["data"]?.toLong() ?: 0)
        var view = RemoteViews(context.getPackageName(),
            R.layout.widget_item);

        val extras = Bundle()
        extras.putInt(MyAppWidgetProvider.EXTRA_ITEM, p0)
        val fillInIntent = Intent()
        fillInIntent.putExtras(extras)

        view.setOnClickFillInIntent(R.id.widget_item, fillInIntent)
        view.setTextViewText(R.id.title, lista.get(p0)["title"]);
        view.setTextViewText(R.id.turma, lista.get(p0)["turma"]+" - "+lista.get(p0)["materia"])
        view.setTextViewText(R.id.data, dateFormat.format( calendar.time))

        return view;
    }

    override fun getLoadingView(): RemoteViews? {
        return null;
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(p0: Int): Long {
        return p0.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    private fun initData(){
        io.flutter.Log.d("DATABASE", "querying")
        lista.clear()
        var databasePath:String =context.getDatabasePath("mydatabase.db").absolutePath
        val db: SQLiteDatabase =
            SQLiteDatabase.openDatabase(databasePath, null, SQLiteDatabase.OPEN_READONLY)
        var query: Cursor = db.rawQuery("SELECT dever.title, turma.nome,materia.nome, dever.data FROM dever INNER JOIN turma ON dever.turmaID=turma.id INNER JOIN materia ON dever.materiaID=materia.id  ORDER BY data", null)

        if(query.moveToFirst()){
            do {
                var queryMap:MutableMap<String, String> = mutableMapOf()
                queryMap["title"] = query.getString(0)
                queryMap["turma"] = query.getString(1)
                queryMap["materia"] = query.getString(2)
                queryMap["data"] = query.getLong(3).toString()
                lista.add(queryMap);
            } while (query.moveToNext())
        }
    }

}