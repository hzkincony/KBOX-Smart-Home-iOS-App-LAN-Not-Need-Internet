//
//  DeviceListVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceListVM.h"
#import "KinconyRelay.h"
#import "RLMRealmConfiguration.h"
#import "RelayCellVM.h"

@interface DeviceListVM()

@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation DeviceListVM

- (void)initializeData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateNotification:) name:KinconyDeviceStateNotification object:nil];
    
    self.addDeviceSignal = [RACSubject subject];
    self.getDevicesSignal = [RACSubject subject];
    self.getDevicesStateSignal = [RACSubject subject];
    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    [self.kinconyRelay connectAllDevices];
    [self getDevices];
};

#pragma mark - Notifications

- (void)deviceStateNotification:(NSNotification*)notification {
    NSArray *stateArray = [notification.userInfo objectForKey:@"stateArray"];
    
    for (RelayCellVM *relayCellVM in self.deviceCellVMList) {
        KinconyDeviceRLMObject *device = [relayCellVM getDevice];
        if ([device.num integerValue] < stateArray.count) {
            KinconyDeviceState *deviceState = [stateArray objectAtIndex:[device.num integerValue] - 1];
            if ([device.ipAddress isEqualToString:deviceState.ipAddress] && device.port == deviceState.port) {
                relayCellVM.deviceOn = [NSNumber numberWithInteger:deviceState.state];
            }
        }
    }
    [self.getDevicesStateSignal sendNext:@""];
}

#pragma mark - public methods

- (void)addDevice {
    @weakify(self);
    [self.kinconyRelay addDevice:self.ipAddress withPort:[self.port integerValue] withBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        if (error.code == DeviceAddErrorCode_AlreadyExists) {
            [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"deviceAlreadyExists", nil) code:1 userInfo:nil]];
        } else {
            [self.addDeviceSignal sendNext:nil];
        }
    }];
}

- (void)getDevices {
    RLMResults *devices = [self.kinconyRelay getAllDevices];
    [self.deviceCellVMList removeAllObjects];
    for (KinconyDeviceRLMObject *device in devices) {
        RelayCellVM *relayCellVM = [[RelayCellVM alloc] initWithDevice:device];
        [self.deviceCellVMList addObject:relayCellVM];
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
    [self.kinconyRelay exchangeDevicesIndex:changedArray];
}

- (void)searchDevicesState {
    [self.kinconyRelay searchDevicesState];
}

#pragma mark - setters and getters

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

- (NSMutableArray*)deviceCellVMList {
    if (_deviceCellVMList == nil) {
        self.deviceCellVMList = [[NSMutableArray alloc] init];
    }
    return _deviceCellVMList;
}

@end