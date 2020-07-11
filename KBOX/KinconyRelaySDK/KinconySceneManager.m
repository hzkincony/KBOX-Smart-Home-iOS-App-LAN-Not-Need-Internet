//
//  KinconySceneManager.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "KinconySceneManager.h"

@implementation KinconySceneManager

static KinconySceneManager *sharedManager = nil;

+ (KinconySceneManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - public methods

- (void)saveScene:(KinconySceneRLMObject *)scene {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:scene];
    [realm commitWriteTransaction];
}

- (RLMResults*)getScenes {
    RLMResults<KinconySceneRLMObject*> *scenes = [KinconySceneRLMObject allObjects];
    return scenes;
}

- (void)deleteScene:(KinconySceneRLMObject*)scene {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:scene.sceneDevices];
    [realm deleteObject:scene];
    [realm commitWriteTransaction];
}

#pragma mark - private methods



@end
