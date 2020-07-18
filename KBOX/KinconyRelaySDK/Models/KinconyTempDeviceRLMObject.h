//
//  KinconyTempDeviceRLMObject.h
//  KBOX
//
//  Created by gulu on 2020/7/19.
//  Copyright © 2020 kincony. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyTempDeviceRLMObject : RLMObject

@property NSString *ipAddress;
@property NSInteger port;
@property NSString *num;

@end

NS_ASSUME_NONNULL_END
