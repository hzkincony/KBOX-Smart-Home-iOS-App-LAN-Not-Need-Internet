//
//  KinconySceneRLMObject.h
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "RLMObject.h"
#import "RLMArray.h"
#import "KinconySceneDeviceRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KinconySceneRLMObject : RLMObject

@property NSString *sceneId;
@property NSString *name;
@property NSString *image;
@property NSInteger controlModel;               //0:click   1:touch
@property RLMArray<KinconySceneDeviceRLMObject *><KinconySceneDeviceRLMObject> *sceneDevices;

@end

NS_ASSUME_NONNULL_END
