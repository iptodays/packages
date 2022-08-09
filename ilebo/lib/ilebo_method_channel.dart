import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ilebo_platform_interface.dart';

/// An implementation of [IleboPlatform] that uses method channels.
class MethodChannelIlebo extends IleboPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ilebo');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
