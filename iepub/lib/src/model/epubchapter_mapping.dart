/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 22:50:45
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 23:06:06
 * @FilePath: /iepub/lib/src/model/epubchapter_mapping.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

import 'package:isar/isar.dart';

part 'epubchapter_mapping.g.dart';

@embedded
class EpubChapterMapping {
  /// id
  late int id;

  /// 原始文件路径
  late String href;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'href': href,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
