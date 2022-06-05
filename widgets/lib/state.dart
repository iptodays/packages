/*
 * @Author: iptoday 
 * @Date: 2022-04-22 12:45:30 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-04-29 22:42:40
 */
import 'package:flutter/material.dart';
export 'package:iwidgets/scaffold.dart';

abstract class IState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  /// 初始化时是否执行loadData
  bool get executeLoadData => true;

  @override
  void initState() {
    if (executeLoadData) {
      loadData();
    }

    super.initState();
  }

  @protected
  Widget ibuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ibuild(context);
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  /// 载入数据
  Future<void> loadData() async {}

  @override
  bool get wantKeepAlive => true;
}
