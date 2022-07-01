/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-05-25 20:54:09
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-07-01 15:11:46
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
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel = const MethodChannel('iumeng')
    ..setMethodCallHandler(_setMethodCallHandler);

  /// 由原生调用flutter的处理
  Future<dynamic> _setMethodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'registerRemoteNotifications':
        if (registerRemoteNotificationsCallback != null) {
          registerRemoteNotificationsCallback!(
            call.arguments['result'],
            call.arguments['error'],
          );
        }
        break;
      case 'deviceToken':
        if (deviceTokenCallback != null) {
          deviceTokenCallback!(call.arguments['deviceToken']);
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
    required bool logEnabled,
  }) async {
    assert(
      Platform.isAndroid && messageSecret == null,
      'messageSecret not found',
    );
    Map args = {
      'appKey': appKey,
      'channel': channel,
      'logEnabled': logEnabled,
    };
    if (Platform.isAndroid) {
      args['messageSecret'] = messageSecret;
    }
    return methodChannel.invokeMethod('initialize', args);
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

  @override
  Future<void> badgeClear() async {
    return methodChannel.invokeMethod('badgeClear');
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
