#import "FlutterProxyPlugin.h"

@implementation FlutterProxyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_proxy"
            binaryMessenger:[registrar messenger]];
  FlutterProxyPlugin* instance = [[FlutterProxyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"getDynamicProxy" isEqualToString:call.method]){
    /// 自动获取手机代理
    result([self getSystemProxy]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark 自动获取手机代理
- (NSDictionary *)getSystemProxy {
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies firstObject];

    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]) {
        return nil;
    } else {
        NSString *hostName = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSString *portName = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:hostName forKey:@"proxyHost"];
        [dict setValue:portName forKey:@"proxyPort"];
        return [dict copy];
    }
}


@end
