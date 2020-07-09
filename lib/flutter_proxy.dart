import 'dart:async';

import 'package:flutter/services.dart';

class FlutterProxy {
  static const MethodChannel _channel = const MethodChannel('flutter_proxy');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///获取动态代理
  static Future<dynamic> get getDynamicProxy async {
    final result = await _channel.invokeMethod('getDynamicProxy');
    return result;
  }
}
