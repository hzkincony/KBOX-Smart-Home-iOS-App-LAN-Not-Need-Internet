//
//  DeviceListViewController.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "DeviceListVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListViewController : GLBaseTableViewController

@property (nonatomic, strong) DeviceListVM *viewModel;

@end

NS_ASSUME_NONNULL_END
