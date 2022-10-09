/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 15:00:52
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 19:02:06
 * @FilePath: /ioader/lib/src/log/log.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter/foundation.dart';

class Iogger {
  /// debug模式下输出
  Iogger.d(Object object) {
    if (kDebugMode) {
      print('Ioader: ${DateTime.now()}: ${object.toString()}');
    }
  }
}
