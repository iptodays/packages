/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-12 19:15:15
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-14 15:31:25
 * @FilePath: /iepub/lib/src/iepub_impl.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:iepub/iepub.dart';
import 'package:iepub/src/extension/string.dart';
import 'package:iepub/src/log/log.dart';
import 'package:iepub/src/zip/zip.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'parse/xml.dart';

class Iepub {
  bool initialized = false;

  /// 基础路径
  String get dir => _dir;
  late final String _dir;

  /// database
  Isar get isar => _isar;
  late final Isar _isar;

  static Iepub get instance => Iepub._instanceFor();
  static Iepub? _instance;
  factory Iepub._instanceFor() => _instance ??= Iepub._();
  Iepub._();

  /// 初始化
  Future<bool> initialize([String dir = 'iepub']) async {
    if (!initialized) {
      WidgetsFlutterBinding.ensureInitialized();
      if (dir == 'iepub') {
        Directory directory;
        if (Platform.isMacOS || Platform.isWindows) {
          directory = (await getDownloadsDirectory())!;
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        _dir = '${directory.path}/$dir';
      } else {
        _dir = dir;
      }
      Directory directory = Directory(_dir);
      bool isExists = await directory.exists();
      if (!isExists) {
        await directory.create(recursive: true);
      }
      _isar = await Isar.open(
        [EpubBookSchema],
        directory: _dir,
        name: 'iepub',
      );
      initialized = true;
    }
    Iogger.d('基础路径: $_dir');
    return initialized;
  }

  /// 获取epub对象
  Future<EpubBook?> parse(
    String id, {
    required List<int> data,
    bool verify = false,
    String? password,
  }) async {
    EpubBook? epubBook = await _isar.epubBooks.get(id.fastHash);
    if (epubBook != null) {
      Iogger.d('`$id` 本地存在');
      return epubBook;
    }
    String outDir = '$dir/$id';
    await IZip.decoder(data, outDir, verify: verify, password: password);
    IXml iXml = IXml(outDir);
    Map val = await iXml.parseEpub();
    epubBook = EpubBook(
      id: id,
      chapters: val['chapters'],
    );
    await _isar.writeTxn(() async {
      _isar.epubBooks.put(epubBook!);
    });
    Iogger.d('`$id` 已载入成功');
    return epubBook;
  }

  /// 删除本地epub数据
  Future<void> removeEpubById(String id) async {
    assert(available(id), '`$id` 不存在');
    Directory directory = Directory('$dir/$id');
    bool isExists = await directory.exists();
    if (isExists) {
      directory.delete(recursive: true);
    }
    await _isar.writeTxn(() async {
      _isar.epubBooks.delete(id.fastHash);
    });
    Iogger.d('`$id` 已删除');
  }

  /// 当前id是否可用
  bool available(String id) {
    return _isar.epubBooks.getSync(id.fastHash) != null;
  }
}
