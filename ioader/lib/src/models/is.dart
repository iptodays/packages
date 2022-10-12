/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 19:14:07
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-11 15:28:50
 * @FilePath: /ioader/lib/src/models/is.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

import 'package:isar/isar.dart';

part 'is.g.dart';

@embedded
class Is {
  /// EXTINF/片段时长
  late String extinf;

  /// 链接
  late String link;

  Is({
    this.extinf = '',
    this.link = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'extinf': extinf,
      'link': link,
    };
  }
}
