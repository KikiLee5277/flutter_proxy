//
//  InteractiveChannel.m
//  Runner
//
//  Created by Mario on 2020/7/9.
//
#import "InteractiveChannel.h"

static NSString *const kMethodChannelName = @"flutter_proxy";

@interface InteractiveChannel ()

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;

@end

@implementation InteractiveChannel

+ (instancetype)sharedChannel {
    static InteractiveChannel *_channel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _channel = [[InteractiveChannel alloc] init];
    });
    return _channel;
}

+ (void)registerWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    InteractiveChannel *channel = [InteractiveChannel sharedChannel];
    [channel registerMethodChannelWithBinaryMessenger:messenger];
}

#pragma mark - Method Channel
- (void)registerMethodChannelWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:kMethodChannelName
                                                     binaryMessenger:messenger];
    __weak typeof(self) weakSelf = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"getDynamicProxy"]) {
            /// 自动获取手机代理
            result([weakSelf getSystemProxy]);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
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

