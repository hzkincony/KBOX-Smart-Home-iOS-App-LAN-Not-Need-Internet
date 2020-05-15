//
//  DeviceImageCellVM.m
//  KBOX
//
//  Created by 顾越超 on 2019/4/9.
//  Copyright © 2019 kincony. All rights reserved.
//

#import "DeviceImageCellVM.h"

@implementation DeviceImageCellVM

- (id)initWithImageName:(NSString *)imageName {
    if ((self = [super init])) {
        self.imageName = imageName;
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}

@end
