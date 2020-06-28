//
//  DeviceAddViewController.m
//  KBOX
//
//  Created by 顾越超 on 2020/6/23.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "DeviceAddViewController.h"

@interface DeviceAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@end

@implementation DeviceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    [self setupViews];
    self.modelLabel.text = @" ";
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self showChooseModelAlert];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - actions

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.viewModel, ip) = self.ipTextField.rac_textSignal;
    RAC(self.viewModel, port) = self.portTextField.rac_textSignal;
    
    @weakify(self);
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:nil];
            [self.viewModel doAddDevice];
        }
        return [RACSignal empty];
    }];
    
    [self.viewModel.addDeviceSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setupViews {
    self.ipTextField.placeholder = NSLocalizedString(@"inputAddressPlaceholder", nil);
    self.portTextField.placeholder = NSLocalizedString(@"inputPortPlaceholder", nil);
}

- (void)showChooseModelAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"2 Channel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.modelLabel.text = @"2 Channel";
        self.viewModel.num = 2;
    }];
    UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"4 Channel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.modelLabel.text = @"4 Channel";
        self.viewModel.num = 4;
    }];
    UIAlertAction *alertAction8 = [UIAlertAction actionWithTitle:@"8 Channel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.modelLabel.text = @"8 Channel";
        self.viewModel.num = 8;
    }];
    UIAlertAction *alertAction16 = [UIAlertAction actionWithTitle:@"16 Channel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.modelLabel.text = @"16 Channel";
        self.viewModel.num = 16;
    }];
    UIAlertAction *alertAction32 = [UIAlertAction actionWithTitle:@"32 Channel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.modelLabel.text = @"32 Channel";
        self.viewModel.num = 32;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction4];
    [alertController addAction:alertAction8];
    [alertController addAction:alertAction16];
    [alertController addAction:alertAction32];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - setters and getters

- (DeviceAddVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[DeviceAddVM alloc] init];
    }
    return _viewModel;
}

@end
