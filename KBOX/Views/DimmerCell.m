//
//  DimmerCell.m
//  KBOX
//
//  Created by gulu on 2021/5/14.
//  Copyright © 2021 kincony. All rights reserved.
//

#import "DimmerCell.h"

@interface DimmerCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISlider *deviceSlider;
@property (weak, nonatomic) IBOutlet UIView *touchView;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderTouchUpInside:(id)sender;
- (IBAction)sliderTouchUpOutside:(id)sender;

@end

@implementation DimmerCell {
    float _tempValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.touchView addGestureRecognizer:lpgr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(DimmerCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
    
    [self getData];
}

#pragma mark - actions

- (IBAction)sliderTouchUpOutside:(id)sender {
    [self.viewModel changeDeviceValue:(NSInteger)self.deviceSlider.value];
}

- (IBAction)sliderTouchUpInside:(id)sender {
    [self.viewModel changeDeviceValue:(NSInteger)self.deviceSlider.value];
}

- (IBAction)sliderValueChanged:(id)sender {
    if (fabsf(self.deviceSlider.value - _tempValue) > 5) {
        _tempValue = self.deviceSlider.value;
        [self.viewModel changeDeviceValue:(NSInteger)_tempValue];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(dimmerCellNeedEdit:)]) {
        [self.delegate dimmerCellNeedEdit:self.viewModel];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = [RACObserve(self.viewModel, deviceImage) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.deviceNameLabel, text) = [RACObserve(self.viewModel, deviceName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.viewModel, deviceSliderValue) = [[self.deviceSlider rac_newValueChannelWithNilValue:nil] takeUntil:self.rac_prepareForReuseSignal];
}

- (void)getData {
    [self.deviceSlider setValue:[self.viewModel.deviceSliderValue floatValue] animated:YES];
}

@end
