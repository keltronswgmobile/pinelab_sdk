
import 'pinelab_sdk_platform_interface.dart';

class PinelabSdk {
  Future<String?> getPlatformVersion() {
    return PinelabSdkPlatform.instance.getPlatformVersion();
  }
}
