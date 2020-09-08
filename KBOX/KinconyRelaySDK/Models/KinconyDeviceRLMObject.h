//
//  KinconyDeviceRLMObject.h
//  KBOX
//
//  Created by gulu on 2019/4/3.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyDeviceRLMObject : RLMObject

@property NSString *deviceId;
@property NSString *serial;
@property NSString *ipAddress;
@property NSInteger port;
@property NSString *num;
@property NSString *name;
@property NSString *image;
@property NSString *touchImage;
@property NSInteger type;
@property NSInteger controlModel;               //0:click   1:touch

@end

NS_ASSUME_NONNULL_END
