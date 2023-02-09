import 'package:flutter_test/flutter_test.dart';
import 'package:proxyfrpc/proxyfrpc_platform_interface.dart';
import 'package:proxyfrpc/proxyfrpc_method_channel.dart';

void main() {
  final ProxyfrpcPlatform initialPlatform = ProxyfrpcPlatform.instance;

  test('$MethodChannelProxyfrpc is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelProxyfrpc>());
  });

  test('getPlatformVersion', () async {});
}
