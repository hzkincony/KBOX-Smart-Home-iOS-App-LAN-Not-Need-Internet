//
//  DeviceEditVM.m
//  KBOX
//
//  Created by gulu on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceEditVM.h"

@interface DeviceEditVM()<DeviceImageChooseVMDelegate>

@property (nonatomic, strong) KinconyRelay *kinconyRelay;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *touchImageName;

@end

@implementation DeviceEditVM

- (void)initializeData {
    self.editDeviceSignal = [RACSubject subject];
};

#pragma mark - DeviceImageChooseVMDelegate

- (void)choosedImageName:(NSString *)imageName chooseType:(DeviceImageChooseVMType)chooseType {
    if (chooseType == ChooseTypeDevice) {
        self.imageName = imageName;
        self.deviceImage = [UIImage imageNamed:self.imageName];
    } else {
        self.touchImageName = imageName;
        self.deviceTouchImage = [UIImage imageNamed:self.touchImageName];
    }
}

#pragma mark - public methods

- (void)getData {
    self.deviceImage = [UIImage imageNamed:self.device.image];
    self.deviceTouchImage = [UIImage imageNamed:self.device.touchImage];
    self.deviceName = self.device.name;
    self.imageName = self.device.image;
    self.touchImageName = self.device.touchImage;
    self.controlModel = [NSNumber numberWithInteger:self.device.controlModel];
}

- (BOOL)isValidInput {
    if (self.deviceName.length == 0) {
        [self.editDeviceSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"noNameHudMsg", nil) code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)editDevice {
    [self.kinconyRelay editDevice:self.device name:self.deviceName deviceImageName:self.imageName deviceTouchImageName:self.touchImageName controlMode:self.controlModel.integerValue];
    [self.editDeviceSignal sendNext:@""];
}

- (DeviceImageChooseVM*)getDeviceImageChooseVM {
    DeviceImageChooseVM *deviceImageChooseVM = [[DeviceImageChooseVM alloc] init];
    deviceImageChooseVM.delegate = self;
    deviceImageChooseVM.chooseType = ChooseTypeDevice;
    return deviceImageChooseVM;
}

- (DeviceImageChooseVM*)getDeviceTouchImageChooseVM {
    DeviceImageChooseVM *deviceImageChooseVM = [[DeviceImageChooseVM alloc] init];
    deviceImageChooseVM.delegate = self;
    deviceImageChooseVM.chooseType = ChooseTypeTouch;
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
