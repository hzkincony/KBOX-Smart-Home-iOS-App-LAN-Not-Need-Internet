//
//  DeviceAddVM.h
//  KBOX
//
//  Created by gulu on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceAddVM : GLViewModel

@property (nonatomic, strong) RACSubject *addDeviceSignal;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, assign) NSInteger num;

- (BOOL)isValidInput;
- (void)doAddDevice;

@end

NS_ASSUME_NONNULL_END
