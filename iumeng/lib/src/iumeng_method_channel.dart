import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'iumeng_platform_interface.dart';

/// An implementation of [IumengPlatform] that uses method channels.
class MethodChannelIumeng extends IumengPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.iptoday.iumeng');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
