import 'dart:async';

import 'package:flutter/services.dart';

import 'pinelab_sdk_platform_interface.dart';

/// An implementation of [PinelabSdkPlatform] that uses method channels.
//ignore: prefer-match-file-name
class MethodChannelPinelabSdk extends PinelabSdkPlatform {
  /// The method channel used to interact with the native platform.
  static const methodChannel = MethodChannel('pinelab_sdk');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version =
  //       await methodChannel.invokeMethod<String>('getPlatformVersion');

  //   return version;
  // }

  @override
  Future<String?> startTransaction({required String transactionRequest}) async {
    final response = await methodChannel.invokeMethod(
      'startTransaction',
      {'transactionRequest': transactionRequest},
    );

    return response?.toString();
  }
}
