//
//  DeviceEditVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceEditVM.h"

@interface DeviceEditVM()<DeviceImageChooseVMDelegate>

@property (nonatomic, strong) KinconyRelay *kinconyRelay;
@property (nonatomic, strong) NSString *imageName;

@end

@implementation DeviceEditVM

- (void)initializeData {
    self.editDeviceSignal = [RACSubject subject];
};

#pragma mark - DeviceImageChooseVMDelegate

- (void)choosedImageName:(NSString *)imageName {
    self.imageName = imageName;
    self.deviceImage = [UIImage imageNamed:self.imageName];
}

#pragma mark - public methods

- (void)getData {
    self.deviceImage = [UIImage imageNamed:self.device.image];
    self.deviceName = self.device.name;
    self.imageName = self.device.image;
}

- (BOOL)isValidInput {
    if (self.deviceName.length == 0) {
        [self.editDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"noNameHudMsg", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)editDevice {
    [self.kinconyRelay editDevice:self.device name:self.deviceName deviceImageName:self.imageName];
    [self.editDeviceSignal sendNext:@""];
}

- (DeviceImageChooseVM*)getDeviceImageChooseVM {
    DeviceImageChooseVM *deviceImageChooseVM = [[DeviceImageChooseVM alloc] init];
    deviceImageChooseVM.delegate = self;
    return deviceImageChooseVM;
}

#pragma mark - setters and getters

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

@end
