//
//  RelayCellVM.m
//  KBOX
//
//  Created by gulu on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "RelayCellVM.h"
#import "KinconyRelay.h"

@interface RelayCellVM()

@property (nonatomic, strong) KinconyDeviceRLMObject *device;
//@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation RelayCellVM

- (id)initWithDevice:(KinconyDeviceRLMObject*)device {
    if ((self = [super init])) {
        self.device = device;
        [self getData];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateNotification:) name:KinconyDeviceStateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"------");
}

#pragma mark - Notifications

- (void)deviceStateNotification:(NSNotification*)notification {
    NSArray *stateArray = [notification.userInfo objectForKey:@"stateArray"];
    if ([self.device.num integerValue] < stateArray.count) {
        KinconyDeviceState *deviceState = [stateArray objectAtIndex:[self.device.num integerValue] - 1];
        if ([self.device.ipAddress isEqualToString:deviceState.ipAddress] && self.device.port == deviceState.port) {
            self.deviceOn = [NSNumber numberWithInteger:deviceState.state];
        }
    }
}

#pragma mark - public methods

- (void)changeDeviceState:(BOOL)on {
    [[KinconyRelay sharedManager] changeDeviceState:on device:self.device];
    self.deviceOn = [NSNumber numberWithBool:on];
}

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
    self.deviceTouchImage = [UIImage imageNamed:self.device.touchImage];
    self.deviceName = self.device.name;
    self.controlModel = [NSNumber numberWithInteger:self.device.controlModel];
}

#pragma mark - setters and getters

//- (KinconyRelay*)kinconyRelay {
//    if (_kinconyRelay == nil) {
//        self.kinconyRelay = [[KinconyRelay alloc] init];
//    }
//    return _kinconyRelay;
//}

@end
