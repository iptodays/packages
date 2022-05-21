import 'iumeng_platform_interface.dart';

class Iumeng {
  Future<String?> getPlatformVersion() {
    return IumengPlatform.instance.getPlatformVersion();
  }
}
