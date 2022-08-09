import 'package:flutter_test/flutter_test.dart';
import 'package:ilebo/ilebo.dart';
import 'package:ilebo/ilebo_platform_interface.dart';
import 'package:ilebo/ilebo_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIleboPlatform 
    with MockPlatformInterfaceMixin
    implements IleboPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IleboPlatform initialPlatform = IleboPlatform.instance;

  test('$MethodChannelIlebo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIlebo>());
  });

  test('getPlatformVersion', () async {
    Ilebo ileboPlugin = Ilebo();
    MockIleboPlatform fakePlatform = MockIleboPlatform();
    IleboPlatform.instance = fakePlatform;
  
    expect(await ileboPlugin.getPlatformVersion(), '42');
  });
}
