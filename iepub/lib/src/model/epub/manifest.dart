/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 15:50:15
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 21:40:57
 * @FilePath: /iepub/lib/src/model/manifest.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

import 'package:isar/isar.dart';

@embedded
class Manifest {
  /// id
  String? id;

  /// 章节路径
  String? href;

  /// 资源类型
  String? mediaType;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'href': href,
      'mediaType': mediaType,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
