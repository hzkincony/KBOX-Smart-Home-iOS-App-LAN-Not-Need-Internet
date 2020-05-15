//
//  DeviceImageCell.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceImageCell.h"

@interface DeviceImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;

@end

@implementation DeviceImageCell

- (void)setViewModel:(DeviceImageCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = [RACObserve(self.viewModel, image) takeUntil:self.rac_prepareForReuseSignal];
}

@end
