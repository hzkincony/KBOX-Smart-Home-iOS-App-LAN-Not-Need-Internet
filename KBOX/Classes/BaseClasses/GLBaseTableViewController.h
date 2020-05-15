//
//  BaseTableViewController.h
//  CheFu
//
//  Created by gulu on 15/8/12.
//  Copyright (c) 2015年 lianan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseVCManager <NSObject>

@optional
- (UIView*)nodataView;
- (UIView*)wirelessView;
- (BOOL)autoShowEmptyView;

@end

@interface GLBaseTableViewController : UITableViewController

@property (nonatomic, weak) NSObject<BaseVCManager> *child;

- (void)showTextHud:(NSString*)msg;

- (void)showActivityHudByText:(NSString*)text;

- (void)hideActivityHud;

- (void)hideKeyBoard;

@end
