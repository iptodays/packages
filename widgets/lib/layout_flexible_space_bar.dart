/*
 * @Author: iptoday 
 * @Date: 2022-04-18 14:26:40 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-04-29 22:42:43
 */
import 'package:flutter/material.dart';
import 'package:widgets/state.dart';

class LayoutFlexibleSpaceBar extends StatefulWidget {
  const LayoutFlexibleSpaceBar({
    Key? key,
    this.controller,
    required this.background,
  }) : super(key: key);

  final LayoutFlexibleSpaceBarController? controller;

  final Widget background;

  @override
  State<StatefulWidget> createState() => _LayoutFlexibleSpaceBarState();
}

class _LayoutFlexibleSpaceBarState extends CustomState<LayoutFlexibleSpaceBar> {
  @override
  Widget customBuild(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.controller != null) {
          double value = (kToolbarHeight + MediaQuery.of(context).padding.top) /
              constraints.biggest.height;
          if (widget.controller!._initOffset == -1) {
            widget.controller!.setInitOffset(value);
          }
          widget.controller!.setValue(
            value,
          );
        }
        return FlexibleSpaceBar(
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
      callback!(opacity >= 0.8);
    }
  }
}
