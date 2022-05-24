import Flutter
import UIKit


public class SwiftIumengPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "iumeng", binaryMessenger: registrar.messenger())
    let instance = SwiftIumengPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let arguments = call.arguments as! Dictionary<String, Any>
      let method = call.method
      if method == "setUp" { // 开启日志
          UMCommonLogManager.setUp()
      } else if method == "log" { // 设置是否打开日志
          UMConfigure.setLogEnabled(arguments["eabled"] as! Bool)
      } else if method == "" {
          
      }
  }
}
