/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-14 15:24:35
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-14 15:34:45
 * @FilePath: /iepub/lib/src/extension/epubchapter.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:iepub/src/model/epubchapter.dart';

extension EpubchapterExtension on EpubChapter {
  String get dir => href.replaceFirst(href.split('/').last, '');
}
