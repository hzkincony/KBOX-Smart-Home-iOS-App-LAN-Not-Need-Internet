//
//  DeviceManagerViewController.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "DeviceManagerVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceManagerViewController : GLBaseTableViewController

@property (nonatomic, strong) DeviceManagerVM *viewModel;

@end

NS_ASSUME_NONNULL_END
