//
//  KinconyServerManager.h
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KinconyServerManager : NSObject

@property (nonatomic, assign) BOOL useServer;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) NSInteger port;

+ (KinconyServerManager*)sharedManager;

- (void)saveServer:(NSString*)ipAddress withPort:(NSInteger)port;

@end

NS_ASSUME_NONNULL_END
