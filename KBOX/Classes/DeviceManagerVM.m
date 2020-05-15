//
//  DeviceManagerVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceManagerVM.h"
#import "KinconyRelay.h"

@interface DeviceManagerVM()

@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation DeviceManagerVM

- (void)initializeData {
    self.getConnectDevicesSignal = [RACSubject subject];
};

#pragma mark - public methods

- (void)getConnectDevices {
    [self.deviceManagerCellVMList removeAllObjects];
    NSArray *list = [self.kinconyRelay getAllConnectDevice];
    for (KinconyDevice *device in list) {
        DeviceManagerCellVM *deviceManagerCellVM = [[DeviceManagerCellVM alloc] initWithDevice:device];
        [self.deviceManagerCellVMList addObject:deviceManagerCellVM];
    }
    [self.getConnectDevicesSignal sendNext:@""];
}

#pragma mark - setters and getters

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

- (NSMutableArray*)deviceManagerCellVMList {
    if (_deviceManagerCellVMList == nil) {
        self.deviceManagerCellVMList = [[NSMutableArray alloc] init];
    }
    return _deviceManagerCellVMList;
}

@end
