//
//  DeviceManagerViewController.m
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "DeviceManagerCell.h"

@interface DeviceManagerViewController ()

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    
    self.title = NSLocalizedString(@"devicesListTitle", nil);
    [self.viewModel getConnectDevices];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.deviceManagerCellVMList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceManagerCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.deviceManagerCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceManagerCellVM *deviceManagerCellVM = [self.viewModel.deviceManagerCellVMList objectAtIndex:indexPath.row];
    [deviceManagerCellVM deleteDevice];
    [self.viewModel getConnectDevices];
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
    @weakify(self);
    [self.viewModel.getConnectDevicesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - setters and getters

- (DeviceManagerVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[DeviceManagerVM alloc] init];
    }
    return _viewModel;
}

@end
