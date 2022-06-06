/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-04-29 22:24:56
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-06-06 15:09:16
 * @FilePath: /widgets/example/lib/main.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved. 
 */
import 'package:flutter/material.dart';
import 'package:iwidgets/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Demo(),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DemoState();
}

class DemoState extends IState<Demo> {
  @override
  bool get executeLoadData => true;

  @override
  Widget ibuild(BuildContext context) {
    return IScaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(''),
      ),
    );
  }

  @override
  Future<void> loadData() async {}
}
