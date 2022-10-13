/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 21:46:30
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 23:05:21
 * @FilePath: /iepub/lib/src/model/epubchapte.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

import 'package:isar/isar.dart';

part 'epubchapte.g.dart';

@embedded
class EpubChapter {
  /// 章节id
  late int id;

  /// 章节名称
  late String title;

  /// 解析后内容
  String? content;

  /// 原始内容
  String? originalContent;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'originalContent': originalContent,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
