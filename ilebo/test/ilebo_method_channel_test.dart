import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilebo/ilebo_method_channel.dart';

void main() {
  MethodChannelIlebo platform = MethodChannelIlebo();
  const MethodChannel channel = MethodChannel('ilebo');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
