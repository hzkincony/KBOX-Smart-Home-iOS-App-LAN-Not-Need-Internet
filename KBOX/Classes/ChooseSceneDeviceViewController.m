//
//  ChooseSceneDeviceViewController.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/18.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "ChooseSceneDeviceViewController.h"
#import "SceneDeviceChooseCell.h"

@interface ChooseSceneDeviceViewController ()

@end

@implementation ChooseSceneDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"chooseDeviceVcTitle", nil);
    
    [self initialzieModel];
    
    [self.viewModel getDevices];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.deviceCellVMList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneDeviceChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneDeviceChooseCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.deviceCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel chooseDevice:indexPath.row];
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
    [self.viewModel.getDevicesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.tableView reloadData];
        }
    }];
    
    [self.viewModel.chooseDeviceSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self showTextHud:x];
        }
    }];
}

#pragma mark - setters and getters

- (ChooseSceneDeviceVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[ChooseSceneDeviceVM alloc] init];
    }
    return _viewModel;
}

@end
