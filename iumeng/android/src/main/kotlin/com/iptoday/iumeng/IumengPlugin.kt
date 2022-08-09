package com.iptoday.iumeng

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import com.umeng.commonsdk.utils.UMUtils
import com.umeng.message.MsgConstant
import com.umeng.message.PushAgent
import com.umeng.message.api.UPushMessageHandler
import com.umeng.message.api.UPushRegisterCallback
import com.umeng.message.entity.UMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** IumengPlugin */
class IumengPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var methodCall: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodCall = MethodChannel(flutterPluginBinding.binaryMessenger, "iumeng")
    methodCall.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      when (call.method) {
          "preInit"->preInit(call.arguments as HashMap<*, *>, result)
          "initialize"->initialize(call.arguments as HashMap<*, *>, result)
          "setProfile"->setProfile(call.arguments as HashMap<*, *>, result)
          "setAutoAlert"->setAutoAlert(call.arguments as HashMap<*, *>, result)
          "profileSignOff"-> profileSignOff(result)
          "beginLogPageView"-> beginLogPageView(call.arguments as HashMap<*, *>, result)
          "endLogPageView"-> endLogPageView(call.arguments as HashMap<*, *>, result)
          "logEvent"-> logEvent(call.arguments as HashMap<*, *>, result)
          "badgeClear"->badgeClear(result)
          else-> result.notImplemented()
      }
  }

    /// 预初始化
    private fun preInit(arguments: HashMap<*, *>, result: Result) {
        UMConfigure.preInit(context, arguments["appKey"] as String, arguments["channel"] as String)
        result.success(null)
    }


  /// 初始化
   private fun initialize(arguments: HashMap<*, *>, result: Result) {
      UMConfigure.submitPolicyGrantResult(context, true)
     if (arguments["logEnabled"] == true) {
       UMConfigure.setLogEnabled(true)
     }
     val appKey = arguments["appKey"] as String
     val channel = arguments["channel"] as String
     val messageSecret = arguments["messageSecret"] as String
     preInit(arguments, result)
      val isMainProcess = UMUtils.isMainProgress(context)
     if (isMainProcess) {
       Thread {
           UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, messageSecret)
           if (arguments["appKey"] == true) {
               MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
           } else {
               MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
           }
           pushRegister()
       }.run()
     }
      pushRegister()
      PushAgent.getInstance(context).displayNotificationNumber = 0
      //服务端控制声音
      PushAgent.getInstance(context).notificationPlaySound = MsgConstant.NOTIFICATION_PLAY_SERVER
      //客户端允许呼吸灯点亮
      PushAgent.getInstance(context).notificationPlayLights = MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE
      //客户端禁止振动
      PushAgent.getInstance(context).notificationPlayVibrate = MsgConstant.NOTIFICATION_PLAY_SDK_DISABLE
      PushAgent.getInstance(context).muteDurationSeconds = 15;
      PushAgent.getInstance(context).notificationClickHandler = UPushMessageHandler {
          _, p1 -> methodCall.invokeMethod("onOpenNotification", p1?.extra)
      }
      PushAgent.getInstance(context).onAppStart()
    result.success(null)
   }

    /// 注册推送
    private fun pushRegister() {
        PushAgent.getInstance(context).register(object : UPushRegisterCallback {
            override fun onSuccess(p0: String?) {
                if (p0 != null) {
                    Handler(Looper.getMainLooper()).post {
                        methodCall.invokeMethod("registerRemoteNotifications", mapOf("result" to true))
                        methodCall.invokeMethod("deviceToken", mapOf("deviceToken" to p0))
                    }
                }
            }

            override fun onFailure(p0: String?, p1: String?) {
                if (p0 != null) {
                    Handler(Looper.getMainLooper()).post {
                        methodCall.invokeMethod("registerRemoteNotifications",
                                mapOf("result" to false, "error" to mapOf("code" to p0, "message" to p1)))
                    }
                }
            }
        })
    }

    /// 清除角标
  private fun badgeClear(result: Result) {
    PushAgent.getInstance(context).displayNotificationNumber = 0
    result.success(null)
  }

    private fun setAutoAlert(arguments: HashMap<*, *>,result: Result) {
        PushAgent.getInstance(context).notificationOnForeground = arguments["enabled"] as Boolean
    }

    private fun setProfile(arguments: HashMap<*, *>,result: Result) {
        if (arguments["provider"] != null && arguments["puid"] != null) {
            MobclickAgent.onProfileSignIn(arguments["provider"] as String, arguments["puid"] as String)
        } else if (arguments["puid"] != null) {
            MobclickAgent.onProfileSignIn(arguments["puid"] as String)
        }
        result.success(null)
    }

    private fun profileSignOff(result: Result) {
        MobclickAgent.onProfileSignOff()
        result.success(null)
    }

    private fun beginLogPageView(arguments: HashMap<*, *>,result: Result) {
        MobclickAgent.onPageStart(arguments["pageName"] as String)
        result.success(null)
    }

    private fun endLogPageView(arguments: HashMap<*, *>,result: Result) {
        MobclickAgent.onPageEnd(arguments["pageName"] as String)
        result.success(null)
    }

    private fun logEvent(arguments: HashMap<*, *>,result: Result) {
        if (arguments["label"] != null) {
            MobclickAgent.onEvent(context, arguments["eventId"] as String, arguments["label"] as String)
        } else if ( arguments["attributes"] != null && arguments["millisecond"] != null) {
            MobclickAgent.onEventValue(context, arguments["eventId"] as String,
                    arguments["attributes"] as Map<String, String>,
                    arguments["millisecond"] as Int)
        } else if (arguments["attributes"] != null) {
            MobclickAgent.onEventObject(context, arguments["eventId"] as String,
                    arguments["attributes"] as Map<String, String>)
        } else {
            MobclickAgent.onEvent(context, arguments["eventId"] as String)
        }
        result.success(null)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodCall.setMethodCallHandler(null)
    }
}
