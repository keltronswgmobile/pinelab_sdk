import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pinelab_sdk/pinelab_sdk.dart';

class HomeController extends GetxController {
  String _flutterResponse = '';
  String _pinelabResponse = '';
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

      pinelabResponse = await pinelabSdk.startTransaction(
              transactionRequest: doTransactionPayload) ??
          'error';
    } catch (e) {
      flutterResponse = e.toString();
    }
  }

  void clearResponse() {
    flutterResponse = '';
    pinelabResponse = '';
  }

  String get flutterResponse => _flutterResponse;
  set flutterResponse(String v) => {_flutterResponse = v, update()};
  String get pinelabResponse => _pinelabResponse;
  set pinelabResponse(String v) => {_pinelabResponse = v, update()};
}

// class PinlabSdk {
//   final MethodChannel _channel = const MethodChannel('pinelab_sdk');
//   final StreamController _streamController = StreamController.broadcast();

//   PinlabSdk() {
//     _channel.setMethodCallHandler((call) async {
//       print("flutter_response $call");
//       final method = call.method;
//       switch (method) {
//         case 'success':
//           _streamController.sink.add({
//             "status": 1,
//             "msg": call.arguments,
//           });
//           break;
//         case 'error':
//           _streamController.sink.add({
//             'status': 0,
//             'msg': call.arguments['errorMessage'],
//           });
//           break;
//       }
//     });
//   }

//   void dispose() {
//     _streamController.close();
//   }

//   Stream get stream => _streamController.stream;

//   Future makePayment(String transactionMap) async {
//     await _channel.invokeMethod('makePayment', {
//       'transactionMap': transactionMap,
//       'packageName': 'org.keltron.ticketapp'
//     });
//   }
// }
