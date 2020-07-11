//
//  DeviceManagerCell.h
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceManagerCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceManagerCell : UITableViewCell

@property (nonatomic, strong) DeviceManagerCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
