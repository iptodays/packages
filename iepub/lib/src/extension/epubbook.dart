/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-14 15:11:42
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-14 15:32:43
 * @FilePath: /iepub/lib/src/extension/epubbook.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:iepub/iepub.dart';
import 'package:iepub/src/parse/xml.dart';

extension EpubBookExtension on EpubBook {
  /// 当前文件所在路径
  String get dir => '${Iepub.instance.dir}/$id';

  /// 载入章节
  /// @[start]: 开始下标
  /// @[end]: 结束下标
  Future<void> loadChapter({int start = 0, end = 5}) async {
    assert(
      start >= 0 && start < end && end <= this.chapters.length,
      '下标错误',
    );
    var chapters = this.chapters.getRange(start, end);
    for (var chapter in chapters) {
      if (chapter.content == null) {
        String path =
            '${Iepub.instance.dir}/$id/${chapter.href.split('#').first}';
        var ixml = IXml(path);
        var result = await ixml.parseHtml();
        chapters.singleWhere((element) => element.id == chapter.id).content =
            result['innerText'];
        chapters
            .singleWhere((element) => element.id == chapter.id)
            .originalContent = result['html'];
        await Iepub.instance.isar.writeTxn(() async {
          await Iepub.instance.isar.epubBooks.put(this);
        });
      }
    }
  }
}
