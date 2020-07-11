//
//  DeviceListVM.h
//  KBOX
//
//  Created by gulu on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLViewModel.h"
#import "HomeSeceneControlCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListVM : GLViewModel

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) RACSubject *getDevicesSignal;
@property (nonatomic, strong) RACSubject *getDevicesStateSignal;
@property (nonatomic, strong) RACSubject *getSeceneSignal;
@property (nonatomic, strong) NSMutableArray *deviceCellVMList;
@property (nonatomic, strong) HomeSeceneControlCellVM *homeSeceneControlCellVM;

- (void)getDevices;
- (void)exchangeDeviceAtIndex:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)searchDevicesState;
- (void)updateSecene;

@end

NS_ASSUME_NONNULL_END
