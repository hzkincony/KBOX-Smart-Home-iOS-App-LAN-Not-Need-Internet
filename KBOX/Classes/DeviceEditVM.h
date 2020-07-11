//
//  DeviceEditVM.h
//  KBOX
//
//  Created by gulu on 2019/4/8.
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
@property (nonatomic, strong) UIImage *deviceTouchImage;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *controlModel;                   //@0:click   @1:touch

- (void)getData;
- (BOOL)isValidInput;
- (void)editDevice;
- (DeviceImageChooseVM*)getDeviceImageChooseVM;
- (DeviceImageChooseVM*)getDeviceTouchImageChooseVM;

@end

NS_ASSUME_NONNULL_END
