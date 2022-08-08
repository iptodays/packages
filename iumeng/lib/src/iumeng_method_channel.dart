/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-05-25 20:54:09
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-08-08 18:24:47
 * @FilePath: /iumeng/lib/src/iumeng_method_channel.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'iumeng_platform_interface.dart';

/// An implementation of [IumengPlatform] that uses method channels.
class MethodChannelIumeng extends IumengPlatform {
  EventHandler? _onReceiveNotification;
  EventHandler? _onOpenNotification;
  TokenHandler? _deviceToken;
  RegisterHandler? _registerRemoteNotifications;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel = const MethodChannel('iumeng')
    ..setMethodCallHandler(_setMethodCallHandler);

  /// 由原生调用flutter的处理
  Future<dynamic> _setMethodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'registerRemoteNotifications':
        if (_registerRemoteNotifications != null) {
          _registerRemoteNotifications!(
            call.arguments['result'],
            call.arguments['error'],
          );
        }
        break;
      case 'deviceToken':
        if (_deviceToken != null) {
          _deviceToken!(call.arguments['deviceToken']);
        }
        break;
      case 'onReceiveNotification':
        if (_onReceiveNotification != null) {
          _onReceiveNotification!(call.arguments);
        }
        break;
      case 'onOpenNotification':
        if (_onOpenNotification != null) {
          _onOpenNotification!(call.arguments);
        }
        break;
      default:
    }
  }

  @override
  Future<void> initialize({
    required String appKey,
    required String channel,
    String? messageSecret,
    bool auto = true,
    required bool logEnabled,
  }) async {
    return methodChannel.invokeMethod('initialize', {
      'appKey': appKey,
      'channel': channel,
      'logEnabled': logEnabled,
      'messageSecret': messageSecret,
      'auto': auto,
    });
  }

  @override
  Future<void> requestPermission({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    if (Platform.isAndroid) return;
    await methodChannel.invokeMethod(
      'requestPermission',
      {
        'alert': alert,
        'badge': badge,
        'sound': sound,
      },
    );
  }

  /// 操作回调
  @override
  void addEventHandler({
    RegisterHandler? registerRemoteNotifications,
    TokenHandler? deviceToken,
    EventHandler? onReceiveNotification,
    EventHandler? onOpenNotification,
  }) {
    _registerRemoteNotifications = registerRemoteNotifications;
    _deviceToken = deviceToken;
    _onOpenNotification = onOpenNotification;
    _onReceiveNotification = onReceiveNotification;
  }

  @override
  Future<void> badgeClear() async {
    return methodChannel.invokeMethod('badgeClear');
  }

  @override
  Future<void> setAutoAlert({required bool enabled}) async {
    if (Platform.isAndroid) return;
    return methodChannel.invokeMethod(
      'setAutoAlert',
      {'enabled': enabled},
    );
  }

  @override
  Future<Map<String, dynamic>?> getLaunchAppNotification() async {
    if (Platform.isAndroid) return null;
    return methodChannel.invokeMethod<Map<String, dynamic>?>(
      'getLaunchAppNotification',
    );
  }

  @override
  Future<void> setProfile({
    String? puid,
    String? provider,
  }) async {
    Map<String, String> args = {};
    if (puid != null) {
      args['puid'] = puid;
    }
    if (provider != null) {
      args['provider'] = provider;
    }
    return methodChannel.invokeMethod(
      'setProfile',
      args,
    );
  }

  @override
  Future<void> profileSignOff() async {
    return methodChannel.invokeMethod('profileSignOff');
  }

  @override
  Future<void> logPageView({
    required String pageName,
    required int seconds,
  }) async {
    return methodChannel.invokeMethod(
      'logPageView',
      {
        'pageName': pageName,
        'seconds': seconds,
      },
    );
  }

  @override
  Future<void> beginLogPageView({required String pageName}) async {
    return methodChannel.invokeMethod(
      'beginLogPageView',
      {
        'pageName': pageName,
      },
    );
  }

  @override
  Future<void> endLogPageView({required String pageName}) async {
    return methodChannel.invokeMethod(
      'endLogPageView',
      {
        'pageName': pageName,
      },
    );
  }

  @override
  Future<void> logEvent({
    required String eventId,
    String? label,
    Map<String, String>? attributes,
    int? counter,
    int? millisecond,
  }) async {
    Map<String, dynamic> args = {
      'eventId': eventId,
    };
    if (label != null) {
      args['label'] = label;
    }
    if (attributes != null) {
      args['attributes'] = attributes;
    }
    if (counter != null) {
      args['counter'] = counter;
    }
    if (millisecond != null) {
      args['millisecond'] = millisecond;
    }
    return methodChannel.invokeMethod(
      'logEvent',
      args,
    );
  }

  @override
  Future<void> beginEvent({
    required String eventId,
    String? label,
    String? primarykey,
    Map<String, String>? attributes,
  }) async {
    Map<String, dynamic> args = {
      'eventId': eventId,
    };
    if (label != null) {
      args['label'] = label;
    }
    if (attributes != null) {
      args['attributes'] = attributes;
    }
    if (primarykey != null) {
      args['primarykey'] = primarykey;
    }
    return methodChannel.invokeMethod(
      'beginEvent',
      args,
    );
  }

  @override
  Future<void> endEvent({
    required String eventId,
    String? label,
    String? primarykey,
  }) async {
    Map<String, dynamic> args = {
      'eventId': eventId,
    };
    if (label != null) {
      args['label'] = label;
    }
    if (primarykey != null) {
      args['primarykey'] = primarykey;
    }
    return methodChannel.invokeMethod(
      'endEvent',
      args,
    );
  }
}
