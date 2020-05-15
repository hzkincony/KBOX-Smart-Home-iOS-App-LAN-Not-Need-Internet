//
//  SceneEditVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneEditVM.h"
#import "SceneDeviceCellVM.h"
#import "KinconyRelay.h"

@interface SceneEditVM() <ChooseSceneDeviceVMDelegate>

@property (nonatomic, strong) KinconyRelay *kinconyRelay;
@property (nonatomic, strong) KinconySceneRLMObject *oldScene;

@end

@implementation SceneEditVM

@synthesize scene = _scene;

- (void)initializeData {
    self.getSceneDevicesSignal = [RACSubject subject];
    self.saveSceneSignal = [RACSubject subject];
};

#pragma mark - ChooseSceneDeviceVMDelegate

- (void)sceneDeviceChoosed:(KinconyDeviceRLMObject *)device {
    if ([self validDeviceById:device.deviceId]) {
        [self addSceneDevice:device];
    }
}

#pragma mark - public methods

- (ChooseSceneDeviceVM*)getChooseSceneDeviceVM {
    ChooseSceneDeviceVM *chooseSceneDeviceVM = [[ChooseSceneDeviceVM alloc] init];
    chooseSceneDeviceVM.delegate = self;
    return chooseSceneDeviceVM;
}

- (void)getSceneDevices {
    [self.sceneDeviceCellVMList removeAllObjects];
    for (KinconySceneDeviceRLMObject *sceenDevice in self.scene.sceneDevices) {
        SceneDeviceCellVM *sceneDeviceCellVM = [[SceneDeviceCellVM alloc] initWithDevice:sceenDevice];
        [self.sceneDeviceCellVMList addObject:sceneDeviceCellVM];
    }
    [self.getSceneDevicesSignal sendNext:@""];
}

- (void)saveScene {
    if (self.type == SceneEditVMTypeEdit) {
        [self.kinconyRelay deleteScene:self.oldScene];
    }
    
    self.scene.name = self.name;
    [self.kinconyRelay saveScene:self.scene];
    [self.saveSceneSignal sendNext:@""];
}

- (BOOL)isValidInput {
    if (self.name.length == 0) {
        [self.saveSceneSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"noSceneNameHudMsg", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

#pragma mark - private methods

- (BOOL)validDeviceById:(NSString*)deviceId {
    for (KinconySceneDeviceRLMObject *sceneDevice in self.scene.sceneDevices) {
        if ([sceneDevice.device.deviceId isEqualToString:deviceId]) {
            return NO;
        }
    }
    return YES;
}

- (void)addSceneDevice:(KinconyDeviceRLMObject*)device {
    KinconySceneDeviceRLMObject *sceneDevice = [[KinconySceneDeviceRLMObject alloc] init];
    sceneDevice.device = device;
    sceneDevice.state = 0;
    [self.scene.sceneDevices addObject:sceneDevice];
}

- (NSString*)getUuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - setters and getters

- (void)setType:(SceneEditVMType)type {
    _type = type;
    if (type == SceneEditVMTypeAdd) {
        self.title = NSLocalizedString(@"sceneEditTitleAdd", nil);
    } else {
        self.title = NSLocalizedString(@"sceneEditTitleEdit", nil);
    }
}

- (KinconySceneRLMObject*)scene {
    if (_scene == nil) {
        self.scene = [[KinconySceneRLMObject alloc] init];
        self.scene.sceneId = [self getUuid];
    }
    return _scene;
}

- (void)setScene:(KinconySceneRLMObject *)scene {
    self.oldScene = scene;
    
    KinconySceneRLMObject *newScene = [[KinconySceneRLMObject alloc] init];
    newScene.sceneId = scene.sceneId;
    newScene.name = scene.name;
    
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        KinconySceneDeviceRLMObject *newSceneDevice = [[KinconySceneDeviceRLMObject alloc] init];
        newSceneDevice.device = sceneDevice.device;
        newSceneDevice.state = sceneDevice.state;
        [newScene.sceneDevices addObject:newSceneDevice];
    }
    
    _scene = newScene;
    self.name = _scene.name;
}

- (NSMutableArray*)sceneDeviceCellVMList {
    if (_sceneDeviceCellVMList == nil) {
        self.sceneDeviceCellVMList = [[NSMutableArray alloc] init];
    }
    return _sceneDeviceCellVMList;
}

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

@end
