//
//  SceneCell.h
//  KBOX
//
//  Created by 顾越超 on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneCell : UITableViewCell

@property (nonatomic, strong) SceneCellVM *viewModel;

@end

NS_ASSUME_NONNULL_END
