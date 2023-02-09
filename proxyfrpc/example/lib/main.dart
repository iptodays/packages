// ignore_for_file: avoid_print

/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2023-02-09 21:29:29
 * @FilePath: /proxyfrpc/example/lib/main.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:proxyfrpc/proxyfrpc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                '启动Socks5',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Proxyfrpc.instance.startSocks5(
                  port: 6000,
                  listen: (connection) {
                    print(
                      '${connection.address.address}:${connection.port} ==> ${connection.desiredAddress.address}:${connection.desiredPort}',
                    );
                  },
                );
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                '关闭Socks5',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Proxyfrpc.instance.stopSocks5();
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                '启动frpc',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                String cfg = '''
[common]
server_addr = xxx.xx.xx.xx
server_port = xxxx
token = xxxxx
login_fail_exit = false

[Proxyfrpc]
type = tcp
local_ip = 127.0.0.1
local_port = xxxx
remote_port = xxxx
''';
                Directory supportDir = await getApplicationSupportDirectory();
                File file = File('${supportDir.path}/frpc.ini');
                file.createSync(recursive: true);
                file.writeAsStringSync(cfg);
                Proxyfrpc.instance.startFRPC(
                  uid: 'test1',
                  cfgFilePath: file.path,
                );
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                '关闭frpc',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Proxyfrpc.instance.stopFRPC(uid: 'test1');
              },
            ),
          ],
        ),
      ),
    );
  }
}
