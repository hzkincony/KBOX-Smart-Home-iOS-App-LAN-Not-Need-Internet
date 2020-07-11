//
//  SceneViewController.h
//  KBOX
//
//  Created by gulu on 2019/4/17.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "SceneVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneViewController : GLBaseTableViewController

@property (nonatomic, strong) SceneVM *viewModel;

@end

NS_ASSUME_NONNULL_END
