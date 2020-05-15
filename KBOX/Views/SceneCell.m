//
//  SceneCell.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/19.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneCell.h"

@interface SceneCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SceneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(SceneCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.nameLabel, text) = [RACObserve(self.viewModel, name) takeUntil:self.rac_prepareForReuseSignal];
}

@end
