import 'dart:async';

import 'pinelab_sdk_method_channel.dart';
import 'pinelab_sdk_platform_interface.dart';

class PinelabSdk {
  final streamController = StreamController.broadcast();

  PinelabSdk() {
    MethodChannelPinelabSdk.methodChannel.setMethodCallHandler((call) async {
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

  StreamController get responseStreamController => streamController;

  Future<String?> startTransaction({required String transactionRequest}) {
    return PinelabSdkPlatform.instance
        .startTransaction(transactionRequest: transactionRequest);
  }
}
