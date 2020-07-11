//
//  KinconySceneManager.h
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KinconySceneRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KinconySceneManager : NSObject

+ (KinconySceneManager*)sharedManager;

- (void)saveScene:(KinconySceneRLMObject*)scene;

- (RLMResults*)getScenes;

- (void)deleteScene:(KinconySceneRLMObject*)scene;

@end

NS_ASSUME_NONNULL_END
