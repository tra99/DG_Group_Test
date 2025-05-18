// import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

enum NetworkType { wifi, mobile }

class NetworkInfo {
 static const _channel = MethodChannel('network_info');
  static final NetworkInfo _instance = NetworkInfo._internal();

  factory NetworkInfo() => _instance;

  NetworkInfo._internal();

  Future<String> getIPv4({
    NetworkType type = NetworkType.wifi,
    bool forceRefresh = false,
  }) async {
    try {
      return await _channel.invokeMethod('getIPv4', {
        'type': type == NetworkType.wifi ? 0 : 1,
        'forceRefresh': forceRefresh,
      });
    } on PlatformException catch (e) {
      print('Failed to get IPv4: ${e.message}');
      return 'No internet connection';
    }
  }

  Future<String> getIPv6({
    NetworkType type = NetworkType.wifi,
    bool forceRefresh = false,
  }) async {
    try {
      return await _channel.invokeMethod('getIPv6', {
        'type': type == NetworkType.wifi ? 0 : 1,
        'forceRefresh': forceRefresh,
      });
    } on PlatformException catch (e) {
      print('Failed to get IPv6: ${e.message}');
      return 'No internet connection';
    }
  }
}