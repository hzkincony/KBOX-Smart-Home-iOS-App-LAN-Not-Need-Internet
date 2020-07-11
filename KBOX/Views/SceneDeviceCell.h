//
//  SceneDeviceCell.h
//  KBOX
//
//  Created by gulu on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDeviceCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneDeviceCell : UITableViewCell

@property (nonatomic, strong) SceneDeviceCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
