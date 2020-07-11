//
//  SceneEditViewController.h
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "SceneEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneEditViewController : GLBaseTableViewController

@property (nonatomic, strong) SceneEditVM *viewModel;

@end

NS_ASSUME_NONNULL_END
