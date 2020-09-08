//
//  ServerConfigViewController.m
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "ServerConfigViewController.h"

@interface ServerConfigViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ipTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *portTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;

@end

@implementation ServerConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupViews];
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

- (void)setupNavigation {
    self.title = NSLocalizedString(@"serverConfigLabel", nil);
}

- (void)setupViews {
    self.ipTitleLabel.text = NSLocalizedString(@"ipAddress", nil);
    self.portTitleLabel.text = NSLocalizedString(@"port", nil);
    self.ipTextField.placeholder = NSLocalizedString(@"pleaseInputIP", nil);
    self.portTextField.placeholder = NSLocalizedString(@"pleaseInputPort", nil);
    self.ipTextField.text = self.viewModel.ipAddress;
    self.portTextField.text = self.viewModel.port;
}

- (void)initialzieModel {
    RAC(self.viewModel, ipAddress) = self.ipTextField.rac_textSignal;
    RAC(self.viewModel, port) = self.portTextField.rac_textSignal;
    
    @weakify(self);
    self.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel saveServerConfig];
        return [RACSignal empty];
    }];
    
    [self.viewModel.saveServerConfigSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - setters and getters

- (ServerConfigVM *)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[ServerConfigVM alloc] init];
    }
    return _viewModel;
}

@end
