//
//  RelayCell.m
//  KBOX
//
//  Created by gulu on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "RelayCell.h"

@interface RelayCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;
@property (weak, nonatomic) IBOutlet UIButton *touchButton;

- (IBAction)deviceSwitchChanged:(id)sender;

@end

@implementation RelayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(RelayCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
    
    [self getData];
}

#pragma mark - actions

- (IBAction)deviceSwitchChanged:(id)sender {
    [self.viewModel changeDeviceState:self.deviceSwitch.isOn];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = [RACObserve(self.viewModel, deviceImage) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.deviceNameLabel, text) = [RACObserve(self.viewModel, deviceName) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self);
    [RACObserve(self.viewModel, deviceTouchImage) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.touchButton setImage:x forState:(UIControlStateNormal)];
    }];
    
    [RACObserve(self.viewModel, controlModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isEqualToNumber:@1]) {
            self.deviceSwitch.hidden = YES;
            self.touchButton.hidden = NO;
        } else {
            self.deviceSwitch.hidden = NO;
            self.touchButton.hidden = YES;
        }
    }];
    
    [[[self.touchButton rac_signalForControlEvents:(UIControlEventTouchDown)] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel changeDeviceState:YES];
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }];
    
    [[[self.touchButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel changeDeviceState:NO];
        self.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)getData {
    [self.deviceSwitch setOn:[self.viewModel.deviceOn boolValue] animated:NO];
}

@end
