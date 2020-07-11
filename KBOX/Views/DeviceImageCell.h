//
//  DeviceImageCell.h
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceImageCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceImageCell : UICollectionViewCell

@property (nonatomic, strong) DeviceImageCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
