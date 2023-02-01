/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-01 14:01:39
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2023-02-01 14:12:34
 * @FilePath: /imobile_ads/lib/src/enum.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
/// admob 开屏
enum IAdmobAppOpenAdState {
  loaded,
  loadFailed,
  showed,
  showFailed,
  willDismiss,
  dismissed,
}

/// admob banner
enum IAdmobBannerAdState {
  loaded,
  loadFailed,
  opened,
  closed,
  willDismiss,
}

/// admob 全屏
enum IAdmobFullScreenAdState {
  loaded,
  loadFailed,
  showed,
  showFailed,
  willDismiss,
  dismissed,
}

/// admob 激励
enum IAdmobRewardedAdState {
  loaded,
  loadFailed,
  showed,
  showFailed,
  earnedReward,
  willDismiss,
  dismissed,
}

/// unity banner
enum IUnityBannerAdState {
  loaded,
  loadFailed,
}

/// unity 视频
enum IUnityVideoAdState {
  start,
  loadFailed,
  showFailed,
  skipped,
  complete,
}
