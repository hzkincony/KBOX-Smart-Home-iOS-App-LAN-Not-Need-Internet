//
//  KinconyDeviceState.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/11.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyDeviceState : NSObject

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
