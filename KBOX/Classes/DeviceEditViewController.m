//
//  DeviceEditViewController.m
//  KBOX
//
//  Created by gulu on 2019/4/8.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceEditViewController.h"
#import "DeviceImageChooseViewController.h"

@interface DeviceEditViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceTouchImageView;
@property (weak, nonatomic) IBOutlet UILabel *controlModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation DeviceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"editTitle", nil);
    
    [self initialzieModel];
    
    [self.viewModel getData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowImageChooseSegue"]) {
        DeviceImageChooseViewController *deviceImageChooseViewController = [segue destinationViewController];
        deviceImageChooseViewController.viewModel = [self.viewModel getDeviceImageChooseVM];
    } else if ([segue.identifier isEqualToString:@"ShowTouchImageChooseSegue"]) {
        DeviceImageChooseViewController *deviceImageChooseViewController = [segue destinationViewController];
        deviceImageChooseViewController.viewModel = [self.viewModel getDeviceTouchImageChooseVM];
    }
}

#pragma mark - UITableViewDelegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header = @"";
    
    if (section == 0) {
        header = NSLocalizedString(@"deviceEditName", nil);
    } else if (section == 1) {
        header = NSLocalizedString(@"deviceEditIcon", nil);
    } else if (section == 2) {
        header = NSLocalizedString(@"ControlModel", nil);
    } else if (section == 3) {
        header = NSLocalizedString(@"TouchIcon", nil);
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self showControlModelChooseAlert];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.deviceImageView, image) = RACObserve(self.viewModel, deviceImage);
    RAC(self.deviceTouchImageView, image) = RACObserve(self.viewModel, deviceTouchImage);
    RAC(self.deviceNameTextField, text) = RACObserve(self.viewModel, deviceName);
    
    @weakify(self);
    [RACObserve(self.viewModel, controlModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger controlModel = [x integerValue];
        if (controlModel == 1) {
            self.controlModelLabel.text = NSLocalizedString(@"Touch", nil);
        } else {
            self.controlModelLabel.text = NSLocalizedString(@"Click", nil);
        }
    }];
    
    self.doneButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        self.viewModel.deviceName = self.deviceNameTextField.text;
        if ([self.viewModel isValidInput]) {
            [self.viewModel editDevice];
        }
        return [RACSignal empty];
    }];
    
    [self.viewModel.editDeviceSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)showControlModelChooseAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *clickAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Click", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.controlModel = @0;
    }];
    [alertController addAction:clickAction];
    
    UIAlertAction *touchAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Touch", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.controlModel = @1;
    }];
    [alertController addAction:touchAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - getters and setters

- (DeviceEditVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[DeviceEditVM alloc] init];
    }
    return _viewModel;
}

@end
