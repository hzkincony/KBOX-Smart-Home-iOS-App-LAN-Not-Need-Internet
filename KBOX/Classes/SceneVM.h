//
//  SceneVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/17.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "SceneEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneVM : GLViewModel

@property (nonatomic, strong) RACSubject *getScenesSignal;
@property (nonatomic, strong) NSMutableArray *sceneCellVMList;

- (SceneEditVM*)getAddSceneEditVM;
- (SceneEditVM*)getEditSceneEditVM:(NSInteger)index;
- (void)getScenes;
- (void)deleteScene:(NSInteger)index;
- (void)commandScene:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
