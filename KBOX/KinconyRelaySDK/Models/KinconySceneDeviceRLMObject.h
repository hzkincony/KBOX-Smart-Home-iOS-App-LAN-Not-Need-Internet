//
//  KinconySceneDeviceRLMObject.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "RLMObject.h"
#import "KinconyDeviceRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KinconySceneDeviceRLMObject : RLMObject

@property (nonatomic, strong) KinconyDeviceRLMObject *device;
@property NSInteger state;

@end

RLM_ARRAY_TYPE(KinconySceneDeviceRLMObject)

NS_ASSUME_NONNULL_END
