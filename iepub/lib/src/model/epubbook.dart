/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 17:09:15
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 22:57:10
 * @FilePath: /iepub/lib/src/model/epubbook.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

import 'package:iepub/src/extension/string.dart';
import 'package:isar/isar.dart';

import 'epubchapte.dart';
import 'epubchapter_mapping.dart';

part 'epubbook.g.dart';

@collection
class EpubBook {
  /// 视频唯一id
  late final String id;
  Id get isarId => id.fastHash;

  /// 所有章节
  late final List<EpubChapter> chapters;

  /// 章节目录与原始文件路径映射
  late final List<EpubChapterMapping> mapping;

  EpubBook({
    required this.id,
    required this.chapters,
    required this.mapping,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'mapping': mapping.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
