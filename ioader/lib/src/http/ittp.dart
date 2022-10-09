/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 16:32:23
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 19:53:22
 * @FilePath: /ioader/lib/src/http/ittp.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:io';

import 'package:dio/dio.dart';

import '../models/its.dart';

class IttpClient {
  IttpClient._();

  /// 图片下载
  static Future<Response> image(String url, String path) async {
    return Dio().download(url, path);
  }

  /// 获取文件大小
  static Future<dynamic> getSize(String url) async {
    if (url.endsWith('.m3u8')) {
      Response response = await Dio().request(url);
      if (response.statusCode == HttpStatus.ok && response.data is String) {
        if (response.data.contains('.m3u8')) {
          String realM3u8 =
              RegExp(r'/.*?.m3u8').stringMatch(response.data) ?? '';
          String reg = '/${realM3u8.split('/')[1]}.*?.m3u8';
          String realUrl = url.replaceAll(RegExp(reg), realM3u8);
          return getSize(realUrl);
        }
        List<String> extinf = RegExp(r'#EXTINF:(\d+(\.\d{1,})|[1-9]\d*),')
            .allMatches(response.data)
            .map<String>((e) => e.group(0)!)
            .toList();
        List<String> link = RegExp(r'/.*?.ts')
            .allMatches(response.data)
            .map<String>((e) => e.group(0)!)
            .toList();
        List<Its> its = [];
        for (var i = 0; i < link.length; i++) {
          its.add(Its(
            extinf: extinf[i],
            link: link[i],
            completed: false,
          ));
        }
        return its;
      }
    }
    return 0;
  }
}
