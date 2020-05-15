//
//  DeviceManagerVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "DeviceManagerCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceManagerVM : GLViewModel

@property (nonatomic, strong) NSMutableArray *deviceManagerCellVMList;
@property (nonatomic, strong) RACSubject *getConnectDevicesSignal;

- (void)getConnectDevices;

@end

NS_ASSUME_NONNULL_END
