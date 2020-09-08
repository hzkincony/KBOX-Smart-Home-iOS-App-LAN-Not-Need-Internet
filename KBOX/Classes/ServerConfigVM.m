//
//  ServerConfigVM.m
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "ServerConfigVM.h"
#import "KinconyServerManager.h"

@implementation ServerConfigVM

- (void)initializeData {
    self.saveServerConfigSignal = [RACSubject subject];
    self.ipAddress = [KinconyServerManager sharedManager].ipAddress;
    self.port = [NSString stringWithFormat:@"%ld", (long)[KinconyServerManager sharedManager].port];
}

#pragma mark - public methods

- (void)saveServerConfig {
    if (self.ipAddress == nil || self.ipAddress.length == 0) {
        [self.saveServerConfigSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseInputIP", nil) code:-1 userInfo:nil]];
        return;
    }
    if (self.port == nil || self.port.length == 0) {
        [self.saveServerConfigSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseInputPort", nil) code:-1 userInfo:nil]];
        return;
    } else if (![self judgeIsNumberByRegularExpressionWith:self.port]) {
        [self.saveServerConfigSignal sendNext:[NSError errorWithDomain:NSLocalizedString(@"pleaseInputPort", nil) code:-1 userInfo:nil]];
        return;
    }
    [[KinconyServerManager sharedManager] saveServer:self.ipAddress withPort:[self.port integerValue]];
    [self.saveServerConfigSignal sendNext:@""];
}

#pragma mark - private methods

- (BOOL)judgeIsNumberByRegularExpressionWith:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

@end
