import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinelab_sdk/pinelab_sdk_method_channel.dart';

void main() {
  MethodChannelPinelabSdk platform = MethodChannelPinelabSdk();
  const MethodChannel channel = MethodChannel('pinelab_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
