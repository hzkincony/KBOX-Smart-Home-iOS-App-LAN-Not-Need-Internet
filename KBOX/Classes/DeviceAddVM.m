//
//  DeviceAddVM.m
//  KBOX
//
//  Created by 顾越超 on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "DeviceAddVM.h"
#import "KinconyDeviceManager.h"

@implementation DeviceAddVM

- (void)initializeData {
    self.addDeviceSignal = [RACSubject subject];
    self.num = 0;
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
    if (self.num == 0) {
        [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseChooseModel", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doAddDevice {
    [[KinconyDeviceManager sharedManager] addDevice:self.num withIp:self.ip withPort:[self.port integerValue]];
    [self.addDeviceSignal sendNext:@""];
}

@end
