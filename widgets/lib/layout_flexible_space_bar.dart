/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-04-29 22:24:56
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-06-05 23:06:45
 * @FilePath: /widgets/lib/layout_flexible_space_bar.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */

import 'package:flutter/material.dart';

class LayoutFlexibleSpaceBar extends StatefulWidget {
  const LayoutFlexibleSpaceBar({
    Key? key,
    this.controller,
    required this.background,
    this.collapsedHeight = kToolbarHeight,
    this.title,
  }) : super(key: key);

  final LayoutFlexibleSpaceBarController? controller;

  final Widget background;

  final Widget? title;

  /// 闭合高度
  final double collapsedHeight;

  @override
  State<StatefulWidget> createState() => _LayoutFlexibleSpaceBarState();
}

class _LayoutFlexibleSpaceBarState extends State<LayoutFlexibleSpaceBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.controller != null) {
          double value =
              (widget.collapsedHeight + MediaQuery.of(context).padding.top) /
                  constraints.biggest.height;
          if (widget.controller!._initOffset == -1) {
            widget.controller!.setInitOffset(value);
          }
          widget.controller!.setValue(
            value,
          );
        }
        return FlexibleSpaceBar(
          title: widget.title,
          background: widget.background,
        );
      },
    );
  }
}

class LayoutFlexibleSpaceBarController extends ChangeNotifier {
  LayoutFlexibleSpaceBarController();

  /// 不透明度
  double _opacity = 0;
  double get opacity => _opacity;

  /// 记录是否闭合
  bool _isCollapsed = false;

  /// 是否完全隐藏
  void Function(bool)? callback;

  /// 初始偏移量
  double _initOffset = -1;

  void setInitOffset(double offset) {
    _initOffset = offset;
  }

  void setValue(double value) {
    if (value > _initOffset) {
      _opacity = value;
    } else {
      _opacity = value - _initOffset;
    }
    notifyListeners();
    if (callback != null) {
      if (_isCollapsed && opacity < 1) {
        _isCollapsed = false;
        callback!(_isCollapsed);
      } else if (!_isCollapsed && opacity >= 1) {
        _isCollapsed = true;
        callback!(_isCollapsed);
      }
    }
  }
}
