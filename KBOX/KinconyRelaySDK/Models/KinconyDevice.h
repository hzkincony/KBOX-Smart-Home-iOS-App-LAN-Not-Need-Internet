//
//  KinconyDevice.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyDevice : NSObject

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) NSInteger port;

@end

NS_ASSUME_NONNULL_END
