//
//  RelayCell.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/4.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "RelayCell.h"

@interface RelayCell()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;

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
    
//    @weakify(self);
//    [RACObserve(self.viewModel, deviceOn) subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        BOOL on = [x boolValue];
//        [self.deviceSwitch setOn:on animated:YES];
////        [self reloadTableView];
////        [self reloadInputViews];
//    }];
}

- (void)getData {
    [self.deviceSwitch setOn:[self.viewModel.deviceOn boolValue] animated:YES];
}

//- (void)reloadTableView {
//    id view = [self superview];
//    while (view && ![view isKindOfClass:[UITableView class]]) {
//        view = [view superview];
//    }
//
//    UITableView *tableView = view;
//    [tableView reloadData];
//}

@end
