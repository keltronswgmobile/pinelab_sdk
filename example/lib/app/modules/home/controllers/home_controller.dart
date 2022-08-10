import 'dart:async';
import 'dart:convert';

// import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:receive_intent/receive_intent.dart';

class HomeController extends GetxController {
  String _error = '';
  final pinelabSdk = PinlabSdk();

  Future<void> openPaymentApp() async {
    try {
      const transactionMap = {
        'Detail': {
          'BillingRefNo': 'TX12345678',
          'PaymentAmount': 9900,
          'TransactionType': 4001,
        },
        'Header': {
          'ApplicationId': 'de619e9d395444efb6952db5b66f4e5e',
          'MethodId': '1001',
          'UserId': '1234',
          'VersionNo': '1.0',
        },
      };
      final doTransactionPayload = jsonEncode(transactionMap);

      final result = await pinelabSdk.makePayment(doTransactionPayload);

      // final intent = AndroidIntent(
      //   package: 'com.pinelabs.masterapp',
      //   action: 'com.pinelabs.masterapp.HYBRID_REQUEST',
      //   arguments: {
      //     'REQUEST_DATA': doTransactionPayload,
      //     'packageName': 'org.keltron.ticketapp',
      //   },
      // );

      // intent.launch();
    } catch (e) {
      error = e.toString();
    }
  }

  void listenForIntentResponse() {
    try {
      // sub = ReceiveIntent.receivedIntentStream.listen((intent) {
      //   print('###############');
      //   print(intent);
      //   print('###############');
      // }, onError: (err) {
      //   error = err.toString();
      // });
    } catch (e) {
      error = e.toString();
    }
  }

  void clearError() {
    error = '';
  }

  String get error => _error;
  set error(String v) => {_error = v, update()};
}

class PinlabSdk extends GetxController {
  final MethodChannel _channel = const MethodChannel('pinelab_sdk');
  String _success = '';
  String _error = '';

  String get success => _success;
  set success(String v) => {_success = v, update()};
  String get error => _error;
  set error(String v) => {_error = v, update()};

  PinlabSdk() {
    _channel.setMethodCallHandler((call) async {
      print('########################');
      print(call);
      print('########################');
      final method = call.method;
      switch (method) {
        case 'success':
          success = '$success\n ${call.arguments}';
          break;
        case 'error':
          error = '$error\n ${call.arguments}';
          break;
      }
    });
  }

  Future makePayment(String transactionMap) async {
    await _channel.invokeMethod('makePayment', {
      'transactionMap': transactionMap,
      'packageName': 'org.keltron.ticketapp'
    });
  }
}
