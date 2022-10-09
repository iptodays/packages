/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 15:00:52
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 21:39:19
 * @FilePath: /ioader/lib/src/log/log.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Iogger {
  /// debug模式下输出
  Iogger.d(Object object) {
    if (kDebugMode) {
      developer.log(
        object.toString(),
        name: 'Ioader - ${DateTime.now()}',
      );
    }
  }
}
