//
//  RelayCellVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyRelay.h"
#import "DeviceEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelayCellVM : GLViewModel

@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *deviceOn;

- (id)initWithDevice:(KinconyDeviceRLMObject*)device;
- (KinconyDeviceRLMObject*)getDevice;
- (void)changeDeviceState:(BOOL)on;
- (DeviceEditVM*)getDeviceEditVM;

@end

NS_ASSUME_NONNULL_END
