//
//  SettingVM.m
//  KBOX
//
//  Created by gulu on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "SettingVM.h"
#import "KinconyServerManager.h"

@implementation SettingVM

- (void)initializeData {
    self.version = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.useServer = [NSNumber numberWithBool:[KinconyServerManager sharedManager].useServer];
};

#pragma mark - setters and getters

- (void)setUseServer:(NSNumber *)useServer {
    _useServer = useServer;
    [KinconyServerManager sharedManager].useServer = useServer.boolValue;
}

@end
