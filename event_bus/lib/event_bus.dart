/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-05-24 13:15:47
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-05-24 17:12:24
 * @FilePath: /packages/event_bus/lib/event_bus.dart
 *
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

library event_bus;

typedef EventCallback = void Function(dynamic arg);

class EventBus {
  factory EventBus() => _getInstance();
  static EventBus get instance => _getInstance();
  static EventBus? _instance;

  EventBus._internal() {
    // init
  }
  static EventBus _getInstance() {
    _instance ??= EventBus._internal();
    return _instance!;
  }

  final Map<String, List<EventCallback>?> _events = {};

  /// 添加监听
  void addListener({
    required String eventKey,
    required EventCallback callback,
  }) {
    if (_events[eventKey] != null) {
      _events[eventKey] = [..._events[eventKey]!, callback];
    } else {
      _events[eventKey] = [callback];
    }
  }

  /// 移除监听
  void removeListener(String eventKey) {
    if (_events[eventKey]?.isNotEmpty == true) {
      List<EventCallback> list = _events[eventKey]!;
      list.removeLast();
      _events[eventKey] = [...list];
    }
  }

  /// 发送事件
  void commit({required String eventKey, dynamic arg}) {
    List<EventCallback>? callbacks = _events[eventKey];
    if (callbacks != null) {
      for (var element in callbacks) {
        element(arg);
      }
    }
  }
}
