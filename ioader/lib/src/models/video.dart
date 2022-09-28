/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:49:02
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-09-28 23:04:09
 * @FilePath: /ioader/lib/src/models/video.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */

enum VideoStatus {
  pending, // 等待
  inProgress, // 下载中
  paused, // 已暂停
  canceled, // 已取消
  deleted, // 文件已删除
  completed, // 已完成
}

class VideoModel {
  /// 视频唯一id
  late final String id;

  /// 视频原始url
  late final String videoUrl;

  /// 封面原始url
  late final String coverUrl;

  /// 视频文件状态
  late final VideoStatus status;

  /// 创建时间/ms
  late final int createdAt;

  /// 最后更新时间/ms
  late final int lastUpdateAt;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.coverUrl,
    this.status = VideoStatus.pending,
    required this.createdAt,
    required this.lastUpdateAt,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoUrl = json['videoUrl'];
    coverUrl = json['coverUrl'];
    status = VideoStatus.values[json['status']];
    if (json['createdAt'] == null) {
      createdAt = DateTime.now().millisecondsSinceEpoch;
    } else {
      createdAt = json['createdAt'];
    }
    if (json['lastUpdateAt'] == null) {
      lastUpdateAt = DateTime.now().millisecondsSinceEpoch;
    } else {
      lastUpdateAt = json['lastUpdateAt'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'status': VideoStatus.values.indexOf(status),
      'createdAt': createdAt,
      'lastUpdateAt': lastUpdateAt,
    };
  }
}
