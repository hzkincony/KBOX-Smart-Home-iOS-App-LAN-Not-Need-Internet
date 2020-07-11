//
//  SceneCellVM.h
//  KBOX
//
//  Created by gulu on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconySceneRLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneCellVM : GLViewModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;

- (id)initWithScene:(KinconySceneRLMObject*)scene;
- (void)deleteScene;
- (KinconySceneRLMObject*)getScene;

@end

NS_ASSUME_NONNULL_END
