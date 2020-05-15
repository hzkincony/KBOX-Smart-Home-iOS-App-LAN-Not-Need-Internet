//
//  DeviceManagerCell.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceManagerCell.h"

@interface DeviceManagerCell()

@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;

@end

@implementation DeviceManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(DeviceManagerCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.ipLabel, text) = [RACObserve(self.viewModel, ip) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.portLabel, text) = [RACObserve(self.viewModel, port) takeUntil:self.rac_prepareForReuseSignal];
}

@end
