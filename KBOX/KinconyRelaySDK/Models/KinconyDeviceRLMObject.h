//
//  KinconyDeviceRLMObject.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyDeviceRLMObject : RLMObject

@property NSString *deviceId;
@property NSString *ipAddress;
@property NSInteger port;
@property NSString *num;
@property NSString *name;
@property NSString *image;
@property NSInteger type;

@end

NS_ASSUME_NONNULL_END
