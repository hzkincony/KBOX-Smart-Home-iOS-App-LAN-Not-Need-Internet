//
//  KinconySceneCommand.h
//  KBOX
//
//  Created by gulu on 2020/7/8.
//  Copyright © 2020 kincony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KinconyDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface KinconySceneCommand : NSObject

@property (nonatomic, strong) KinconyDevice *kinconyDevice;
@property (nonatomic, strong) NSString *commandStr;

@end

NS_ASSUME_NONNULL_END
