/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:48:10
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-09-29 00:37:40
 * @FilePath: /ioader/lib/src/ioader_impl.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Ioader {
  late Future<bool> initialized;

  /// 基础路径
  String get dir => _dir;
  late String _dir;

  static Ioader? _instance;
  factory Ioader([String dir = 'Ioader']) {
    _instance ??= Ioader._internal(dir);
    return _instance!;
  }

  Ioader._internal([String dir = 'Ioader']) {
    _dir = dir;
    initialized = Future<bool>(() async {
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
}
