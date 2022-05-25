import 'package:flutter_test/flutter_test.dart';
import 'package:iumeng/iumeng.dart';
import 'package:iumeng/iumeng_platform_interface.dart';
import 'package:iumeng/iumeng_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIumengPlatform 
    with MockPlatformInterfaceMixin
    implements IumengPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IumengPlatform initialPlatform = IumengPlatform.instance;

  test('$MethodChannelIumeng is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIumeng>());
  });

  test('getPlatformVersion', () async {
    Iumeng iumengPlugin = Iumeng();
    MockIumengPlatform fakePlatform = MockIumengPlatform();
    IumengPlatform.instance = fakePlatform;
  
    expect(await iumengPlugin.getPlatformVersion(), '42');
  });
}
