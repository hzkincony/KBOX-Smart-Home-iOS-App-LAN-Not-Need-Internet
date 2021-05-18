//
//  SettingVM.m
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SettingVM.h"
#import "KinconyRelay.h"

@implementation SettingVM

- (void)initializeData {
    self.version = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
};

#pragma mark - setters and getters

@end
