//
//  SocketManager.h
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KinconyDevice.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const KinconySocketReadDataNotification;
extern NSString * const KinconySocketDidConnectNotification;

@interface KinconySocketManager : NSObject

+ (KinconySocketManager*)sharedManager;

- (void)connectToDevice:(NSArray*)deviceArray;

- (void)disConnectAllDevice;

- (void)sendData:(NSString*)dataStr toDevice:(KinconyDevice*)device;

@end

NS_ASSUME_NONNULL_END
