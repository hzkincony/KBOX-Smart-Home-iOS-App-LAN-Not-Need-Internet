//
//  SceneEditViewController.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneEditViewController.h"
#import "ChooseSceneDeviceViewController.h"
#import "SceneDeviceCell.h"

@interface SceneEditViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseDeviceButton;

@end

@implementation SceneEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.placeholder = NSLocalizedString(@"sceneEditNameInput", nil);
    [self.chooseDeviceButton setTitle:NSLocalizedString(@"sceneEditChooseDeviceBtn", nil) forState:(UIControlStateNormal)];
    
    self.nameTextField.text = self.viewModel.name;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChooseSceneDeviceSegue"]) {
        ChooseSceneDeviceViewController *chooseSceneDeviceViewController = [segue destinationViewController];
        chooseSceneDeviceViewController.viewModel = [self.viewModel getChooseSceneDeviceVM];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self, title) = RACObserve(self.viewModel, title);
    RAC(self.viewModel, name) = self.nameTextField.rac_textSignal;
    
    @weakify(self);
    [self.viewModel.getSceneDevicesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
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
}

#pragma mark - setters and getters

- (SceneEditVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[SceneEditVM alloc] init];
    }
    return _viewModel;
}

@end
