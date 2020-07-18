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

- (void)updateSceneTempDevices {
    RLMResults *scenes = [self getScenes];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (KinconySceneRLMObject *scene in scenes) {
        for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
            KinconyTempDeviceRLMObject *tempDevice = [[KinconyTempDeviceRLMObject alloc] init];
            tempDevice.ipAddress = sceneDevice.device.ipAddress;
            tempDevice.port = sceneDevice.device.port;
            tempDevice.num = sceneDevice.device.num;
            sceneDevice.tempDevice = tempDevice;
        }
    }
    [realm commitWriteTransaction];
}

- (void)updateSceneDevice:(KinconySceneRLMObject *)scene withDevice:(NSArray *)devices {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        for (KinconyDeviceRLMObject *device in devices) {
            if ([sceneDevice.tempDevice.ipAddress isEqualToString:device.ipAddress] && [sceneDevice.tempDevice.num isEqualToString:device.num]) {
                sceneDevice.device = device;
            }
        }
    }
    [realm commitWriteTransaction];
}

#pragma mark - private methods



@end
