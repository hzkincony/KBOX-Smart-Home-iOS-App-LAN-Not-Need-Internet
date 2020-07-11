//
//  RelayCellVM.h
//  KBOX
//
//  Created by gulu on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyRelay.h"
#import "DeviceEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelayCellVM : GLViewModel

@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) UIImage *deviceTouchImage;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *deviceOn;
@property (nonatomic, strong) NSNumber *controlModel;

- (id)initWithDevice:(KinconyDeviceRLMObject*)device;
- (KinconyDeviceRLMObject*)getDevice;
- (void)changeDeviceState:(BOOL)on;
- (DeviceEditVM*)getDeviceEditVM;

@end

NS_ASSUME_NONNULL_END
