/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:48:10
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-06 10:51:35
 * @FilePath: /ioader/lib/src/ioader_impl.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ioader/src/extension/extension.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/video.dart';

class Ioader {
  late Future<bool> initialized;

  /// 基础路径
  String get dir => _dir;
  late String _dir;

  /// isar
  Isar get isar => _isar;
  late final Isar _isar;

  static Ioader? _instance;
  factory Ioader([String dir = 'Ioader']) {
    _instance ??= Ioader._internal(dir);
    return _instance!;
  }

  Ioader._internal([String dir = 'Ioader']) {
    _dir = dir;
    initialized = Future<bool>(() async {
      _isar = await Isar.open([VideoSchema]);
      if (!dir.contains('/')) {
        Directory directory;
        if (Platform.isMacOS || Platform.isWindows) {
          directory = (await getDownloadsDirectory())!;
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        _dir += '/${directory.path}';
      }
      return true;
    });
  }

  /// 初始化
  static Future<bool> initialize([String dir = 'Ioader']) {
    WidgetsFlutterBinding.ensureInitialized();
    return Ioader(dir).initialized;
  }

  /// 获取全部视频
  Future<List<Video>> getAllVideo({
    Sort sort = Sort.asc,
    int? limit,
    int? offset,
  }) async {
    QueryBuilder<Video, Video, QWhere> queryBuilder = isar.videos.where();
    if (limit != null && offset != null) {
      queryBuilder.offset(offset).limit(limit);
    }
    return queryBuilder.findAll();
  }

  /// 获取指定状态的视频
  Future<List<Video>> getVideos(
    IoaderStatus status, {
    int? limit,
    int? offset,
  }) async {
    QueryBuilder<Video, Video, QAfterFilterCondition> queryBuilder =
        isar.videos.filter().statusEqualTo(status);
    if (limit != null && offset != null) {
      queryBuilder.offset(offset).limit(limit);
    }
    return queryBuilder.findAll();
  }

  /// 获取指定id的视频
  Future<Video?> getVideoById(String id) async {
    return isar.videos.get(id.fastHash);
  }

  /// 获取指定ids的视频
  Future<List<Video?>> getAllVideoByIds(List<String> ids) async {
    return isar.videos.getAll(ids.map((e) => e.fastHash).toList());
  }

  /// 创建下载任务
  /// 已存在的任务不会二次写入
  Future<void> putVideo(Video video) async {
    if ((await getVideoById(video.id)) == null) {}
  }

  /// 获取视频文件路径
  String getVideoDirById(String id) {
    return '$dir/$id/';
  }
}
