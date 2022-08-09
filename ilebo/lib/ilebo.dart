
import 'ilebo_platform_interface.dart';

class Ilebo {
  Future<String?> getPlatformVersion() {
    return IleboPlatform.instance.getPlatformVersion();
  }
}
