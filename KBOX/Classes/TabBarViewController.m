//
//  TabBarViewController.m
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    UITabBarItem* itemDevices = [self.tabBar.items objectAtIndex:0];
    itemDevices.title = NSLocalizedString(@"tabbarDevices", nil);
//    [itemDevices setSelectedImage:[[UIImage imageNamed:@"img_tabbar_search_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [itemDevices setImage:[[UIImage imageNamed:@"img_tabbar_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    UITabBarItem* itemScene = [self.tabBar.items objectAtIndex:1];
//    itemScene.title = NSLocalizedString(@"tabbarScene", nil);
    
    UITabBarItem* itemSetting = [self.tabBar.items objectAtIndex:1];
    itemSetting.title = NSLocalizedString(@"tabbarSetting", nil);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
