import 'pinelab_sdk_platform_interface.dart';

class PinelabSdk {
  Future startTransaction(String transactionMap) {
    return PinelabSdkPlatform.instance.startTransaction(transactionMap);
  }
}
