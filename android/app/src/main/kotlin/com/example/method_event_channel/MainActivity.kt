package com.example.method_event_channel

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    // Channel Names
    private val CHANNEL_NAME = "say_name"
    private val METHOD_CHANNEL_TIMER = "timer_control"
    private val EVENT_CHANNEL_TIMER = "timer_channel"
    
    // Event Channel Variables
    private var eventSink: EventChannel.EventSink? = null
    
    // Timer Variables
    private var timerRunning = false
    private var counter = 0
    private val handler = Handler(Looper.getMainLooper())
    
    // Timer Runnable
    private val timerRunnable = object : Runnable {
        override fun run() {
            if (timerRunning) {
                counter++
                val data = mapOf(
                    "count" to counter,
                    "status" to "Running",
                    "isRunning" to true
                )
                eventSink?.success(data)
                handler.postDelayed(this, 1000)
            }
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // ========== 1. Method Channel for getName ==========
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getName" -> {
                        val name = "Ashraf from Android"
                        result.success(name)
                    }
                    else -> result.notImplemented()
                }
            }
        
        // ========== 2. Method Channel for Timer Control ==========
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_TIMER)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "start_timer" -> {
                        startTimer()
                        result.success(null)
                    }
                    "stop_timer" -> {
                        stopTimer()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        
        // ========== 3. Event Channel for Timer Updates ==========
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_TIMER)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    // Send initial data when Flutter starts listening
                    val initialData = mapOf(
                        "count" to 0,
                        "status" to "Ready",
                        "isRunning" to false
                    )
                    eventSink?.success(initialData)
                }
                
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    stopTimer()
                }
            })
    }
    
    // Start Timer Function
    private fun startTimer() {
        if (!timerRunning) {
            timerRunning = true
            counter = 0
            handler.post(timerRunnable)
        }
    }
    
    // Stop Timer Function
    private fun stopTimer() {
        timerRunning = false
        handler.removeCallbacks(timerRunnable)
        
        // Send final data when timer stops
        val stopData = mapOf(
            "count" to counter,
            "status" to "Stopped",
            "isRunning" to false
        )
        eventSink?.success(stopData)
    }
}