//
//  SceneDeviceChooseCell.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneDeviceChooseCell.h"

@interface SceneDeviceChooseCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@end

@implementation SceneDeviceChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(SceneDeviceChooseCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = [RACObserve(self.viewModel, deviceImage) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.deviceNameLabel, text) = [RACObserve(self.viewModel, deviceName) takeUntil:self.rac_prepareForReuseSignal];
}

@end
