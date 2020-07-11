//
//  DeviceImageChooseViewController.h
//  KBOX
//
//  Created by gulu on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceImageChooseVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceImageChooseViewController : UICollectionViewController

@property (nonatomic, strong) DeviceImageChooseVM *viewModel;

@end

NS_ASSUME_NONNULL_END
