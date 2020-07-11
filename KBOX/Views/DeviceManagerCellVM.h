//
//  DeviceManagerCellVM.h
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "KinconyDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceManagerCellVM : GLViewModel

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *port;

- (id)initWithDevice:(KinconyDevice*)device;
- (void)deleteDevice;

@end

NS_ASSUME_NONNULL_END
