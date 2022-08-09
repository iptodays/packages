import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ilebo_method_channel.dart';

abstract class IleboPlatform extends PlatformInterface {
  /// Constructs a IleboPlatform.
  IleboPlatform() : super(token: _token);

  static final Object _token = Object();

  static IleboPlatform _instance = MethodChannelIlebo();

  /// The default instance of [IleboPlatform] to use.
  ///
  /// Defaults to [MethodChannelIlebo].
  static IleboPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IleboPlatform] when
  /// they register themselves.
  static set instance(IleboPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
