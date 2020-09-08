//
//  ServerConfigViewController.h
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "ServerConfigVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerConfigViewController : GLBaseTableViewController

@property (nonatomic, strong) ServerConfigVM *viewModel;

@end

NS_ASSUME_NONNULL_END
