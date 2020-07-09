# flutter_proxy
一款flutter获取手机动态代理的插件
可以设置到dio库上,方便抓包。

使用方法:

FlutterProxy.getDynamicProxy.then((map){
     
     if(map == null){
        return;
      }
      if(map is Map){//返回格式 {proxyPort: 8888, proxyHost: 192.168.1.1}
        String proxyHost = map['proxyHost'];
        int proxyPort = map['proxyPort'];
        if(proxyHost !=null && proxyHost.isNotEmpty && proxyPort != -1){
          (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
              (client) {
            client.badCertificateCallback = (cert, host, port) => true;
            client.findProxy = (uri) {
              return 'PROXY $proxyHost:$proxyPort';
            };
          };
        }
      }
    });
