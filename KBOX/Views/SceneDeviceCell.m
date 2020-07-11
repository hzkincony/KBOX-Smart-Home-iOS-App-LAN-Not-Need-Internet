//
//  SceneDeviceCell.m
//  KBOX
//
//  Created by gulu on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneDeviceCell.h"

@interface SceneDeviceCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;

@end

@implementation SceneDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(SceneDeviceCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = [RACObserve(self.viewModel, deviceImage) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.deviceNameLabel, text) = [RACObserve(self.viewModel, deviceName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.viewModel, deviceOn) = [self.deviceSwitch.rac_newOnChannel takeUntil:self.rac_prepareForReuseSignal];
    [RACObserve(self.viewModel, deviceOn) subscribeNext:^(id  _Nullable x) {
        [self.deviceSwitch setOn:[x boolValue]];
    }];
    
    @weakify(self);
    [RACObserve(self.viewModel, deviceOn) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL on = [x boolValue];
        [self.deviceSwitch setOn:on animated:YES];
    }];
}

@end
