//
//  DeviceAddVM.m
//  KBOX
//
//  Created by gulu on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "DeviceAddVM.h"
#import "KinconyRelay.h"

@interface DeviceAddVM()

@end

@implementation DeviceAddVM

- (void)initializeData {
    self.addDeviceSignal = [RACSubject subject];
    self.num = 0;
    self.deviceType = KinconyDeviceType_Relay;
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.ip.length == 0) {
        [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseInputIP", nil) code:1 userInfo:nil]];
        return NO;
    }
    if (self.port.length == 0) {
        [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseInputPort", nil) code:1 userInfo:nil]];
        return NO;
    }
    if (self.deviceType == KinconyDeviceType_Relay && self.num == 0) {
        [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseChooseModel", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doAddDevice {
    if (self.deviceType == KinconyDeviceType_Dimmer) {
        self.num = 8;
    }
    
    @weakify(self);
    [[KinconyRelay sharedManager] addDevice:self.ip withPort:[self.port integerValue] withNum:self.num withDeviceType:self.deviceType withSerial:self.serial withBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        if (error.code == DeviceAddErrorCode_AlreadyExists) {
            [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"deviceAlreadyExists", nil) code:1 userInfo:nil]];
        } else {
            [self.addDeviceSignal sendNext:nil];
        }
    }];
}

#pragma mark - setters and getters

@end
