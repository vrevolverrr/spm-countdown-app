package com.bryansoong.spm_countdown

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.*

@Suppress("UNCHECKED_CAST")
class MainActivity: FlutterActivity() {
    private val _channel = "com.bryansoong.spm_countdown"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel).setMethodCallHandler { call, result ->
            when(call.method) {
                "getScreenLockedState" -> result.success(getScreenLockedState())
                "writeFile" -> result.success(writeFile(call.argument<String>("filename") as String, call.argument<Any>("data") as Any))
                "readFile" -> result.success(readFile(call.argument<String>("filename") as String))
                "fileExists" -> result.success(fileExists(call.argument<String>("filename") as String))
                "removeFile" -> result.success(removeFile(call.argument<String>("filename") as String))

                else -> result.notImplemented()
            }
        }
    }

    private fun getScreenLockedState(): Boolean {
        val powerManager: PowerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        return !powerManager.isInteractive
    }

    private fun removeFile(filename: String) {
        File(filesDir.path + '/' + filename).delete()
    }

    private fun writeFile(filename: String, data: Any) {
        val fileOutputStream = FileOutputStream(filesDir.path + '/' + filename)
        val objectOutputStream = ObjectOutputStream(fileOutputStream)

        try {
            objectOutputStream.writeObject(data)

        } catch (e: IOException) {

        } finally {
            fileOutputStream.close()
            objectOutputStream.close()
        }
    }

    private fun readFile(filename: String): Any? {
        val fileInputStream = FileInputStream(filesDir.path + '/' + filename)
        val objectInputStream = ObjectInputStream(fileInputStream)

        return try {
            objectInputStream.readObject()

        } catch (e: IOException) {

        } finally {
            fileInputStream.close()
            objectInputStream.close()
        }
    }

    private fun fileExists(filename: String): Boolean? {
        return try {
            File(filesDir.path + '/' + filename).exists()

        } catch (e: IOException) {
            null
        }
    }
}