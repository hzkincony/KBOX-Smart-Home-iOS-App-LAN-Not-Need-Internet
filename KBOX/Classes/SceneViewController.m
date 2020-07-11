//
//  SceneViewController.m
//  KBOX
//
//  Created by gulu on 2019/4/17.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SceneViewController.h"
#import "SceneEditViewController.h"
#import "SceneCell.h"

@interface SceneViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tabbarScene", nil);
    
    [self initialzieModel];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel getScenes];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sceneCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneCell" forIndexPath:indexPath];
    
    cell.viewModel = [self.viewModel.sceneCellVMList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.viewModel commandScene:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"sceneCellEdit", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self performSegueWithIdentifier:@"ShowSceneEditSegue" sender:[self.viewModel getEditSceneEditVM:indexPath.row]];
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"sceneCellDelete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.viewModel deleteScene:indexPath.row];
    }];
    
    return @[action1, action0];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSceneEditSegue"]) {
        SceneEditViewController *sceneEditViewController = [segue destinationViewController];
        sceneEditViewController.viewModel = sender;
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    self.addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self performSegueWithIdentifier:@"ShowSceneEditSegue" sender:[self.viewModel getAddSceneEditVM]];
        return [RACSignal empty];
    }];
    
    [self.viewModel.getScenesSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - setters and getters

- (SceneVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[SceneVM alloc] init];
    }
    return _viewModel;
}

@end
