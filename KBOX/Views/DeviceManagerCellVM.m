//
//  DeviceManagerCellVM.m
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceManagerCellVM.h"
#import "KinconyRelay.h"

@interface DeviceManagerCellVM()

@property (nonatomic, strong) KinconyDevice *device;
@property (nonatomic, strong) KinconyRelay *kinconyRelay;

@end

@implementation DeviceManagerCellVM

- (id)initWithDevice:(KinconyDevice*)device {
    if ((self = [super init])) {
        self.device = device;
        [self getData];
    }
    return self;
}

#pragma mark - public methods

- (void)deleteDevice {
    [self.kinconyRelay deleteDevice:self.device];
}

#pragma mark - private methods

- (void)getData {
    self.ip = [NSString stringWithFormat:@"IP:%@", self.device.ipAddress];
    self.port = [NSString stringWithFormat:@"Port:%ld", (long)self.device.port];
}

#pragma mark - setters and getters

- (KinconyRelay*)kinconyRelay {
    if (_kinconyRelay == nil) {
        self.kinconyRelay = [[KinconyRelay alloc] init];
    }
    return _kinconyRelay;
}

@end
