/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-06-10 15:38:17
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-06-10 15:41:54
 * @FilePath: /iapi/lib/src/api.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */

import 'dart:io';

export 'package:dio/dio.dart';

class Api {
  factory Api() => _sharedInstance();
  Api._() {
    String os;
    String deviceInfo = '';
    if (Platform.isAndroid) {
      deviceInfo =
          'android/${AppConfig.instance.android!.brand}/${AppConfig.instance.android!.model}/${AppConfig.instance.android!.version.release}';
      os = 'android';
    } else {
      os = 'ios';
      deviceInfo =
          'iOS/${AppConfig.instance.ios!.utsname.machine}/${AppConfig.instance.ios!.systemVersion}';
    }
    _options = BaseOptions(
      baseUrl: 'https://api.followerinsight.com',
      connectTimeout: 60000,
      receiveTimeout: 60000,
      contentType: 'text/plain',
      responseType: ResponseType.plain,
      method: 'POST',
      headers: <String, dynamic>{
        'x-app-os': os,
        'x-app-locale': AppConfig.instance.locale,
        'x-app-deviceInfo': deviceInfo,
        'x-app-timezone': AppConfig.instance.timeZone,
      },
    );

    _dio = Dio(_options);

    //添加拦截器
    _dio.interceptors.addAll(<Interceptor>[
      ApiInterceptors(),
    ]);
  }

  // 静态私有成员, 没有初始化
  static Api? _instance;
  // 私有dio对象, 没有初始化
  static late final Dio _dio;
  // 私有dio配置参数, 没有初始化
  static late final BaseOptions _options;

  // 静态、同步、私有访问点
  static Api _sharedInstance() {
    if (ObjectUtil.isEmpty(_instance)) {
      _instance = Api._();
    }
    return _instance!;
  }
}
