//
//  SettingViewController.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionCellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tabbarSetting", nil);
    self.deviceCellTitleLabel.text = NSLocalizedString(@"settingDevices", nil);
    self.versionCellTitleLabel.text = NSLocalizedString(@"settingVersionCellTitle", nil);
    
    [self initialzieModel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.versionLabel, text) = RACObserve(self.viewModel, version);
}

#pragma mark - setters and getters

- (SettingVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[SettingVM alloc] init];
    }
    return _viewModel;
}

@end
