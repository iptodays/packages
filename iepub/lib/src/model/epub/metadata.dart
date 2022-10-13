/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 15:15:04
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 21:43:37
 * @FilePath: /iepub/lib/src/model/metadata.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:convert';

class Metadata {
  /// 作者
  String? creator;

  /// 语言
  String? language;

  /// 出版商
  String? publisher;

  /// 版权
  String? rights;

  /// 书名
  String? title;

  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'language': language,
      'publisher': publisher,
      'rights': rights,
      'title': title,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
