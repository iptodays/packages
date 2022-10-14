/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 17:09:15
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-14 15:31:10
 * @FilePath: /iepub/lib/src/model/epubbook.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

import 'package:iepub/src/extension/string.dart';
import 'package:isar/isar.dart';

import 'epubchapter.dart';

part 'epubbook.g.dart';

@collection
class EpubBook {
  /// 视频唯一id
  late final String id;
  Id get isarId => id.fastHash;

  /// 所有章节
  late final List<EpubChapter> chapters;

  EpubBook({
    required this.id,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
