/*
 * @Author: iptoday 
 * @Date: 2022-03-09 20:44:31 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-04-23 16:42:39
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IScaffold extends StatelessWidget {
  const IScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.systemUiOverlayStyle,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
  }) : super(key: key);

  final Widget body;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final PreferredSizeWidget? appBar;

  final bool? resizeToAvoidBottomInset;

  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle.dark;
    if (systemUiOverlayStyle != null) {
      style = systemUiOverlayStyle!;
    } else {
      style = Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: Scaffold(
        body: body,
        appBar: appBar,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
      value: style,
    );
  }
}
