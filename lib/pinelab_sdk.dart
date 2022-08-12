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
          streamController.sink.add(
            PinelabResponse(
              isSuccess: true,
              response: call.arguments as String,
            ),
          );
          break;
        case 'error':
          streamController.sink.add(
            PinelabResponse(
              isSuccess: false,
              response: call.arguments as String,
            ),
          );
          break;
      }
    });
  }

  void dispose() {
    streamController.close();
  }

  Future<String?> startTransaction({required String transactionRequest}) {
    return PinelabSdkPlatform.instance
        .startTransaction(transactionRequest: transactionRequest);
  }
}

class PinelabResponse {
  late bool isSuccess;
  late String response;

  PinelabResponse({required this.isSuccess, required this.response});

  factory PinelabResponse.fromJson(Map<String, dynamic> json) {
    return PinelabResponse(
      isSuccess: json['success'] as bool,
      response: json['response'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'response': response,
    };
  }

  @override
  String toString() {
    return 'PinelabResponse{isSuccess: $isSuccess, response: $response}';
  }
}
