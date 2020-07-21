//
//  SceneEditVM.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneEditVM.h"
#import "SceneDeviceCellVM.h"
#import "KinconyRelay.h"

@interface SceneEditVM() <ChooseSceneDeviceVMDelegate, DeviceImageChooseVMDelegate>

//@property (nonatomic, strong) KinconyRelay *kinconyRelay;
@property (nonatomic, strong) KinconySceneRLMObject *oldScene;
@property (nonatomic, strong) NSString *sceneImageName;

@end

@implementation SceneEditVM

@synthesize scene = _scene;

- (void)initializeData {
    self.getSceneDevicesSignal = [RACSubject subject];
    self.saveSceneSignal = [RACSubject subject];
    
    self.sceneImageName = @"icon1";
    self.controlModel = @0;
    [RACObserve(self, sceneImageName) subscribeNext:^(id  _Nullable x) {
        self.sceneImage = [UIImage imageNamed:x];
    }];
};

#pragma mark - ChooseSceneDeviceVMDelegate

- (void)sceneDeviceChoosed:(KinconyDeviceRLMObject *)device {
    if ([self validDeviceById:device.deviceId]) {
        [self addSceneDevice:device];
    }
}

#pragma mark - DeviceImageChooseVMDelegate

- (void)choosedImageName:(NSString *)imageName chooseType:(DeviceImageChooseVMType)chooseType {
    self.sceneImageName = imageName;
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
    self.scene.name = self.name;
    self.scene.image = self.sceneImageName;
    self.scene.controlModel = self.controlModel.integerValue;
    [[KinconyRelay sharedManager] saveScene:self.scene];
    [self.saveSceneSignal sendNext:@""];
}

- (BOOL)isValidInput {
    if (self.name.length == 0) {
        [self.saveSceneSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"noSceneNameHudMsg", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)deleteSceneDevice:(NSInteger)index {
    [self.scene.sceneDevices removeObjectAtIndex:index];
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
    newScene.controlModel = scene.controlModel;
    newScene.image = scene.image;
    
    for (KinconySceneDeviceRLMObject *sceneDevice in scene.sceneDevices) {
        KinconySceneDeviceRLMObject *newSceneDevice = [[KinconySceneDeviceRLMObject alloc] init];
        newSceneDevice.device = sceneDevice.device;
        newSceneDevice.state = sceneDevice.state;
        [newScene.sceneDevices addObject:newSceneDevice];
    }
    
    _scene = newScene;
    self.name = _scene.name;
    self.sceneImageName = _scene.image == nil ? @"icon1": _scene.image;
    self.controlModel = [NSNumber numberWithInteger:_scene.controlModel];
}

- (NSMutableArray*)sceneDeviceCellVMList {
    if (_sceneDeviceCellVMList == nil) {
        self.sceneDeviceCellVMList = [[NSMutableArray alloc] init];
    }
    return _sceneDeviceCellVMList;
}

//- (KinconyRelay*)kinconyRelay {
//    if (_kinconyRelay == nil) {
//        self.kinconyRelay = [[KinconyRelay alloc] init];
//    }
//    return _kinconyRelay;
//}

- (DeviceImageChooseVM *)deviceImageChooseVM {
    if (_deviceImageChooseVM == nil) {
        self.deviceImageChooseVM = [[DeviceImageChooseVM alloc] init];
        self.deviceImageChooseVM.chooseType = ChooseTypeNone;
        self.deviceImageChooseVM.delegate = self;
    }
    return _deviceImageChooseVM;
}

@end
