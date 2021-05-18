//
//  DeviceListVM.m
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceListVM.h"
#import "KinconyRelay.h"
#import "RLMRealmConfiguration.h"
#import "RelayCellVM.h"
#import "DimmerCellVM.h"

@interface DeviceListVM()

@end

@implementation DeviceListVM

- (void)initializeData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateNotification:) name:KinconyDeviceStateNotification object:nil];
    
    self.getDevicesSignal = [RACSubject subject];
    self.getDevicesStateSignal = [RACSubject subject];
    self.getSeceneSignal = [RACSubject subject];
    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    
    [[KinconyRelay sharedManager] connectAllDevices];
    [self getDevices];
};

#pragma mark - Notifications

- (void)deviceStateNotification:(NSNotification*)notification {
    NSArray *stateArray = [notification.userInfo objectForKey:@"stateArray"];
    
    for (GLViewModel *cellVM in self.deviceCellVMList) {
        KinconyDeviceRLMObject *device;
        if ([cellVM isKindOfClass:[RelayCellVM class]]) {
            device = [((RelayCellVM*)cellVM) getDevice];
        } else if ([cellVM isKindOfClass:[DimmerCellVM class]]) {
            device = [((DimmerCellVM*)cellVM) getDevice];
        }
        if ([device.num integerValue] <= stateArray.count) {
            KinconyDeviceState *deviceState = [stateArray objectAtIndex:[device.num integerValue] - 1];
            if (([device.ipAddress isEqualToString:deviceState.ipAddress] && device.port == deviceState.port) || [deviceState.serial hasPrefix:device.serial]) {
                if (device.type == KinconyDeviceType_Relay) {
                    ((RelayCellVM*)cellVM).deviceOn = [NSNumber numberWithInteger:deviceState.state];
                } else if (device.type == KinconyDeviceType_Dimmer) {
                    ((DimmerCellVM*)cellVM).deviceSliderValue = [NSNumber numberWithInteger:deviceState.value];
                }
            }
        }
    }
    [self.getDevicesStateSignal sendNext:@""];
}

#pragma mark - public methods

- (void)getDevices {
    RLMResults *devices = [[KinconyRelay sharedManager] getAllDevices];
    [self.deviceCellVMList removeAllObjects];
    for (KinconyDeviceRLMObject *device in devices) {
        if (device.type == KinconyDeviceType_Relay) {
            RelayCellVM *relayCellVM = [[RelayCellVM alloc] initWithDevice:device];
            [self.deviceCellVMList addObject:relayCellVM];
        } else {
            DimmerCellVM *dimmerCellVM = [[DimmerCellVM alloc] initWithDevice:device];
            [self.deviceCellVMList addObject:dimmerCellVM];
        }
    }
    [self.getDevicesSignal sendNext:@""];
}

- (void)exchangeDeviceAtIndex:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    RelayCellVM *cellVM1 = [self.deviceCellVMList objectAtIndex:sourceIndexPath.row];
    if (sourceIndexPath.row < destinationIndexPath.row) {
        [self.deviceCellVMList insertObject:cellVM1 atIndex:destinationIndexPath.row + 1];
        [self.deviceCellVMList removeObjectAtIndex:sourceIndexPath.row];
    } else {
        [self.deviceCellVMList insertObject:cellVM1 atIndex:destinationIndexPath.row];
        [self.deviceCellVMList removeObjectAtIndex:sourceIndexPath.row + 1];
    }
    
    NSMutableArray *changedArray = [[NSMutableArray alloc] init];
    for (RelayCellVM *cellVM in self.deviceCellVMList) {
        [changedArray addObject:[cellVM getDevice]];
    }
    [[KinconyRelay sharedManager] exchangeDevicesIndex:changedArray];
}

- (void)searchDevicesState {
    [[KinconyRelay sharedManager] searchDevicesState];
}

- (void)updateSecene {
    self.homeSeceneControlCellVM.scenes = [[KinconyRelay sharedManager] getSceces];
    [self.getSeceneSignal sendNext:@""];
}

#pragma mark - setters and getters

- (NSMutableArray*)deviceCellVMList {
    if (_deviceCellVMList == nil) {
        self.deviceCellVMList = [[NSMutableArray alloc] init];
    }
    return _deviceCellVMList;
}

- (HomeSeceneControlCellVM *)homeSeceneControlCellVM {
    if (_homeSeceneControlCellVM == nil) {
        self.homeSeceneControlCellVM = [[HomeSeceneControlCellVM alloc] init];
    }
    return _homeSeceneControlCellVM;
}

@end
