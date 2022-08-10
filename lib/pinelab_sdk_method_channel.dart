import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pinelab_sdk_platform_interface.dart';

/// An implementation of [PinelabSdkPlatform] that uses method channels.
class MethodChannelPinelabSdk extends PinelabSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pinelab_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
