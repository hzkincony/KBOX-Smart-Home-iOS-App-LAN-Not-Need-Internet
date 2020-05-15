//
//  DeviceEditVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyRelay.h"
#import "DeviceImageChooseVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceEditVM : GLViewModel

@property (nonatomic, strong) KinconyDeviceRLMObject *device;
@property (nonatomic, strong) RACSubject *editDeviceSignal;
@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) NSString *deviceName;

- (void)getData;
- (BOOL)isValidInput;
- (void)editDevice;
- (DeviceImageChooseVM*)getDeviceImageChooseVM;

@end

NS_ASSUME_NONNULL_END
