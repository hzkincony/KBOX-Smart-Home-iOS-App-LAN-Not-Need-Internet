//
//  DeviceListViewController.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/2.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceListViewController.h"
#import "RelayCell.h"
#import "DeviceEditViewController.h"
#import "MJRefresh.h"
#import "JCAlertController.h"

@interface DeviceListViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)eidtBtnAction:(id)sender;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.editButton setTitle:NSLocalizedString(@"editBtn", nil)];
    self.title = NSLocalizedString(@"tabbarDevices", nil);
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.viewModel searchDevicesState];
    }];
    
    [self initialzieModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel getDevices];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.deviceCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RelayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelayCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.deviceCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"sceneCellEdit", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        RelayCellVM *cellVM = [self.viewModel.deviceCellVMList objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"ShowDeviceEditVCSegue" sender:[cellVM getDeviceEditVM]];
    }];
    
    return @[action];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.viewModel exchangeDeviceAtIndex:sourceIndexPath toIndexPath:destinationIndexPath];
    [self.viewModel getDevices];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDeviceEditVCSegue"]) {
        DeviceEditViewController *deviceEditViewController = [segue destinationViewController];
        deviceEditViewController.viewModel = sender;
    }
}

#pragma mark - actions

- (IBAction)eidtBtnAction:(id)sender {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [self.editButton setTitle:NSLocalizedString(@"doneBtn", nil)];
    } else {
        [self.editButton setTitle:NSLocalizedString(@"editBtn", nil)];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    
    [self.viewModel.getDevicesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.tableView reloadData];
            [self.viewModel searchDevicesState];
        }
    }];
    
    [self.viewModel.getDevicesStateSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - getters and setters

- (DeviceListVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[DeviceListVM alloc] init];
    }
    return _viewModel;
}

@end
