//
//  DeviceAddViewController.h
//  KBOX
//
//  Created by gulu on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "DeviceAddVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceAddViewController : GLBaseTableViewController

@property (nonatomic, strong) DeviceAddVM *viewModel;

@end

NS_ASSUME_NONNULL_END
