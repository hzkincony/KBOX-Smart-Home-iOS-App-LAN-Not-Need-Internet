//
//  BaseViewController.h
//  CheFu
//
//  Created by gulu on 15/8/12.
//  Copyright (c) 2015年 lianan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBaseViewController : UIViewController

@property (nonatomic, assign) CGFloat multiples;                        //不同屏幕尺寸的比列,设计时按6的尺寸设计

- (void)showTextHud:(NSString*)msg;

- (void)showActivityHudByText:(NSString*)text;

- (void)hideActivityHud;

- (void)hideKeyBoard;

@end
