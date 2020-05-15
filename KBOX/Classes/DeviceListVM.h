//
//  DeviceListVM.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListVM : GLViewModel

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) RACSubject *addDeviceSignal;
@property (nonatomic, strong) RACSubject *getDevicesSignal;
@property (nonatomic, strong) RACSubject *getDevicesStateSignal;
@property (nonatomic, strong) NSMutableArray *deviceCellVMList;

- (void)addDevice;
- (void)getDevices;
- (void)exchangeDeviceAtIndex:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)searchDevicesState;

@end

NS_ASSUME_NONNULL_END
