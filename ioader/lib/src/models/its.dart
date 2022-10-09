/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 19:14:07
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 19:37:07
 * @FilePath: /ioader/lib/src/models/its.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

import 'package:isar/isar.dart';

part 'its.g.dart';

@embedded
class Its {
  /// EXTINF/片段时长
  late String extinf;

  /// 链接
  late String link;

  /// 是否已完成
  late bool completed;

  Its({
    this.extinf = '',
    this.link = '',
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'extinf': extinf,
      'link': link,
      'completed': completed,
    };
  }
}
