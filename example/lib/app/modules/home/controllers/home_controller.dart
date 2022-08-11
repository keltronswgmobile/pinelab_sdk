import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pinelab_sdk/pinelab_sdk.dart';

class HomeController extends GetxController {
  String _flutterResponse = '';
  PinelabResponse? _pinelabResponse;
  final pinelabSdk = PinelabSdk();

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

      pinelabSdk.startTransaction(transactionRequest: doTransactionPayload);
      listenToPinelabResponse();
    } catch (e) {
      flutterResponse = e.toString();
    }
  }

  void listenToPinelabResponse() {
    pinelabSdk.streamController.stream.listen((event) {
      pinelabResponse = event;
    });
  }

  void clearResponse() {
    flutterResponse = '';
    pinelabResponse = null;
  }

  String get flutterResponse => _flutterResponse;
  set flutterResponse(String v) => {_flutterResponse = v, update()};
  PinelabResponse? get pinelabResponse => _pinelabResponse;
  set pinelabResponse(PinelabResponse? v) => {_pinelabResponse = v, update()};
}
