/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-06-05 23:30:29
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-06-06 15:08:12
 * @FilePath: /widgets/lib/button.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class IButton extends StatelessWidget {
  const IButton({
    Key? key,
    this.onTap,
    this.feedbackType,
    required this.child,
  }) : super(key: key);

  /// 震动反馈类型
  final FeedbackType? feedbackType;

  /// 点击事件
  final Function? onTap;

  /// 按钮显示内容
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          if (feedbackType != null) {
            Vibrate.feedback(feedbackType!);
          }
          onTap!();
        }
      },
      child: child,
    );
  }
}
