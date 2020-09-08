//
//  ServerConfigVM.h
//  KBOX
//
//  Created by gulu on 2020/9/7.
//  Copyright © 2020 kincony. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerConfigVM : GLViewModel

@property (nonatomic, strong) RACSubject *saveServerConfigSignal;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *port;

- (void)saveServerConfig;

@end

NS_ASSUME_NONNULL_END
