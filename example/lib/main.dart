import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_proxy/flutter_proxy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _proxy = "Unknown";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String proxy;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterProxy.platformVersion;

      FlutterProxy.getDynamicProxy.then((map) {
        //获取ip动态代理
        if (map == null) {
          return;
        }
        if (map is Map) {
          //{proxyPort: 8888, proxyHost: 192.168.1.1}
          String proxyHost = map['proxyHost'];
          int proxyPort = map['proxyPort'];
          if (proxyHost != null && proxyHost.isNotEmpty && proxyPort != -1) {
            proxy =
                'proxyHost:' + proxyHost + ' proxyPort:' + proxyPort.toString();
            print(proxy);
            if (!mounted) return;
            setState(() {
              _proxy = proxy;
            });
          }
        }
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n' + 'Proxy: $_proxy\n'),
        ),
      ),
    );
  }
}
