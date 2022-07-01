package com.iptoday.iumeng

import android.content.Context
import androidx.annotation.NonNull
import com.umeng.commonsdk.UMConfigure
import com.umeng.commonsdk.utils.UMUtils
import com.umeng.message.PushAgent
import com.umeng.message.api.UPushRegisterCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** IumengPlugin */
class IumengPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodCall: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodCall = MethodChannel(flutterPluginBinding.binaryMessenger, "iumeng")
    methodCall.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "initialize") {
      initialize(call.arguments as HashMap<*, *>, result)
    } else if (call.method == "badgeClear") {
      badgeClear(result)
    } else {
      result.notImplemented()
    }
  }

  /// 初始化
   private fun initialize(arguments: HashMap<*, *>, result: Result) {
    println("调用初始化函数")
     if (arguments["logEnabled"] == true) {
       UMConfigure.setLogEnabled(true)
     }
     val appKey = arguments["appKey"] as String
     val channel = arguments["channel"] as String
     val messageSecret = arguments["messageSecret"] as String
     UMConfigure.preInit(context, appKey, channel)
     val isMainProcess = UMUtils.isMainProgress(context)
     if (isMainProcess) {
       Thread {
           UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, messageSecret)
           PushAgent.getInstance(context).register(object : UPushRegisterCallback {
               override fun onSuccess(p0: String?) {
                   println("deviceToken=$p0")
                   if (p0 != null) {
                       methodCall.invokeMethod("registerRemoteNotifications", mapOf("result" to true))
                       methodCall.invokeMethod("deviceToken", mapOf("deviceToken" to p0))
                   }
               }

               override fun onFailure(p0: String?, p1: String?) {
                   println("errorCode=$p0   message=$p1")
                   if (p0 != null) {
                       methodCall.invokeMethod("registerRemoteNotifications",
                               mapOf("result" to false, "error" to mapOf("code" to p0, "message" to p1)))
                   }
               }
           })
       }.run()
     }
    result.success(null)
   }

  private fun badgeClear(result: Result) {
    PushAgent.getInstance(context).displayNotificationNumber = 0
    result.success(null)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodCall.setMethodCallHandler(null)
  }
}
