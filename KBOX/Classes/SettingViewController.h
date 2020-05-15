//
//  SettingViewController.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "SettingVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : GLBaseTableViewController

@property (nonatomic, strong) SettingVM *viewModel;

@end

NS_ASSUME_NONNULL_END
