//
//  KinconyDeviceState.h
//  KBOX
//
//  Created by gulu on 2019/4/11.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyDeviceState : NSObject

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger deviceType;
@property (nonatomic, assign) NSInteger value;

@end

NS_ASSUME_NONNULL_END
