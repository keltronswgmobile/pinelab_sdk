import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pinelab_sdk_method_channel.dart';

//ignore: prefer-match-file-name
abstract class PinelabSdkPlatform extends PlatformInterface {
  /// Constructs a PinelabSdkPlatform.
  PinelabSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static PinelabSdkPlatform _instance = MethodChannelPinelabSdk();

  /// The default instance of [PinelabSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelPinelabSdk].
  static PinelabSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PinelabSdkPlatform] when
  /// they register themselves.
  static set instance(PinelabSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future startTransaction(String transactionMap) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
