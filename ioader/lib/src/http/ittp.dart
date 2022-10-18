/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 16:32:23
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-18 19:24:50
 * @FilePath: /ioader/lib/src/http/ittp.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ioader/ioader.dart';
import 'package:ioader/src/models/i3u8.dart';
import 'package:ioader/src/models/is.dart';
import 'package:isar/isar.dart';

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
        List<String> link = RegExp(r'.*?.ts')
            .allMatches(response.data)
            .map<String>((e) => e.group(0)!)
            .toList();
        List<Is> iss = [];
        for (var i = 0; i < link.length; i++) {
          iss.add(Is(
            extinf: extinf[i],
            link: link[i],
          ));
        }
        String host;
        int index = url.split('/').indexOf(link.first.split('/').first);
        if (index == -1) {
          host = url.replaceFirst(url.split('/').last, '');
        } else {
          int start;
          if (link.first.startsWith('/')) {
            start = url.lastIndexOf(link.first.split('/')[1]);
          } else {
            start = url.lastIndexOf(link.first.split('/').first);
          }
          host = url.replaceFirst(url.substring(start), '');
        }
        String header = RegExp('#EXTM3U[\\s\\S]*?(${iss.first.extinf})')
            .firstMatch(response.data)!
            .group(0)!
            .replaceAll(iss.first.extinf, '');
        return {
          'i3u8': I3u8(
            host: host,
            header: header,
            iss: iss,
          ),
          'value': response.data,
        };
      }
    }
    return 0;
  }

  /// 开始下载
  static Future<void> download(
    Iideo iideo,
    String path,
    Isar isar,
  ) async {
    bool isExists = await Directory(path).exists();
    if (!isExists || iideo.status == IoaderStatus.paused) {
      return;
    }
    if (iideo.total == iideo.received) {
      if (iideo.status != IoaderStatus.completed) {
        iideo.status = IoaderStatus.completed;
      }
      iideo.lastUpdateAt = DateTime.now().millisecondsSinceEpoch;
      await isar.writeTxn(() async {
        await isar.iideos.put(iideo);
      });
      return;
    }
    if (iideo.i3u8 != null) {
      // 当前资源为m3u8
      I3u8 i3u8 = iideo.i3u8!;
      if (iideo.status == IoaderStatus.pending) {
        iideo.status = IoaderStatus.inProgress;
      }
      Is val = i3u8.iss![iideo.received!];
      String url = '${i3u8.host!}/${val.link}'.replaceAll('///', '/');
      Response response = await Dio().download(
        url,
        '$path${iideo.received}.ts',
      );
      if (response.statusCode == HttpStatus.ok) {
        File ffile = File('$path${iideo.id}_index.m3u8');
        bool isExists = await ffile.exists();
        if (isExists) {
          String index = await ffile.readAsString();
          await ffile.writeAsString(
            index.replaceAll(
              i3u8.end!,
              '${val.extinf}\n${iideo.received}.ts\n${i3u8.end}',
            ),
          );
          iideo.received = iideo.received! + 1;
          iideo.lastUpdateAt = DateTime.now().millisecondsSinceEpoch;
          await isar.writeTxn(() async {
            await isar.iideos.put(iideo);
          });
        }
      }
    }
    await download(iideo, path, isar);
  }
}
