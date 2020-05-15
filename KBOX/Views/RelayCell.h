//
//  RelayCell.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelayCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelayCell : UITableViewCell

@property (nonatomic, strong) RelayCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
