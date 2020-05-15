//
//  BaseTableViewController.m
//  CheFu
//
//  Created by gulu on 15/8/12.
//  Copyright (c) 2015年 lianan. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "MBProgressHUD.h"
#import "GLViewModel.h"

@implementation GLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.child = (id<BaseVCManager>)self;
    
    [self initialzieBaseModel];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
}

- (void)initialzieBaseModel {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![self.child respondsToSelector:@selector(viewModel)]) {
        NSAssert(NO, @"子类必须要有viewModel");
    }
#pragma clang diagnostic pop
    
    if ([self.child valueForKeyPath: @"viewModel"] == nil) {
        NSAssert(NO, @"子类viewModel不能为nil");
    }
    
    if ([[self.child valueForKeyPath: @"viewModel"] superclass] != [GLViewModel class]) {
        NSAssert(NO, @"VC中的viewModel必须为GLViewModel的子类");
    }
    
    GLViewModel *viewModel = [self.child valueForKeyPath: @"viewModel"];
    if (viewModel == nil) {
        NSAssert(NO, @"子类必须要有viewModel");
    }
}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

- (void)showActivityHudByText:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = text;
}

- (void)hideActivityHud {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)hideKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/**
 *  去掉多余的分割线
 *
 *  @param tableView 要去掉多余分割线的tableview
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
