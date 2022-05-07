import Flutter
import UIKit
import StoreKit.SKAdNetwork

@available(iOS 11.3, *)
public class SwiftSkanPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "skan", binaryMessenger: registrar.messenger())
    let instance = SwiftSkanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let method = call.method
      if method == "registerAppForAdNetworkAttribution" {
          SKAdNetwork.registerAppForAdNetworkAttribution()
      } else if method == "updateConversionValue" {
          let args = call.arguments as! Dictionary<String, Any>
          let value = args["value"] as! Int
          if #available(iOS 15.4, *) {
              SKAdNetwork.updatePostbackConversionValue(value)
          } else if #available(iOS 14.0, *) {
              SKAdNetwork.updateConversionValue(value)
          }
      }
      result(nil)
  }
}
