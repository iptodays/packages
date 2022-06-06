/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-05-24 13:15:47
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-06-06 10:43:40
 * @FilePath: /event_bus/lib/event_bus.dart
 *
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

library event_bus;

typedef EventCallback = void Function(dynamic args);

class IEventBus {
  factory IEventBus() => _getInstance();
  static IEventBus get instance => _getInstance();
  static IEventBus? _instance;

  IEventBus._internal() {
    // init
  }
  static IEventBus _getInstance() {
    _instance ??= IEventBus._internal();
    return _instance!;
  }

  final Map<String, List<EventCallback>?> _events = {};

  /// 添加监听
  void addListener({
    required String key,
    required EventCallback callback,
  }) {
    if (_events[key] != null) {
      _events[key] = [..._events[key]!, callback];
    } else {
      _events[key] = [callback];
    }
  }

  /// 移除监听
  void removeListener(String key) {
    if (_events[key]?.isNotEmpty == true) {
      List<EventCallback> list = _events[key]!;
      list.removeLast();
      _events[key] = [...list];
    }
  }

  /// 发送事件
  void commit({required String key, dynamic arg}) {
    List<EventCallback>? callbacks = _events[key];
    if (callbacks != null) {
      for (var element in callbacks) {
        element(arg);
      }
    }
  }
}
