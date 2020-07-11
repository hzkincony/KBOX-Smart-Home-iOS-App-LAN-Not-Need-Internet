//
//  SceneVM.m
//  KBOX
//
//  Created by gulu on 2019/4/17.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneVM.h"
#import "KinconyRelay.h"
#import "SceneCellVM.h"

@interface SceneVM()

@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation SceneVM

- (void)initializeData {
    self.getScenesSignal = [RACSubject subject];
};

#pragma mark - public methods

- (SceneEditVM*)getAddSceneEditVM {
    SceneEditVM *sceneEditVM = [[SceneEditVM alloc] init];
    sceneEditVM.type = SceneEditVMTypeAdd;
    return sceneEditVM;
}

- (SceneEditVM*)getEditSceneEditVM:(NSInteger)index {
    SceneEditVM *sceneEditVM = [[SceneEditVM alloc] init];
    sceneEditVM.type = SceneEditVMTypeEdit;
    SceneCellVM *sceneCellVM = [self.sceneCellVMList objectAtIndex:index];
    sceneEditVM.scene = [sceneCellVM getScene];
    return sceneEditVM;
}

- (void)getScenes {
    [self.sceneCellVMList removeAllObjects];
    RLMResults *sceces = [self.kinconyRelay getSceces];
    for (KinconySceneRLMObject *scene in sceces) {
        SceneCellVM *sceneCellVM = [[SceneCellVM alloc] initWithScene:scene];
        [self.sceneCellVMList addObject:sceneCellVM];
    }
    [self.getScenesSignal sendNext:@""];
}

- (void)deleteScene:(NSInteger)index {
    SceneCellVM *sceneCellVM = [self.sceneCellVMList objectAtIndex:index];
    [sceneCellVM deleteScene];
    [self getScenes];
}

- (void)commandScene:(NSInteger)index {
    SceneCellVM *sceneCellVM = [self.sceneCellVMList objectAtIndex:index];
    [self.kinconyRelay sceneCommand:[sceneCellVM getScene]];
}

#pragma mark - setters and getters

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

- (NSMutableArray*)sceneCellVMList {
    if (_sceneCellVMList == nil) {
        self.sceneCellVMList = [[NSMutableArray alloc] init];
    }
    return _sceneCellVMList;
}

@end
