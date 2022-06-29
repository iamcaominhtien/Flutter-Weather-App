package com.example.climate_app
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.os.PersistableBundle
import android.widget.ImageView
import android.widget.RemoteViews
import com.squareup.picasso.Picasso
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import androidx.appcompat.app.AppCompatActivity
//
//import android.graphics.Bitmap
//import android.graphics.Canvas
//import android.graphics.Color
//import android.graphics.Paint
//import android.os.Bundle
////import kotlinx.android.synthetic.main.my_home_widget.*
//import android.graphics.BitmapFactory
//import java.io.IOException
//import android.os.AsyncTask
//import android.widget.ImageView
//import android.widget.Toast
//import java.net.URL

//import android.annotation.TargetApi
//import android.appwidget.AppWidgetProvider
//import android.os.Build

class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.my_home_widget).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.relative_layout, pendingIntent)

                setTextViewText(R.id.cityName, widgetData.getString("cityName", null)
                    ?: "___")
                setTextViewText(R.id.currentTemp, widgetData.getString("currentTemp", null)
                    ?: "___°")
                setTextViewText(R.id.description, widgetData.getString("description", null)
                    ?: "___")
                setTextViewText(R.id.day0, widgetData.getString("day0", null)
                    ?: "___")
                setTextViewText(R.id.day1, widgetData.getString("day1", null)
                    ?: "___")
                setTextViewText(R.id.day2, widgetData.getString("day2", null)
                    ?: "___")
                setTextViewText(R.id.day3, widgetData.getString("day3", null)
                    ?: "___")
                setTextViewText(R.id.day4, widgetData.getString("day4", null)
                    ?: "___")
                setTextViewText(R.id.temp0, widgetData.getString("temp0", null)
                    ?: "_°")
                setTextViewText(R.id.temp1, widgetData.getString("temp1", null)
                    ?: "_°")
                setTextViewText(R.id.temp2, widgetData.getString("temp2", null)
                    ?: "_°")
                setTextViewText(R.id.temp3, widgetData.getString("temp3", null)
                    ?: "_°")
                setTextViewText(R.id.temp4, widgetData.getString("temp4", null)
                    ?: "_°")
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidgetExample://titleClicked")
                )

//                MyImage().changeImageView()
//                AppCompatActivity().findViewById<ImageView>(R.id.icon0)
//                Picasso.get().load("http://openweathermap.org/img/wn/10d@2x.png").into(AppCompatActivity().findViewById<ImageView>(R.id.icon0))
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

class MyImage: AppCompatActivity(){
//    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
//        super.onCreate(savedInstanceState, persistentState)
//        findViewById<ImageView>(R.id.icon0).setImageURI(Uri.parse("http://openweathermap.org/img/wn/10d@2x.png"))
//    }
    fun changeImageView(){
    setContentView(R.layout.my_home_widget)
//        Picasso.get().load("http://openweathermap.org/img/wn/10d@2x.png").into(findViewById<ImageView>(R.id.icon0))
//        ImageView imgView=
        findViewById<ImageView>(R.id.icon0).setImageURI(Uri.parse("http://openweathermap.org/img/wn/10d@2x.png"))
//        img
    }
}