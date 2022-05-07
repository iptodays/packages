import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Skan {
  static const MethodChannel _channel = MethodChannel('skan');
  Skan._();

  static bool _isInstalled = false;

  static bool _isDebug = false;

  /// 注册应用网络
  static Future<void> registerAppForAdNetworkAttribution({
    bool isDebug = false,
  }) async {
    _isDebug = isDebug;
    if (isDebug || Platform.isAndroid) return;
    _isInstalled = true;
    return await _channel.invokeMethod('registerAppForAdNetworkAttribution');
  }

  /// 设置转化因子
  static Future<void> updateConversionValue(int value) async {
    if (_isDebug || Platform.isAndroid) return;
    assert(_isInstalled && value >= 0 && value <= 63);
    return await _channel.invokeMethod(
      'updateConversionValue',
      {'value': value},
    );
  }
}
