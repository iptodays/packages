/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:49:02
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-06 10:24:04
 * @FilePath: /ioader/lib/src/models/video.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */

import 'package:ioader/src/extension/extension.dart';
import 'package:isar/isar.dart';

part 'video.g.dart';

enum IoaderStatus {
  pending, // 等待
  inProgress, // 下载中
  paused, // 已暂停
  canceled, // 已取消
  deleted, // 文件已删除
  completed, // 已完成
}

@collection
class Video {
  /// 视频唯一id
  late final String id;
  Id get isarId => id.fastHash;

  /// 视频原始url
  late final String videoUrl;

  /// 封面原始url
  late final String coverUrl;

  /// 文件状态
  @enumerated
  IoaderStatus status = IoaderStatus.pending;

  /// 文件总大小
  int total = 0;

  /// 已获取文件大小
  int received = 0;

  /// 创建时间/ms
  late final int createdAt;

  /// 最后更新时间/ms
  late final int lastUpdateAt;
}
