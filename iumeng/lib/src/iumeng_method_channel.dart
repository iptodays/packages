/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-05-25 20:54:09
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-05-26 16:12:40
 * @FilePath: /iumeng/lib/src/iumeng_method_channel.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'iumeng_platform_interface.dart';

/// An implementation of [IumengPlatform] that uses method channels.
class MethodChannelIumeng extends IumengPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('iumeng');

  @override
  Future<void> initialize({
    required String appKey,
    required String channel,
    required bool logEnabled,
  }) async {
    return methodChannel.invokeMethod(
      'initialize',
      {
        'appKey': appKey,
        'channel': channel,
        'logEnabled': logEnabled,
      },
    );
  }

  @override
  Future<void> requestPermission({
    required bool alert,
    required bool badge,
    required bool sound,
  }) async {
    return methodChannel.invokeMethod(
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
