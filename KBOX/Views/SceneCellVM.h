//
//  SceneCellVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconySceneRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneCellVM : GLViewModel

@property (nonatomic, strong) NSString *name;

- (id)initWithScene:(KinconySceneRLMObject*)scene;
- (void)deleteScene;
- (KinconySceneRLMObject*)getScene;

@end

NS_ASSUME_NONNULL_END
