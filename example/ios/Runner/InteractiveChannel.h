//
//  InteractiveChannel.h
//  Runner
//
//  Created by Mario on 2020/7/9.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractiveChannel : NSObject

+ (void)registerWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
