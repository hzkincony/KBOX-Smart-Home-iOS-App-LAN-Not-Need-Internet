//
//  HomeSecneControlCell.m
//  KBOX
//
//  Created by gulu on 2020/7/11.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "HomeSecneControlCell.h"
#import "UIButton+MCLayout.h"
#import "KinconySceneRLMObject.h"

@interface HomeSecneControlCell()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HomeSecneControlCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - private methods

- (void)updateSeceneBtns {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 10;
    CGFloat width = 70;
    for (KinconySceneRLMObject *scene in self.viewModel.scenes) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, 85)];
        [button setTitle:scene.name forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:scene.image] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button layoutWithStatus:MCLayoutStatusImageTop andMargin:0];
        @weakify(self);
        [[button rac_signalForControlEvents:(UIControlEventTouchDown)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.viewModel scenesBtnTouchDown:scene];
        }];
        [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.viewModel scenesBtnTouchUp:scene];
        }];
        [self.scrollView addSubview:button];
        x = x + width + 10;
    }
    self.scrollView.contentSize = CGSizeMake(self.viewModel.scenes.count * (width + 10) + 10, self.frame.size.height);
}

#pragma mark - setters and getters

- (void)setViewModel:(HomeSeceneControlCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    [self updateSeceneBtns];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end
