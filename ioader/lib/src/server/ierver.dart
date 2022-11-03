/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-23 21:24:04
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-11-03 22:26:34
 * @FilePath: /ioader/lib/src/server/ierver.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:ioader/src/log/log.dart';
import 'package:r_get_ip/r_get_ip.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class Ierver {
  static Ierver get instance => Ierver._instanceFor();
  static Ierver? _instance;
  factory Ierver._instanceFor() => _instance ??= Ierver._();
  Ierver._();

  String? get domain => _domain;
  String? _domain;

  bool get runing => _runing;
  bool _runing = false;
  HttpServer? server;

  Future<String> start({
    int port = 0000,
    bool localhost = true,
  }) async {
    if (_runing) {
      return domain!;
    }
    String? ip = localhost ? 'localhost' : await RGetIp.internalIP;
    var handler = const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addHandler(echoRequest);
    server = await shelf_io.serve(handler, ip ??= 'localhost', port);
    server!.autoCompress = true;
    _domain = 'http://${server!.address.host}:${server!.port}';
    Iogger.d('Serving at $domain');
    _runing = true;
    return domain!;
  }

  Future<void> stop({bool force = false}) async {
    if (runing) {
      await server?.close(force: force);
    }
  }

  FutureOr<Response> echoRequest(Request request) async {
    return Response.ok(File(request.url.path).readAsBytesSync());
  }
}
