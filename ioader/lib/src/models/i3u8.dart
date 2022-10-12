/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-11 14:46:16
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-11 15:28:23
 * @FilePath: /ioader/lib/src/models/i3u8.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:isar/isar.dart';

import 'is.dart';

part 'i3u8.g.dart';

@embedded
class I3u8 {
  /// 基础地址
  String? host;

  /// m3u8片段
  List<Is>? iss;

  /// 文件头
  String? header;

  /// 文件尾
  String? end;

  I3u8({
    this.host,
    this.header,
    this.end = '#EXT-X-ENDLIST',
    this.iss,
  });

  Map<String, dynamic> toJson() {
    return {
      'header': header,
      'end': end,
      'host': host,
      'iss': iss?.map((e) => e.toJson()).toList(),
    };
  }
}
