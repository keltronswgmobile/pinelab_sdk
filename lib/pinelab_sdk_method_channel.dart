import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pinelab_sdk_platform_interface.dart';

/// An implementation of [PinelabSdkPlatform] that uses method channels.
//ignore: prefer-match-file-name
class MethodChannelPinelabSdk extends PinelabSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pinelab_sdk');
  @visibleForTesting
  final streamController = StreamController.broadcast();

  MethodChannelPinelabSdk() {
    methodChannel.setMethodCallHandler((call) async {
      final method = call.method;
      switch (method) {
        case 'success':
          streamController.sink.add({
            'success': true,
            'response': call.arguments,
          });
          break;
        case 'error':
          streamController.sink.add({
            'success': false,
            // ignore: avoid_dynamic_calls
            'response': call.arguments['errorMessage'] as String,
          });
          break;
      }
    });
  }

  void dispose() {
    streamController.close();
  }

  Stream get responseStream => streamController.stream;

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version =
  //       await methodChannel.invokeMethod<String>('getPlatformVersion');

  //   return version;
  // }

  @override
  Future startTransaction(String transactionMap) async {
    await methodChannel
        .invokeMethod('makePayment', {'transactionMap': transactionMap});
  }
}
