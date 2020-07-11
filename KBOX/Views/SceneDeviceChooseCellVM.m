//
//  SceneDeviceChooseCellVM.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneDeviceChooseCellVM.h"

@interface SceneDeviceChooseCellVM()

@property (nonatomic, strong) KinconyDeviceRLMObject *device;

@end

@implementation SceneDeviceChooseCellVM

- (id)initWithDevice:(KinconyDeviceRLMObject*)device {
    if ((self = [super init])) {
        self.device = device;
        [self getData];
    }
    return self;
}

- (KinconyDeviceRLMObject*)getDevice {
    return self.device;
}

#pragma mark - private methods

- (void)getData {
    self.deviceImage = [UIImage imageNamed:self.device.image];
    self.deviceName = self.device.name;
}

@end
