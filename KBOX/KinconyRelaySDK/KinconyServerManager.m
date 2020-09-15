//
//  KinconyServerManager.m
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "KinconyServerManager.h"
#import <YYCache.h>

static NSString * const DefaultIP = @"47.254.135.197";
static NSInteger const DefaultPort = 9000;

static NSString * const ServerCacheName = @"ServerCache";
static NSString * const ServerCache_useServer = @"ServerCache_useServer";
static NSString * const ServerCache_ipAddress = @"ServerCache_ipAddress";
static NSString * const ServerCache_port = @"ServerCache_port";

@interface KinconyServerManager()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation KinconyServerManager

static KinconyServerManager *sharedManager = nil;

+ (KinconyServerManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
        NSNumber *useServerNum = (NSNumber*)[sharedManager.cache objectForKey:ServerCache_useServer];
        if (useServerNum != nil) {
            sharedManager.useServer = [useServerNum boolValue];
        } else {
            sharedManager.useServer = NO;
        }
        
        NSString *ipAddress = (NSString*)[sharedManager.cache objectForKey:ServerCache_ipAddress];
        if (ipAddress != nil) {
            sharedManager.ipAddress = ipAddress;
        } else {
            sharedManager.ipAddress = DefaultIP;
        }
        
        NSNumber *portNum = (NSNumber*)[sharedManager.cache objectForKey:ServerCache_port];
        if (portNum != nil) {
            sharedManager.port = [portNum integerValue];
        } else {
            sharedManager.port = DefaultPort;
        }
    });
    return sharedManager;
}

#pragma mark - public methods

- (void)saveServer:(NSString *)ipAddress withPort:(NSInteger)port {
    self.ipAddress = ipAddress;
    self.port = port;
    [self.cache setObject:ipAddress forKey:ServerCache_ipAddress];
    [self.cache setObject:[NSNumber numberWithInteger:port] forKey:ServerCache_port];
}

#pragma mark - setters and getters

- (YYCache *)cache {
    if (_cache == nil) {
        self.cache = [YYCache cacheWithName:ServerCacheName];
    }
    return _cache;
}

- (void)setUseServer:(BOOL)useServer {
    _useServer = useServer;
    [self.cache setObject:[NSNumber numberWithBool:_useServer] forKey:ServerCache_useServer];
}

@end
