import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skan/skan.dart';

void main() {
  const MethodChannel channel = MethodChannel('skan');

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
    Skan.registerAppForAdNetworkAttribution();
  });
}
