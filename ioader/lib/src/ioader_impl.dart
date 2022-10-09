/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:48:10
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 19:52:02
 * @FilePath: /ioader/lib/src/ioader_impl.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ioader/src/extension/extension.dart';
import 'package:ioader/src/http/ittp.dart';
import 'package:ioader/src/models/its.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'log/log.dart';
import 'models/iideo.dart';

class Ioader {
  late Future<bool> initialized;

  /// 基础路径
  String get dir => _dir;
  late String _dir;

  /// isar
  late final Isar _isar;

  /// 当前时间戳
  int get _millisecondsSinceEpoch => DateTime.now().millisecondsSinceEpoch;

  static Ioader? _instance;
  factory Ioader([String dir = 'ioader']) {
    _instance ??= Ioader._internal(dir);
    return _instance!;
  }

  Ioader._internal([String dir = 'ioader']) {
    _dir = dir;
    initialized = Future<bool>(() async {
      _isar = await Isar.open([IideoSchema]);
      if (!dir.contains('/')) {
        Directory directory;
        if (Platform.isMacOS || Platform.isWindows) {
          directory = (await getDownloadsDirectory())!;
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        _dir = '${directory.path}/$_dir';
        Iogger.d(_dir);
      }
      return true;
    });
  }

  /// 初始化
  static Future<bool> initialize([String dir = 'ioader']) {
    WidgetsFlutterBinding.ensureInitialized();
    return Ioader(dir).initialized;
  }

  /// 获取全部视频
  Future<List<Iideo>> getAllVideo({
    Sort sort = Sort.asc,
    int? limit,
    int? offset,
  }) async {
    QueryBuilder<Iideo, Iideo, QWhere> queryBuilder = _isar.iideos.where();
    if (limit != null && offset != null) {
      queryBuilder.offset(offset).limit(limit);
    }
    return queryBuilder.findAll();
  }

  /// 获取指定状态的视频
  Future<List<Iideo>> getVideos(
    IoaderStatus status, {
    int? limit,
    int? offset,
  }) async {
    QueryBuilder<Iideo, Iideo, QAfterFilterCondition> queryBuilder =
        _isar.iideos.filter().statusEqualTo(status);
    if (limit != null && offset != null) {
      queryBuilder.offset(offset).limit(limit);
    }
    return queryBuilder.findAll();
  }

  /// 获取指定id的视频
  Future<Iideo?> getVideoById(String id) async {
    return _isar.iideos.get(id.fastHash);
  }

  /// 获取指定ids的视频
  Future<List<Iideo?>> getAllVideoByIds(List<String> ids) async {
    return _isar.iideos.getAll(ids.map((e) => e.fastHash).toList());
  }

  /// 创建下载任务
  /// 已存在的任务不会二次写入
  Future<void> putVideo(
    String id, {
    required String videoUrl,
    required String coverUrl,
  }) async {
    if ((await getVideoById(id)) == null) {
      Directory directory = Directory('$dir/$id/');
      await directory.create(recursive: true);
      await _isar.writeTxn(() async {
        var iideo = Iideo(
          id: id,
          videoUrl: videoUrl,
          coverUrl: coverUrl,
          createdAt: _millisecondsSinceEpoch,
        );
        _isar.iideos.put(iideo);
        await IttpClient.image(coverUrl, '${directory.path}/${id}_cover');
        iideo.lastUpdateAt = _millisecondsSinceEpoch;
        await _isar.iideos.put(iideo);
        var result = await IttpClient.getSize(videoUrl);
        if (result is List) {
          iideo.total = result.length;
          iideo.its = result.cast<Its>();
        } else {
          iideo.total = result;
        }
        iideo.lastUpdateAt = _millisecondsSinceEpoch;
        await _isar.iideos.put(iideo);
      });
    }
  }

  /// 删除指定id的视频
  Future<void> removeVideoById(String id) async {
    if ((await getVideoById(id)) == null) {
      Iogger.d('`$id` 不存在');
      return;
    }
    final directory = Directory('$dir/$id/');
    bool isExists = await directory.exists();
    if (isExists) {
      await directory.delete(recursive: true);
      Iogger.d('`$id` 已删除');
    }
    await _isar.writeTxn(() async {
      _isar.iideos.delete(id.fastHash);
    });
  }

  /// 删除指定ids的视频
  Future<void> removeVideoByIds(List<String> ids) async {
    List<String> ls = [];
    for (var id in ids) {
      if ((await getVideoById(id)) != null) {
        ls.add(id);
        final directory = Directory('$dir/$id/');
        bool isExists = await directory.exists();
        if (isExists) {
          await directory.delete(recursive: true);
          Iogger.d('`$id` 已删除');
        } else {
          Iogger.d('`$id` 文件不存在');
        }
      } else {
        Iogger.d('`$id` 不存在');
      }
    }
    await _isar.writeTxn(() async {
      await _isar.iideos.deleteAll(ls.map((e) => e.fastHash).toList());
    });
  }

  /// 删除所有视频
  Future<void> clear() async {
    List<Iideo> list = await getAllVideo();
    for (var val in list) {
      final directory = Directory('$dir/${val.id}/');
      bool isExists = await directory.exists();
      if (isExists) {
        await directory.delete(recursive: true);
      }
    }
    await _isar.writeTxn(() async {
      await _isar.iideos.clear();
    });
  }

  /// 监听对象变化
  Stream<Iideo?> watchVideoById(String id, {bool fireImmediately = false}) {
    return _isar.iideos.watchObject(
      id.fastHash,
      fireImmediately: fireImmediately,
    );
  }

  /// 获取视频文件路径
  String getVideoDirById(String id) {
    return '$dir/$id/';
  }
}
