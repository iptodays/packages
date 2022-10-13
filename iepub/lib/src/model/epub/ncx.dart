/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 16:22:21
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 21:40:33
 * @FilePath: /iepub/lib/src/model/ncx.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';


class Ncx {
  /// class
  String? cls;

  /// id
  String? id;

  /// 文件路径
  String? src;

  /// playOrder
  String? playOrder;

  /// 章节名称
  String? title;

  Map<String, dynamic> toJson() {
    return {
      'cls': cls,
      'id': id,
      'src': src,
      'playOrder': playOrder,
      'title': title,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
