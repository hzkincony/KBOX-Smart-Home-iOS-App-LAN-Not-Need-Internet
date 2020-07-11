//
//  DeviceEditViewController.h
//  KBOX
//
//  Created by gulu on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "DeviceEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceEditViewController : GLBaseTableViewController

@property (nonatomic, strong) DeviceEditVM *viewModel;

@end

NS_ASSUME_NONNULL_END
