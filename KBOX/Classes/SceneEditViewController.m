//
//  SceneEditViewController.m
//  KBOX
//
//  Created by gulu on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneEditViewController.h"
#import "ChooseSceneDeviceViewController.h"
#import "SceneDeviceCell.h"
#import "DeviceImageChooseViewController.h"

@interface SceneEditViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseDeviceButton;
@property (weak, nonatomic) IBOutlet UIView *chooseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sceneImage;
@property (weak, nonatomic) IBOutlet UILabel *sceneIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlModeTitle;
@property (weak, nonatomic) IBOutlet UILabel *controlModeLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseControlModeView;

@end

@implementation SceneEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.placeholder = NSLocalizedString(@"sceneEditNameInput", nil);
    [self.chooseDeviceButton setTitle:NSLocalizedString(@"sceneEditChooseDeviceBtn", nil) forState:(UIControlStateNormal)];
    
    self.nameTextField.text = self.viewModel.name;
    self.sceneIconLabel.text = NSLocalizedString(@"Icon", nil);
    self.controlModeTitle.text = NSLocalizedString(@"ControlModel", nil);
    [self initialzieModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel getSceneDevices];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sceneDeviceCellVMList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneDeviceCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.sceneDeviceCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel deleteSceneDevice:indexPath.row];
    [self.viewModel getSceneDevices];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChooseSceneDeviceSegue"]) {
        ChooseSceneDeviceViewController *chooseSceneDeviceViewController = [segue destinationViewController];
        chooseSceneDeviceViewController.viewModel = [self.viewModel getChooseSceneDeviceVM];
    } else if ([segue.identifier isEqualToString:@"ShowSceneImageChooseSegue"]) {
        DeviceImageChooseViewController *deviceImageChooseViewController = [segue destinationViewController];
        deviceImageChooseViewController.viewModel = self.viewModel.deviceImageChooseVM;
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self, title) = RACObserve(self.viewModel, title);
    RAC(self.viewModel, name) = self.nameTextField.rac_textSignal;
    RAC(self.sceneImage, image) = RACObserve(self.viewModel, sceneImage);
    @weakify(self);
    [RACObserve(self.viewModel, controlModel) subscribeNext:^(id  _Nullable x) {
        if ([x isEqualToNumber:@1]) {
            self.controlModeLabel.text = NSLocalizedString(@"Touch", nil);
        } else {
            self.controlModeLabel.text = NSLocalizedString(@"Click", nil);
        }
    }];
    
    self.chooseImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        @strongify(self);
        [self performSegueWithIdentifier:@"ShowSceneImageChooseSegue" sender:nil];
    }];
    [self.chooseImageView addGestureRecognizer:tap];
    
    self.chooseControlModeView.userInteractionEnabled = YES;
    UITapGestureRecognizer * controlModeTap = [[UITapGestureRecognizer alloc] init];
    [[controlModeTap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * controlModeTap) {
        @strongify(self);
        [self showControlModelChooseAlert];
    }];
    [self.chooseControlModeView addGestureRecognizer:controlModeTap];
    
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self.viewModel saveScene];
        }
        return [RACSignal empty];
    }];
    
    [self.viewModel.saveSceneSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.viewModel.getSceneDevicesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
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

#pragma mark - setters and getters

- (SceneEditVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[SceneEditVM alloc] init];
    }
    return _viewModel;
}

@end
