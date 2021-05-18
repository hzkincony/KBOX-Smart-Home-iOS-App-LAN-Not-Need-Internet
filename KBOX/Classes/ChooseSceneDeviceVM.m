//
//  ChooseSceneDeviceVM.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "ChooseSceneDeviceVM.h"
#import "KinconyRelay.h"
#import "SceneDeviceChooseCellVM.h"

@interface ChooseSceneDeviceVM()

//@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation ChooseSceneDeviceVM

- (void)initializeData {
    self.getDevicesSignal = [RACSubject subject];
    self.chooseDeviceSignal = [RACSubject subject];
}

#pragma mark - public methods

- (void)getDevices {
    RLMResults *devices = [[KinconyRelay sharedManager] getAllDevices];
    [self.deviceCellVMList removeAllObjects];
    for (KinconyDeviceRLMObject *device in devices) {
        if (device.type == KinconyDeviceType_Relay) {
            SceneDeviceChooseCellVM *sceneDeviceChooseCellVM = [[SceneDeviceChooseCellVM alloc] initWithDevice:device];
            [self.deviceCellVMList addObject:sceneDeviceChooseCellVM];
        }
    }
    [self.getDevicesSignal sendNext:@""];
}

- (void)chooseDevice:(NSInteger)index {
    SceneDeviceChooseCellVM *sceneDeviceChooseCellVM = [self.deviceCellVMList objectAtIndex:index];
    [self.delegate sceneDeviceChoosed:[sceneDeviceChooseCellVM getDevice]];
    [self.chooseDeviceSignal sendNext:NSLocalizedString(@"sceneDeviceChoosed", nil)];
}

#pragma mark - setters and getters

//- (KinconyRelay*)kinconyRelay {
//    if (_kinconyRelay == nil) {
//        self.kinconyRelay = [[KinconyRelay alloc] init];
//    }
//    return _kinconyRelay;
//}

- (NSMutableArray*)deviceCellVMList {
    if (_deviceCellVMList == nil) {
        self.deviceCellVMList = [[NSMutableArray alloc] init];
    }
    return _deviceCellVMList;
}

@end
