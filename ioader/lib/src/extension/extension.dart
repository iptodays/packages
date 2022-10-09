/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-06 10:22:49
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 19:04:57
 * @FilePath: /ioader/lib/src/extension/extension.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

extension StringExtension on String {
  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  int get fastHash {
    var hash = 0xcbf29ce484222325;
    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }
    return hash;
  }

  /// 基础地址
  String get host {
    return '';
  }

  /// 获取ts的下载地址
  String get tsUrl {
    return '';
  }
}
