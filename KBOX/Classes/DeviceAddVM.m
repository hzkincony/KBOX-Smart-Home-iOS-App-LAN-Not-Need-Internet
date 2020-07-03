//
//  DeviceAddVM.m
//  KBOX
//
//  Created by 顾越超 on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "DeviceAddVM.h"
#import "KinconyDeviceManager.h"
#import "KinconyRelay.h"

@interface DeviceAddVM()

@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

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
    @weakify(self);
    [self.kinconyRelay addDevice:self.ip withPort:[self.port integerValue] withNum:self.num withBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        if (error.code == DeviceAddErrorCode_AlreadyExists) {
            [self.addDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"deviceAlreadyExists", nil) code:1 userInfo:nil]];
        } else {
            [self.addDeviceSignal sendNext:nil];
        }
    }];
}

#pragma mark - setters and getters

- (KinconyRelay *)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

@end
