import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'iumeng_method_channel.dart';

abstract class IumengPlatform extends PlatformInterface {
  /// Constructs a IumengPlatform.
  IumengPlatform() : super(token: _token);

  static final Object _token = Object();

  static IumengPlatform _instance = MethodChannelIumeng();

  /// The default instance of [IumengPlatform] to use.
  ///
  /// Defaults to [MethodChannelIumeng].
  static IumengPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IumengPlatform] when
  /// they register themselves.
  static set instance(IumengPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
