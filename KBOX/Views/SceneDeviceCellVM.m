//
//  SceneDeviceCellVM.m
//  KBOX
//
//  Created by gulu on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneDeviceCellVM.h"

@interface SceneDeviceCellVM()

@property (nonatomic, strong) KinconySceneDeviceRLMObject *device;

@end

@implementation SceneDeviceCellVM

- (id)initWithDevice:(KinconySceneDeviceRLMObject*)device {
    if ((self = [super init])) {
        self.device = device;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.deviceImage = [UIImage imageNamed:self.device.device.image];
    self.deviceName = self.device.device.name;
    self.deviceOn = [NSNumber numberWithInteger:self.device.state];
}

#pragma mark - setters and getters

- (void)setDeviceOn:(NSNumber *)deviceOn {
    _deviceOn = deviceOn;
    self.device.state = deviceOn.integerValue;
}

@end
