//
//  DimmerCellVM.h
//  KBOX
//
//  Created by gulu on 2021/5/14.
//  Copyright © 2021 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyRelay.h"
#import "DeviceEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DimmerCellVM : GLViewModel

@property (nonatomic, strong) UIImage *deviceImage;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *deviceSliderValue;

- (id)initWithDevice:(KinconyDeviceRLMObject*)device;
- (KinconyDeviceRLMObject*)getDevice;
- (DeviceEditVM*)getDeviceEditVM;

@end

NS_ASSUME_NONNULL_END
