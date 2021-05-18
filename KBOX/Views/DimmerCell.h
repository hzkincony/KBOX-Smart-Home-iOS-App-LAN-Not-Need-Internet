//
//  DimmerCell.h
//  KBOX
//
//  Created by gulu on 2021/5/14.
//  Copyright © 2021 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DimmerCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DimmerCell : UITableViewCell

@property (nonatomic, strong) DimmerCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
