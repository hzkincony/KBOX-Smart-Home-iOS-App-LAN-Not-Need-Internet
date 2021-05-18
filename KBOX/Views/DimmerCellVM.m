//
//  DimmerCellVM.m
//  KBOX
//
//  Created by gulu on 2021/5/14.
//  Copyright © 2021 kincony. All rights reserved.
//

#import "DimmerCellVM.h"

@interface DimmerCellVM()

@property (nonatomic, strong) KinconyDeviceRLMObject *device;

@end

@implementation DimmerCellVM

- (id)initWithDevice:(KinconyDeviceRLMObject*)device {
    if ((self = [super init])) {
        self.device = device;
        [self getData];
        [RACObserve(self, deviceSliderValue) subscribeNext:^(id  _Nullable x) {
            [[KinconyRelay sharedManager] changeDeviceValue:[x integerValue] device:self.device];
        }];
    }
    return self;
}

#pragma mark - public methods

- (KinconyDeviceRLMObject*)getDevice {
    return self.device;
}

- (DeviceEditVM*)getDeviceEditVM {
    DeviceEditVM *devcieEditVM = [[DeviceEditVM alloc] init];
    devcieEditVM.device = self.device;
    return devcieEditVM;
}

#pragma mark - private methods

- (void)getData {
    self.deviceImage = [UIImage imageNamed:self.device.image];
    self.deviceName = self.device.name;
}

@end
