/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2023-02-09 21:17:03
 * @FilePath: /proxyfrpc/lib/proxyfrpc.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:socks5_proxy/socks.dart';

import 'proxyfrpc_platform_interface.dart';

class Proxyfrpc {
  static Proxyfrpc get instance => Proxyfrpc._instanceFor();
  static Proxyfrpc? _instance;
  factory Proxyfrpc._instanceFor() => _instance ??= Proxyfrpc._();
  Proxyfrpc._();

  StreamSubscription<Connection>? _subscription;
  SocksServer? _server;

  /// 启动socks5服务
  Future<void> startSocks5({
    required int port,
    InternetAddress? address,
    bool allowIPv6 = false,
    bool Function(String username, String password)? authHandler,
    void Function(Connection connection)? listen,
  }) async {
    if (_server != null && _server!.proxies.containsKey(port)) {
      return;
    }
    _server = SocksServer(authHandler: authHandler);
    _subscription = _server!.connections.listen(
      (connection) async {
        if (listen != null) {
          listen(connection);
        }
        await connection.forward(allowIPv6: allowIPv6);
      },
    );
    unawaited(_server!.bind(address ?? InternetAddress.anyIPv4, port));
  }

  /// 关闭socks5服务
  Future<void> stopSocks5() async {
    _subscription?.cancel();
    _server?.proxies.values.first.close();
    _server?.proxies.clear();
  }

  /// 启动服务
  Future<void> startFRPC({
    required String uid,
    required String cfgFilePath,
  }) async {
    return ProxyfrpcPlatform.instance.startFRPC(
      uid: uid,
      cfgFilePath: cfgFilePath,
    );
  }

  /// 关闭服务
  Future<void> stopFRPC({required String uid}) async {
    return ProxyfrpcPlatform.instance.stopFRPC(
      uid: uid,
    );
  }
}
