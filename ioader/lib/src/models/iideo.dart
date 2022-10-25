/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:49:02
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-25 10:38:08
 * @FilePath: /ioader/lib/src/models/iideo.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */

import 'package:ioader/src/extension/extension.dart';
import 'package:isar/isar.dart';

import 'i3u8.dart';
import 'is.dart';

part 'iideo.g.dart';

enum IoaderStatus {
  pending, // 等待
  inProgress, // 下载中
  paused, // 已暂停
  canceled, // 已取消
  deleted, // 文件已删除
  completed, // 已完成
}

@collection
class Iideo {
  /// 视频唯一id
  late final String id;
  Id get isarId => id.fastHash;

  /// 视频原始url
  late final String videoUrl;

  /// 名称
  String? name;

  /// 封面原始url
  String? coverUrl;

  /// 文件状态
  @enumerated
  IoaderStatus status = IoaderStatus.pending;

  /// m3u8信息
  I3u8? i3u8;

  /// 文件总大小
  int? total;

  /// 已获取文件大小
  int? received;

  /// 创建时间/ms
  late final int createdAt;

  /// 最后更新时间/ms
  int? lastUpdateAt;

  Iideo({
    required this.id,
    required this.videoUrl,
    this.coverUrl,
    this.name,
    required this.createdAt,
    this.status = IoaderStatus.pending,
    this.i3u8,
    this.total,
    this.received,
    this.lastUpdateAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'name': name,
      'createdAt': createdAt,
      'status': status,
      'total': total,
      'i3u8': i3u8?.toJson(),
      'received': received,
      'lastUpdateAt': lastUpdateAt,
    };
  }
}
