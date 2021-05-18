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

@end

@implementation DimmerCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
