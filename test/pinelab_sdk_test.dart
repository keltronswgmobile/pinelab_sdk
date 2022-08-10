import 'package:flutter_test/flutter_test.dart';
import 'package:pinelab_sdk/pinelab_sdk.dart';
import 'package:pinelab_sdk/pinelab_sdk_platform_interface.dart';
import 'package:pinelab_sdk/pinelab_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPinelabSdkPlatform
    with MockPlatformInterfaceMixin
    implements PinelabSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PinelabSdkPlatform initialPlatform = PinelabSdkPlatform.instance;

  test('$MethodChannelPinelabSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPinelabSdk>());
  });

  test('getPlatformVersion', () async {
    PinelabSdk pinelabSdkPlugin = PinelabSdk();
    MockPinelabSdkPlatform fakePlatform = MockPinelabSdkPlatform();
    PinelabSdkPlatform.instance = fakePlatform;

    expect(await pinelabSdkPlugin.getPlatformVersion(), '42');
  });
}
