/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 13:52:37
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-14 10:58:01
 * @FilePath: /iepub/lib/src/log/log.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Iogger {
  /// debug模式下输出
  Iogger.d(Object? object) {
    if (kDebugMode) {
      developer.log(
        object.toString(),
        name: 'Iepub - ${DateTime.now()}',
      );
    }
  }
}
